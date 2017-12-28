//
//  WebViewJsonRPC.m
//  WebViewJsonRPC
//
//  Created by Xuhui on 13-10-27.
//  Copyright (c) 2013年 Xuhui. All rights reserved.
//

#include <objc/message.h>
#import "WebViewJsonRPC.h"
#import "ServiceManager.h"

NSString * const JsBridgeConnectNotification        = @"JsBridgeConnectNotification";
NSString * const JsBridgeCloseNotification          = @"JsBridgeCloseNotification";
NSString * const JsBridgeWebFinishLoadNotification  = @"JsBridgeWebFinishLoadNotification";

static NSString * const JsonRPCScheme               = @"jsonrpc";
static NSString * const JsonRPCData                 = @"rpcdata";
static NSString * const JsonRPCCall                 = @"rpccall";

static NSString * const JsonRPCVer                  = @"2.0";
static NSString * const MethodTag                   = @"method";
static NSString * const ParamsTag                   = @"params";
static NSString * const IDTag                       = @"id";
static NSString * const ResultTag                   = @"result";
static NSString * const ErrorTag                    = @"error";
static NSString * const ErrorCodeTag                = @"code";
static NSString * const ErrorMessageTag             = @"message";
static NSString * const ErrorDataTag                = @"data";

static NSString * const MethodNotFoundCode          = @"32601";
static NSString * const MethodNotFoundMessage       = @"The method does not exist / is not available";

static NSString * const JsFileName = @"WebViewJsonRPC.js";

#define JsCloseRPC @";if(window.jsonRPC) {window.jsonRPC.close()};"

#define MethodNotFoundError [NSDictionary dictionaryWithObjectsAndKeys:MethodNotFoundCode, ErrorCodeTag, MethodNotFoundMessage, ErrorMessageTag, nil]

@interface WebViewJsonRPC () {
    NSInteger _loadCount;
}

@property (weak, nonatomic) id<UIWebViewDelegate> originDelegate;
@property (strong, nonatomic) NSMutableDictionary *handlers;
@property (strong, nonatomic) ServiceManager *serviceManager;

- (void)error:(NSDictionary *)error ID:(NSNumber *)rpcID;
- (void)respone:(id)res ID:(NSNumber *)rpcID;
- (void)callHandler:(NSString *)name Params:(NSDictionary *)params ID:(NSNumber *)ID Callback:(JsonRPCCallback)cb;

+ (BOOL)valid:(NSDictionary *)dict;

@end

@implementation WebViewJsonRPC

#pragma mark - Life Cycle

- (id)init {
    self = [super init];
    if(self != nil) {
        _handlers = [[NSMutableDictionary alloc] init];
        _webView = nil;
        _controller = nil;
        _originDelegate = nil;
        _serviceManager = [[ServiceManager alloc] initWithConfig:[[JSBridgeConfig sharedInstance] serviceConfig]];
        _loadCount = 0;
    }
    return self;
}

- (void)dealloc {
    [self close];
}

#pragma mark - Public Methods

#pragma mark Jsbridge连接、关闭和准备

- (void)connect:(UIWebView *)webView Controller:(id)controller {
    if(webView == self.webView) return;
    if(self.webView != nil) {
        [self close];
    }
    self.controller = controller;
    self.webView = webView;
    self.originDelegate = webView.delegate;
    self.webView.delegate = self;
    [self registerAllService];
    [self registerKVO];
    [[NSNotificationCenter defaultCenter] postNotificationName:JsBridgeConnectNotification object:self userInfo: @{@"bridge":self}];
    
}

- (void)close {
    [self unregisterKVO];
    if(self.webView == nil) return;
    [[NSNotificationCenter defaultCenter] postNotificationName:JsBridgeCloseNotification object:self];
    [self jsEval:JsCloseRPC];
    self.webView.delegate = self.originDelegate;
    self.originDelegate = nil;
    self.webView = nil;
    self.controller = nil;
    [self.handlers removeAllObjects];
    //[BridgeURLProtocol unregisterBridgeURLProtocol];
    //[BridgeWebCache dispose];
}

- (void)webReady {
    BOOL isDebug = NO;
    if([self.controller respondsToSelector:@selector(isDebugMode)]) {
        isDebug = [self.controller isDebugMode];
    }
    [self ready:isDebug];
}

#pragma mark 执行Js脚本

- (void)jsEval:(NSString *)js {
    //if(![NSThread isMainThread]) {
    [self performSelectorOnMainThread:@selector(jsEvalIntrnal:) withObject:js waitUntilDone:YES];
    //} else {
    //    [self jsMainLoopEval:js];
    //}
}

- (NSString *)jsMainLoopEval:(NSString *)js {
    return [self jsEvalIntrnal:js];
}

#pragma mark 根据Domain获取service的Class

- (id)getServiceByName:(NSString *)name {
    return [self.serviceManager getServiceByDomain:name];
}

#pragma mark 触发Js事件

