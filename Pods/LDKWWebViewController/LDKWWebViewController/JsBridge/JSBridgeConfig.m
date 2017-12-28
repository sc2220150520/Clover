//
//  JSBridgeConfig.m
//  Pods
//
//  Created by david on 16/4/8.
//
//

#import "JSBridgeConfig.h"

static NSString *const prefix = @";(function() { var jsbridge = window.KiwiJsBridge; window.KiwiJsApi = {";
static NSString *const suffix = @"};})();";

@interface JSBridgeConfig ()

@property (nonatomic, strong) NSMutableDictionary *serviceConfigDict;
@property (nonatomic, strong) NSMutableDictionary *jsApiConfigDict;

@end

@implementation JSBridgeConfig

+ (instancetype)sharedInstance
{
    static JSBridgeConfig *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[JSBridgeConfig alloc] init];
    });
    return instance;
}

- (instancetype)init
{
    if (self = [super init]) {
        
        _serviceConfigDict = [NSMutableDictionary dictionary];
        _jsApiConfigDict = [NSMutableDictionary dictionary];
        
    }
    return self;
}

- (void)registerJSApi:(NSString *)domain service:(NSString *)clsName selectors:(NSArray<NSArray *> *)sels local:(BOOL)isLocal
{
    if (!domain|| !clsName || ![sels count]) {
        return;
    }
    
    NSMutableArray *jsApiAray = self.jsApiConfigDict[domain];
    NSMutableArray *jsApiList = nil;
    if (!jsApiAray || ![jsApiAray count]) {
        jsApiList = [NSMutableArray array];
        self.jsApiConfigDict[domain] = jsApiList;
    } else {
        jsApiList = jsApiAray;
    }
    
    NSDictionary *serviceDict = self.serviceConfigDict[clsName];
    NSMutableArray *exportList = nil;
    if (!serviceDict) {
        exportList = [NSMutableArray array];
        self.serviceConfigDict[clsName] = @{@"domain":clsName,
                                            @"islocal":@(isLocal),
                                            @"exports":exportList};
    } else {
        exportList = self.serviceConfigDict[clsName][@"exports"];
    }
    
    [sels enumerateObjectsUsingBlock:^(NSArray * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[NSArray class]] && [obj count] >= 2 ) {
            
            NSNumber *level = [obj firstObject];
            NSString *showName = obj[1];
            NSString *realName = [obj lastObject];
            NSDictionary *export = @{@"level":level,
                                     @"showname":showName,
                                     @"realname":realName};
            
            if (![jsApiList containsObject:showName]) {
                [jsApiList addObject:showName];
            }
            
            if (![exportList containsObject:export]) {
                [exportList addObject:export];
            }
        }
    }];
}

- (NSArray *)serviceConfig
{
    return [[self.serviceConfigDict allValues] copy];
}

- (NSString *)jsApi
{
    if (![self.jsApiConfigDict count]) {
        return nil;
    }
    
    NSMutableString *jsApiString = [NSMutableString string];
    [jsApiString appendString:prefix];
    
    [self.jsApiConfigDict enumerateKeysAndObjectsUsingBlock:^(NSString *_Nonnull domain, NSArray *  _Nonnull funcs, BOOL * _Nonnull stop) {
        NSMutableString *domainString = [NSMutableString stringWithFormat:@"%@ : {",domain];
        [funcs enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSString *string = [NSString stringWithFormat:@"%@ : function(params, callback){jsbridge.invoke('%@', params, callback);}",obj,obj];
            [domainString appendString:string];
            if (idx < [funcs count]-1) {
                [domainString appendString:@","];
            }
        }];
        [domainString appendString:@"},"];
        [jsApiString appendString:domainString];
    }];
    
    [jsApiString appendString:suffix];
    
    return [jsApiString copy];
}

- (void)resignAllConfig
{
    [self.serviceConfigDict removeAllObjects];
    [self.jsApiConfigDict removeAllObjects];
}

@end
