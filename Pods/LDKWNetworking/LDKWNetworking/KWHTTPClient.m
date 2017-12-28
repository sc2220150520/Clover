//
//  KWHTTPClient.m
//  AFNetworking
//
//  Created by lixingdong on 2017/10/16.
//

#import "KWHTTPClient.h"
#import "LDKWAPIEncrypt.h"
#import "AFURLResponseSerialization.h"

NSString * const kLDKWNetworkingOriginalErrorKey = @"com.ldkwnetworking.originalError";

@implementation KWHTTPClient

+ (instancetype)sharedInstance
{
    static KWHTTPClient *_sharedClient = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        _sharedClient = [[KWHTTPClient alloc] init];
    });
    return _sharedClient;
}

- (void)configClientWithInterfaceHeader:(NSString *)interfaceHeader
                              userAgent:(NSString *)userAgent
                               sslHosts:(NSSet<NSString *> *)sslHosts
{
    [LDAPIManager sharedAPIManager].configuration.interfaceHeader = interfaceHeader;
    [LDAPIManager sharedAPIManager].configuration.userAgent = userAgent;
    [LDAPIManager sharedAPIManager].configuration.sslHosts = sslHosts;
    
    //设置默认的加密block
    [LDAPIManager sharedAPIManager].configuration.apiEncyptPostRequestBlock = ^(NSData *postBody, NSString *timeStamp){
        return [LDKWAPIEncrypt encyptPostData:postBody timeStamp:timeStamp];
    };
}

- (LDBaseAPI *)sendRequestWithMethod:(LDRequestMethodType)method
                                path:(NSString *)path
                          parameters:(NSDictionary *)parameters
                         contentType:(LDResponseSerializerType)contentType
                     completionBlock:(void (^)(LDBaseAPI * _Nonnull api, id responseObject, NSError *error))completionBlock
{
    LDGeneralAPI *gapi = [[LDGeneralAPI alloc] init];
    gapi.apiRequestMethodType = method;
    gapi.apiRequestUrl = path;
    gapi.apiRequestParameters = parameters;
    gapi.apiResponseSerializerType = contentType;
    void(^newBlock)(LDBaseAPI *,id, NSError *) = [self changeDescBlockWithBlock:completionBlock];
    gapi.apiCompletionHandler = newBlock;
    [gapi start];
    
    return gapi;
}

- (LDBaseAPI *)sendRequestWithMethod:(LDRequestMethodType)method
                                path:(nonnull NSString *)path
                          parameters:(NSDictionary *)parameters
                         contentType:(LDResponseSerializerType)contentType
                             success:(void (^)(LDBaseAPI * _Nonnull api, id responseObject))success
                             failure:(void (^)(LDBaseAPI * _Nonnull api, NSError *error))failure
{
    LDGeneralAPI *gapi = [[LDGeneralAPI alloc] init];
    gapi.apiRequestMethodType = method;
    gapi.apiRequestUrl = path;
    gapi.apiRequestParameters = parameters;
    gapi.apiResponseSerializerType = contentType;
    
    void (^completionHandler)(LDBaseAPI *, id, NSError *) = ^(LDBaseAPI * _Nonnull api, id responseObject, NSError *error){
        //请求成功处理
        if(error == nil){
            if (success) {
                success(api, responseObject);
            }
        }
        //请求失败处理
        else {
            if (failure) {
                failure(api, error);
            }
        }
    };
    void(^newBlock)(LDBaseAPI *, id, NSError *) = [self changeDescBlockWithBlock:completionHandler];
    gapi.apiCompletionHandler = newBlock;
    [gapi start];
    
    return gapi;
}

- (LDBaseAPI *)sendEncyptPostRequestWithPath:(nonnull NSString *)path
                                  parameters:(NSDictionary *)parameters
                               isURLEncoding:(BOOL)isURLEncoding
                                   timeStamp:(NSString *)timeStamp
                                 contentType:(LDResponseSerializerType)contentType
                             completionBlock:(void (^)(LDBaseAPI * _Nonnull api, id responseObject, NSError *error))completionBlock
{
    LDGeneralAPI *gapi = [[LDGeneralAPI alloc] init];
    gapi.apiRequestMethodType = LDRequestMethodTypePOST;
    gapi.apiRequestUrl = path;
    gapi.apiRequestParameters = parameters;
    
    gapi.isParamURLEncoding = isURLEncoding;
    gapi.isEncyptPostRequestBody = YES;
    gapi.apiEncyptRequestTimeStamp = timeStamp;
    
    gapi.apiResponseSerializerType = contentType;
    void(^newBlock)(LDBaseAPI *,id, NSError *) = [self changeDescBlockWithBlock:completionBlock];
    gapi.apiCompletionHandler = newBlock;
    [gapi start];
    
    return gapi;
}

- (LDBaseAPI *)sendEncyptPostRequestWithPath:(nonnull NSString *)path
                                  parameters:(NSDictionary *)parameters
                               isURLEncoding:(BOOL)isURLEncoding
                                   timeStamp:(NSString *)timeStamp
                                 contentType:(LDResponseSerializerType)contentType
                                     success:(void (^)(LDBaseAPI * _Nonnull api, id responseObject))success
                                     failure:(void (^)(LDBaseAPI * _Nonnull api, NSError *error))failure
{
    LDGeneralAPI *gapi = [[LDGeneralAPI alloc] init];
    gapi.apiRequestMethodType = LDRequestMethodTypePOST;
    gapi.apiRequestUrl = path;
    gapi.apiRequestParameters = parameters;
    
    gapi.isParamURLEncoding = isURLEncoding;
    gapi.isEncyptPostRequestBody = YES;
    gapi.apiEncyptRequestTimeStamp = timeStamp;
    
    gapi.apiResponseSerializerType = contentType;
    
    void (^completionHandler)(LDBaseAPI *, id, NSError *) = ^(LDBaseAPI * _Nonnull api, id responseObject, NSError *error){
        //请求成功处理
        if(error == nil){
            if (success) {
                success(api, responseObject);
            }
        }
        //请求失败处理
        else {
            if (failure) {
                failure(api, error);
            }
        }
    };
    void (^newBlock)(LDBaseAPI *, id, NSError *) = [self changeDescBlockWithBlock:completionHandler];
    gapi.apiCompletionHandler = newBlock;
    [gapi start];
    
    return gapi;
}