- (void)triggerEvent:(NSString *)type withDetail:(NSDictionary *)detail {
    [self jsEval:[NSString stringWithFormat:@";window.jsonRPC.nativeEvent.trigger('%@', %@);", type, [WebViewJsonRPC jsonDictToString:detail]]];
}

#pragma mark 判断某事件是否能被成功响应

- (BOOL)webRespondsToEvent:(NSString *)type {
    NSString *js = [NSString stringWithFormat:@";window.jsonRPC.nativeEvent.respondsToEvent('%@').toString();", type];
    NSString *res = [self jsEvalIntrnal:js];
    return [res isEqualToString:@"true"];
}

#pragma mark - Private Methods

#pragma mark 服务注册

- (void)registerAllService {
    NSSet *set = [self.serviceManager getExports];
    [set enumerateObjectsUsingBlock:^(id obj, BOOL *stop) {
        JsonRPCHandler handler = [self selectorToBlock:obj];
        if(handler) {
            [self registerHandler:obj Handler:handler];
        }
    }];
}

- (JsonRPCHandler)selectorToBlock:(NSString *)name {
    
    SEL sel = [self.serviceManager showNameToSelector:name];
    if(sel == nil) return NULL;
    ServiceInfo *serviceInfo = [self.serviceManager getServiceInfo:name];
    ExportDetail *detail = [serviceInfo getDetailByShowName:name];
    WebViewJsonRPCPermission permission = WebViewJsonRPCPermissionNormal;
    if([self.controller respondsToSelector:@selector(getPermission)]) {
        permission = [self.controller getPermission];
    }
    if(permission >= detail.level) {
        __weak id instance = serviceInfo.instance;
        return [(^(NSDictionary *params, JsonRPCCallback cb) {
            // objc_msgSend在64位下的正确调用方式参见文档
            // https://developer.apple.com/library/ios/documentation/General/Conceptual/CocoaTouch64BitGuide/ConvertingYourAppto64-Bit/ConvertingYourAppto64-Bit.html#//apple_ref/doc/uid/TP40013501-CH3-SW22
            void (*handler)(id, SEL, NSDictionary *, JsonRPCCallback) = (void (*)(id, SEL, NSDictionary *, JsonRPCCallback)) objc_msgSend;
            handler(instance, sel, params, cb);
        }) copy];
    } else {
        return nil;
    }
}

- (void)registerHandler:(NSString *)name Handler:(JsonRPCHandler)handler {
    [self.handlers setObject:[handler copy] forKey:name];
}

- (void)unregisterHandler:(NSString *)name {
    [self.handlers removeObjectForKey:name];
}


#pragma mark KVO
- (void)registerKVO {
    [_webView addObserver:self forKeyPath:@"delegate" options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew context:nil];
}

- (void)unregisterKVO {
    [_webView removeObserver:self forKeyPath:@"delegate"];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    id newDelegate = change[@"new"];
    if(object == self.webView && [keyPath isEqualToString:@"delegate"] && newDelegate != self) {
        self.originDelegate = newDelegate;
        self.webView.delegate = self;
    }
}

#pragma mark 执行Js脚本内部方法

- (NSString *)jsEvalIntrnal:(NSString *)js {
    if(self.webView) {
        return [self.webView stringByEvaluatingJavaScriptFromString:js];
    } else {
        return nil;
    }
}

#pragma mark Util Methods

+ (NSString *)jsonDictToString:(NSDictionary *)json {
    if(json == nil) return @"null";
    NSData *data = [NSJSONSerialization dataWithJSONObject:json options:NSJSONWritingPrettyPrinted error:nil];
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}

+ (NSString *)jsonDictArrayToString:(NSArray *)jsons {
    NSMutableString *tmp = [NSMutableString stringWithString:@"["];
    [jsons enumerateObjectsUsingBlock:^(id obj, NSUInteger index, BOOL *stop) {
        [tmp appendString:[WebViewJsonRPC jsonDictToString:obj]];
        [tmp appendString:@","];
    }];
    [tmp appendString:@"]"];
    return tmp;
}

+ (NSMutableDictionary *)stringToJsonDict:(NSString *)str {
    if(str == nil || [str isEqual:[NSNull null]]) return nil;
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    return [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
}

+ (BOOL)valid:(NSDictionary *)dict {
    
    NSString *jsonRPCVer = [dict objectForKey:JsonRPCScheme];
    if(jsonRPCVer != nil && [jsonRPCVer isEqualToString:JsonRPCVer])
        return YES;
    else
        return NO;
}

- (NSDictionary *)webGlobalJsonData:(NSString *)key {
    NSString *js = [NSString stringWithFormat:@";JSON.stringify(window.%@);", key];
    NSString *res = [self jsEvalIntrnal:js];
    return [WebViewJsonRPC stringToJsonDict:res];
}

#pragma mark 调用错误的回调方法

- (void)error:(NSDictionary *)error ID:(NSNumber *)rpcID {
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:JsonRPCVer, JsonRPCScheme, error, ErrorTag, rpcID, IDTag, nil];
    NSString *tmp = [WebViewJsonRPC jsonDictToString:dict];
    [self jsEval:[NSString stringWithFormat:@";window.jsonRPC.onMessage(%@);", tmp]];
}

