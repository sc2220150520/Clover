//
//  WebViewJsonRPC.h
//  WebViewJsonRPC
//
//  Created by Xuhui on 13-10-27.
//  Copyright (c) 2013年 Xuhui. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "JSBridgeConfig.h"

typedef enum {
    WebViewJsonRPCPermissionNormal        = 0,
    WebViewJsonRPCPermissionTrustedPay    = 1,
    WebViewJsonRPCPermissionOfficial      = 10
} WebViewJsonRPCPermission;

extern NSString *const JsBridgeConnectNotification;
extern NSString *const JsBridgeCloseNotification;
extern NSString *const JsBridgeWebFinishLoadNotification;

@protocol WebViewJsonRPCProtocol <NSObject>

- (WebViewJsonRPCPermission)getPermission;
- (BOOL)isDebugMode;

@optional
- (NSString *)debugChannel;
- (void)onHashChange;

@end

typedef void (^JsonRPCCallback)(id);

typedef void (^JsonRPCHandler)(NSDictionary *, JsonRPCCallback);


@interface WebViewJsonRPC : NSObject <UIWebViewDelegate>

@property (weak, nonatomic) UIWebView *webView;
@property (weak, nonatomic) id controller;

/**
 *  连接Jsbridge
 *
 *  @param webView    webView
 *  @param controller webView的Controller
 */
- (void)connect:(UIWebView *)webView Controller:(id)controller;

/**
 *  关闭Jsbridge
 */
- (void)close;

/**
 *  页面加载结束后调用，告诉前端Jsbridge已准备完成
 */
- (void)webReady;


/**
 *  执行Js脚本
 *
 *  @param js Js脚本
 */
- (void)jsEval:(NSString *)js;

/**
 *  在主线程执行Js脚本
 *
 *  @param js Js脚本
 *
 *  @return 执行结果
 */
- (NSString *)jsMainLoopEval:(NSString *)js; // 只能在主线程调用

/**
 *  触发Js事件
 *
 *  @param type   事件名
 *  @param detail 参数
 */
- (void)triggerEvent:(NSString *)type withDetail:(NSDictionary *)detail;

/**
 *  判断一个事件能否被正确触发
 *
 *  @param type 事件名
 *
 *  @return Js脚本执行结果，Js为空或失败为NO
 */
- (BOOL)webRespondsToEvent:(NSString *)type;

/**
 *  根据Domain获取service的Class
 *
 *  @param name Domain(ServiceConfig.json)
 *
 *  @return service对象，serviceConfig中对应的
 */
- (id)getServiceByName:(NSString *)name;

@end