- (LDBaseAPI *)multipartHTTPRequestWithPath:(nonnull NSString *)path
                                 parameters:(NSDictionary *)parameters
                                contentType:(LDResponseSerializerType)contentType
                  constructingBodyWithBlock:(void (^)(id<LDMultipartFormData>))block
                            completionBlock:(void (^)(LDBaseAPI * _Nonnull api, id responseObject, NSError *error))completionBlock;
{
    LDGeneralAPI *gapi = [[LDGeneralAPI alloc] init];
    gapi.apiRequestMethodType = LDRequestMethodTypePOST;
    gapi.apiRequestUrl = path;
    gapi.apiRequestParameters = parameters;
    
    gapi.apiRequestConstructingBodyBlock = block;
    gapi.apiResponseSerializerType = contentType;
    void (^newBlock)(LDBaseAPI *, id, NSError *) = [self changeDescBlockWithBlock:completionBlock];
    gapi.apiCompletionHandler = newBlock;
    [gapi start];
    
    return gapi;
}

- (LDBaseAPI *)multipartHTTPRequestWithPath:(nonnull NSString *)path
                                 parameters:(NSDictionary *)parameters
                                contentType:(LDResponseSerializerType)contentType
                  constructingBodyWithBlock:(void (^)(id<LDMultipartFormData>))block
                                    success:(void (^)(LDBaseAPI * _Nonnull api, id responseObject))success
                                    failure:(void (^)(LDBaseAPI * _Nonnull api, NSError *error))failure
{
    LDGeneralAPI *gapi = [[LDGeneralAPI alloc] init];
    gapi.apiRequestMethodType = LDRequestMethodTypePOST;
    gapi.apiRequestUrl = path;
    gapi.apiRequestParameters = parameters;
    
    gapi.apiRequestConstructingBodyBlock = block;
    gapi.apiResponseSerializerType = contentType;
    void (^completionHandler)(LDBaseAPI *, id, NSError *) = ^(LDBaseAPI * _Nonnull api, id responseObject, NSError *error){
        //请求成功处理
        if(error == nil){
            if (success) {
                success(api, responseObject);
            }
        }
        //请求失败处理
        else {
            if (failure) {
                failure(api, error);
            }
        }
    };
    void (^newBlock)(LDBaseAPI *,id,NSError *) = [self changeDescBlockWithBlock:completionHandler];
    gapi.apiCompletionHandler = newBlock;
    [gapi start];
    
    return gapi;
}

//该方法对于网络请求错误描述进行替换和特殊设置。
- (void(^)(LDBaseAPI *,id,NSError *))changeDescBlockWithBlock:(void (^)(LDBaseAPI * _Nonnull api, id responseObject, NSError *error))block
{
    void(^newBlock)(LDBaseAPI *,id,NSError *) = ^(LDBaseAPI * _Nonnull api, id responseObject, NSError *error) {
        if (error) {
            if (error.code == NSURLErrorBadServerResponse
                && [error.domain isEqualToString: AFURLResponseSerializationErrorDomain]) {
                //备注这段httpStatusCode的获取逻辑依赖于AFNetworking里面的代码，AF里面的代码把非正常的httpcode放到了localizedDescription里面
                if ([error.localizedDescription containsString:@"403"]) {
                    NSMutableDictionary *mutableUserInfo = [error.userInfo mutableCopy];
                    [mutableUserInfo setObject:@"系统有点累，稍候再试吧" forKey:NSLocalizedDescriptionKey];
                    [mutableUserInfo setObject:error forKey:kLDKWNetworkingOriginalErrorKey];
                    NSError *newError = [NSError errorWithDomain:error.domain code:error.code userInfo:mutableUserInfo];
                    block(api,responseObject,newError);
                    return ;
                }
                if ([error.localizedDescription containsString:@"502"]) {
                    NSMutableDictionary *mutableUserInfo = [error.userInfo mutableCopy];
                    [mutableUserInfo setObject:@"网络失联啦，稍候再试吧" forKey:NSLocalizedDescriptionKey];
                    [mutableUserInfo setObject:error forKey:kLDKWNetworkingOriginalErrorKey];
                    NSError *newError = [NSError errorWithDomain:error.domain code:error.code userInfo:mutableUserInfo];
                    block(api,responseObject,newError);
                    return ;
                }
            }
            //其他情况，统一改为网络不给力
            NSMutableDictionary *mutableUserInfo = [error.userInfo mutableCopy];
            [mutableUserInfo setObject:@"网络不给力" forKey:NSLocalizedDescriptionKey];
            [mutableUserInfo setObject:error forKey:kLDKWNetworkingOriginalErrorKey];
            NSError *newError = [NSError errorWithDomain:error.domain code:error.code userInfo:mutableUserInfo];
            block(api,responseObject,newError);
        } else {
            block(api,responseObject,nil);
        }
    };
    return newBlock;
}

@end