#pragma mark 给Js端的回调，通过ID做为唯一标识符，将参数带回

- (void)respone:(id)res ID:(NSNumber *)rpcID {
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:JsonRPCVer, JsonRPCScheme, res ? res : [NSNull null], ResultTag, rpcID, IDTag, nil];
    NSString *tmp = [WebViewJsonRPC jsonDictToString:dict];
    [self jsEval:[NSString stringWithFormat:@";window.jsonRPC.onMessage(%@);", tmp]];
}

#pragma mark Ready执行Js的方法

- (void)ready:(BOOL)isTestMode {
    if(isTestMode && [self.controller respondsToSelector:@selector(debugChannel)]) {
         [self jsEval:[NSString stringWithFormat:@";window.jsonRPC.setDebugChannel('%@');", [self.controller performSelector:@selector(debugChannel)]]];
    }
   
    [self jsEval:[NSString stringWithFormat:@";window.jsonRPC.ready(%@);", [NSNumber numberWithBool:isTestMode]]];
}

#pragma mark 获取Js队列的压栈Json数据，读出方法名和参数等内容

- (NSString *)fetchJsCommand {
    return [self jsEvalIntrnal:@";window.jsonRPC.nativeFetchCommand();"];
}

#pragma mark - UIWebViewDelegate

- (void)webViewDidStartLoad:(UIWebView *)webView {
    if(webView != self.webView) return;
    //NSString *path = [[NSBundle mainBundle] pathForResource:JsFileName ofType:@"txt"];
    //NSString *js = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    //[self jsMainLoopEval:js];
    if([self.originDelegate respondsToSelector:@selector(webViewDidStartLoad:)]) {
        [self.originDelegate webViewDidStartLoad:webView];
    }
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    if(webView != self.webView) return;
    
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    NSBundle *resourceBundle = [NSBundle bundleWithPath:[bundle pathForResource:@"LDKWWebViewController" ofType:@"bundle"]];
    NSString *path = [resourceBundle pathForResource:JsFileName ofType:@"txt"];
    NSString *js = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    [self jsMainLoopEval:js];
    
    NSString *jsApi = [[JSBridgeConfig sharedInstance] jsApi];
    [self jsMainLoopEval:jsApi];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:JsBridgeWebFinishLoadNotification object:self];
    
    if([self.originDelegate respondsToSelector:@selector(webViewDidFinishLoad:)]) {
        [self.originDelegate webViewDidFinishLoad:webView];
    }
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    if(webView != self.webView) return YES;
    BOOL res = NO;
    NSURL *url = [request URL];
    NSString *scheme = [[url scheme] lowercaseString];
    NSString *host = [[url host] lowercaseString];
    if([scheme isEqualToString:JsonRPCScheme] && [host isEqualToString:JsonRPCCall]) {
        NSDictionary *json = [WebViewJsonRPC stringToJsonDict:[self fetchJsCommand]];
        if([WebViewJsonRPC valid:json]) {
            NSString *method = [json objectForKey:MethodTag];
            id p = [json objectForKey:ParamsTag];
            NSDictionary *params = p != [NSNull null] ? p : nil;
            //[params setObject:url forKey:@"__url"];
            NSNumber *ID = [json objectForKey:IDTag];
            __weak WebViewJsonRPC *weakSelf = self;
            dispatch_async(dispatch_get_main_queue(), ^(){
                [weakSelf callHandler:method Params:params ID:(NSNumber *)ID Callback:^(id result) {
                    if(ID != nil) {
                        [weakSelf respone:result ID:ID];
                    }
                }];
            });
        }
        [self triggerEvent:@"NativeReady" withDetail:nil];
        
        return NO;
    }
    
    if([scheme isEqualToString:@"about"]) return NO;
    
    if([self.originDelegate respondsToSelector:@selector(webView:shouldStartLoadWithRequest:navigationType:)]) {
        res |= [self.originDelegate webView:webView shouldStartLoadWithRequest:request navigationType:navigationType];
    } else {
        res = YES;
    }
    
    return res;
}

- (void)callHandler:(NSString *)name Params:(NSDictionary *)params ID:(NSNumber *)ID Callback:(JsonRPCCallback)cb {
    JsonRPCHandler handler = [self.handlers objectForKey:name];
    if(!handler) {
        if(ID != nil) [self error:MethodNotFoundError ID:ID];
        return;
    }
    handler(params, cb);
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    if(webView != self.webView) return;
   
    if([self.originDelegate respondsToSelector:@selector(webView:didFailLoadWithError:)]) {
        [self.originDelegate webView:webView didFailLoadWithError:error];
    }
}

@end
