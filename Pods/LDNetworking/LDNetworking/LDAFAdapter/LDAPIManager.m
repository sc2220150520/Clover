//
//  LDAPIManager.m
//  LDCPNetworking
//
//  Created by philon on 16/7/19.
//  Copyright © 2016年 xuguoxing. All rights reserved.
//

#import "LDAPIManager.h"
#import "LDAPIDefines.h"
#import <AFNetworking/AFNetworking.h>
#import "LDAFHTTPRequestSerializer.h"

static NSString * const LDAPIManagerLockName = @"com.lede.library.networking.api.manager.lock";

static dispatch_queue_t ld_api_task_creation_queue() {
    static dispatch_queue_t ld_api_task_creation_queue;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        ld_api_task_creation_queue =
        dispatch_queue_create("com.lede.library.networking.api.creation", DISPATCH_QUEUE_SERIAL);
    });
    return ld_api_task_creation_queue;
}


@interface LDAPIManager ()

@property (nonatomic, strong) NSMutableDictionary *sessionManagerCache;
@property (nonatomic, strong) NSMutableDictionary *sessionTasksCache;
@property (nonatomic, strong) NSLock *lock;

@end


@implementation LDAPIManager

#pragma mark - life cycle method

+ (LDAPIManager *)sharedAPIManager {
    static LDAPIManager *sharedAPIManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedAPIManager = [[self alloc] init];
    });
    return sharedAPIManager;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.configuration = [[LDAPIConfig alloc] init];
        _lock = [[NSLock alloc] init];
        _lock.name = LDAPIManagerLockName;
    }
    return self;
}


#pragma mark - Serializer

/**
 * 根据API接口设置requestSerializer
 */
- (AFHTTPRequestSerializer *)requestSerializerForAPI:(LDBaseAPI *)api {
    NSParameterAssert(api);
    
    LDAFHTTPRequestSerializer *requestSerializer = [LDAFHTTPRequestSerializer serializer];
    if ([api isEncyptPostRequestBody] && self.configuration.apiEncyptPostRequestBlock) {
        requestSerializer.apiEncyptPostRequestBlock = self.configuration.apiEncyptPostRequestBlock;
        requestSerializer.timeStamp = [api apiEncyptRequestTimeStamp];
    }
    requestSerializer.cachePolicy          = [api apiRequestCachePolicy];
    requestSerializer.timeoutInterval      = [api apiRequestTimeoutInterval];
    NSDictionary *requestHeaderFieldParams = [api apiRequestHTTPHeaderField];
    if (![[requestHeaderFieldParams allKeys] containsObject:@"User-Agent"] &&
        self.configuration.userAgent) {
        [requestSerializer setValue:self.configuration.userAgent forHTTPHeaderField:@"User-Agent"];
    }
    if (requestHeaderFieldParams) {
        [requestHeaderFieldParams enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            [requestSerializer setValue:obj forHTTPHeaderField:key];
        }];
    }
    
    return requestSerializer;
}

/**
 * 根据API接口设置responseSerializer
 */
- (AFHTTPResponseSerializer *)responseSerializerForAPI:(LDBaseAPI *)api {
    NSParameterAssert(api);
    AFHTTPResponseSerializer *responseSerializer;
    if ([api apiResponseSerializerType] == LDResponseSerializerTypeJSON) {
        responseSerializer = [AFJSONResponseSerializer serializer];
    } else if ([api apiResponseSerializerType] == LDResponseSerializerTypeXML){
        responseSerializer = [AFXMLParserResponseSerializer serializer];
    } else {
        responseSerializer = [AFHTTPResponseSerializer serializer];
    }
    
    if ([api apiResponseAcceptableContentTypes] != nil) {
        responseSerializer.acceptableContentTypes = [api apiResponseAcceptableContentTypes];
    }

    return responseSerializer;
}

/**
 * 根据API接口获取对应的安全策略
 */
- (AFSecurityPolicy *)securityPolicyWithAPI:(LDBaseAPI *)api {
    NSUInteger pinningMode                  = api.apiSecurityPolicy.SSLPinningMode;
    
    //如果没有在Configuration中配置使用SSL，默认采用不验证任何证书
    NSURL *requestURL = [NSURL URLWithString:[api apiRequestUrl]];
    if (![self.configuration.sslHosts containsObject:requestURL.host]) {
        pinningMode = LDSSLPinningModeNone;
    }
    
    AFSecurityPolicy *securityPolicy        = [AFSecurityPolicy policyWithPinningMode:pinningMode];
    securityPolicy.allowInvalidCertificates = api.apiSecurityPolicy.allowInvalidCertificates;
    securityPolicy.validatesDomainName      = api.apiSecurityPolicy.validatesDomainName;
    return securityPolicy;
}

/**
 * 完善API接口的公共query部分
 */
- (NSString*)interfaceHeaderPath:(NSString*)originPath {
    NSString *newPath = originPath;
    if (self.configuration.interfaceHeader) {
        if ([originPath rangeOfString:@"?"].length > 0) {
            newPath = [originPath stringByAppendingFormat:@"&%@", self.configuration.interfaceHeader];
        } else {
            newPath = [originPath stringByAppendingFormat:@"?%@", self.configuration.interfaceHeader];
        }
    }
    return newPath;
}


#pragma mark - Send Request

- (void)sendAPIRequest:(nonnull LDBaseAPI *)api {
    NSParameterAssert(api);
    NSAssert(self.configuration, @"Configuration Can not be nil");
    
    dispatch_async(ld_api_task_creation_queue(), ^{
        AFHTTPSessionManager *sessionManager = [self sessionManagerWithAPI:api];
        if (!sessionManager) {
            return;
        }
        [self sendSingleAPIRequest:api withsessionManager:sessionManager];
    });
}

- (void)cancelAPIRequest:(nonnull LDBaseAPI *)api {
    dispatch_async(ld_api_task_creation_queue(), ^{
        NSString *hashKey = [self apiCacheKey:api];
        NSURLSessionDataTask *dataTask = [self.sessionTasksCache objectForKey:hashKey];
        [self.sessionTasksCache removeObjectForKey:hashKey];
        if (dataTask) {
            [dataTask cancel];
        }
    });
}


#pragma mark - AFsessionManager

- (NSMutableDictionary *)sessionManagerCache {
    if (!_sessionManagerCache) {
        _sessionManagerCache = [[NSMutableDictionary alloc] init];
    }
    return _sessionManagerCache;
}

- (NSMutableDictionary *)sessionTasksCache {
    if (!_sessionTasksCache) {
        _sessionTasksCache = [[NSMutableDictionary alloc] init];
    }
    return _sessionTasksCache;
}

/**
 * 根据API接口获取设置对应的sessionManager
 */
- (AFHTTPSessionManager *)sessionManagerWithAPI:(LDBaseAPI *)api {
    NSParameterAssert(api);
    if (![api apiRequestUrl]) {
        return nil;
    }
    
    AFHTTPRequestSerializer *requestSerializer = [self requestSerializerForAPI:api];
    if (!requestSerializer) {
        return nil;
    }
    AFHTTPResponseSerializer *responseSerializer = [self responseSerializerForAPI:api];
    
    NSURL *requestURL = [NSURL URLWithString:[api apiRequestUrl]];
    NSString *baseUrlStr = [NSURL URLWithString:@"/" relativeToURL:requestURL].absoluteString;
    NSString *sessionKey = [NSString stringWithFormat:@"%@_%lu_%lu", baseUrlStr, (unsigned long)[api apiResponseSerializerType], (unsigned long)[api isEncyptPostRequestBody]];
    AFHTTPSessionManager *sessionManager;
    [self.lock lock];
    sessionManager = [self.sessionManagerCache objectForKey:sessionKey];
    if (!sessionManager) {
        sessionManager = [self newsessionManagerWithBaseUrlStr:baseUrlStr];
        [self.sessionManagerCache setObject:sessionManager forKey:sessionKey];
    }
    
    sessionManager.requestSerializer     = requestSerializer;
    sessionManager.responseSerializer    = responseSerializer;
    sessionManager.securityPolicy        = [self securityPolicyWithAPI:api];
    [self.lock unlock];
    
    return sessionManager;
}

- (AFHTTPSessionManager *)newsessionManagerWithBaseUrlStr:(NSString *)baseUrlStr {
    NSURLSessionConfiguration *sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
    if (self.configuration) {
        sessionConfig.HTTPMaximumConnectionsPerHost = self.configuration.maxHttpConnectionPerHost;
    } else {
        sessionConfig.HTTPMaximumConnectionsPerHost = MAX_HTTP_CONNECTION_PER_HOST;
    }
    return [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:baseUrlStr]
                                    sessionConfiguration:sessionConfig];
}

- (void) sendSingleAPIRequest:(LDBaseAPI *)api
            withsessionManager:(AFHTTPSessionManager *)sessionManager {
    [self sendSingleAPIRequest:api withsessionManager:sessionManager andCompletionGroup:nil];
}

- (void) sendSingleAPIRequest:(LDBaseAPI *)api
            withsessionManager:(AFHTTPSessionManager *)sessionManager
           andCompletionGroup:(dispatch_group_t)completionGroup {
    NSParameterAssert(api);
    NSParameterAssert(sessionManager);
    
    //检查是否已有task
    __weak typeof(self) weakSelf = self;
    NSString *requestUrlStr = [self interfaceHeaderPath:[api apiRequestUrl]];
    id requestParams        = [api apiRequestParameters];
    NSString *hashKey       = [self apiCacheKey:api];
    
    if (![api isParamURLEncoding]) {
        [sessionManager.requestSerializer setQueryStringSerializationWithBlock:^NSString *(NSURLRequest *request, id parameters, NSError *__autoreleasing *error) {
            NSMutableArray *parameterPairs = [NSMutableArray new];
            for (NSString *key in [(NSDictionary *)parameters allKeys]) {
                [parameterPairs addObject:[NSString stringWithFormat:@"%@=%@", key, parameters[key]]];
            }
            NSString *paramsString = [parameterPairs componentsJoinedByString:@"&"];
            return paramsString;
        }];
    }
    
    void (^successBlock)(NSURLSessionDataTask *task, id responseObject)
    = ^(NSURLSessionDataTask * task, id responseObject) {
        __strong typeof (weakSelf) strongSelf = weakSelf;
        [strongSelf callAPICompletion:api response:(NSHTTPURLResponse *)task.response obj:responseObject error:nil];
        [strongSelf.sessionTasksCache removeObjectForKey:hashKey];
        if (completionGroup) {
            dispatch_group_leave(completionGroup);
        }
    };
    
    void (^failureBlock)(NSURLSessionDataTask * task, NSError * error)
    = ^(NSURLSessionDataTask * task, NSError * error) {
        __strong typeof (weakSelf) strongSelf = weakSelf;
        [strongSelf callAPICompletion:api response:(NSHTTPURLResponse *)task.response obj:nil error:error];
        [strongSelf.sessionTasksCache removeObjectForKey:hashKey];
        if (completionGroup) {
            dispatch_group_leave(completionGroup);
        }
    };
    
    void (^apiProgressBlock)(NSProgress *progress)
    = api.apiProgressBlock ?
    ^(NSProgress *progress) {
        if (progress.totalUnitCount <= 0) {
            return;
        }
        api.apiProgressBlock(progress);
    } : nil;
    
    
    if ([[NSThread currentThread] isMainThread]) {
        [api apiRequestWillBeSent];
    } else {
        dispatch_sync(dispatch_get_main_queue(), ^{
            [api apiRequestWillBeSent];
        });
    }
    
    
    NSURLSessionDataTask *dataTask;
    switch ([api apiRequestMethodType]) {
        case LDRequestMethodTypeGET:
        {
            dataTask = [sessionManager GET:requestUrlStr parameters:requestParams progress:apiProgressBlock success:successBlock failure:failureBlock];
        }
            break;
        case LDRequestMethodTypePOST:
        {
            if (![api apiRequestConstructingBodyBlock]) {
                dataTask = [sessionManager POST:requestUrlStr parameters:requestParams progress:apiProgressBlock success:successBlock failure:failureBlock];
            } else {
                void (^block)(id <AFMultipartFormData> formData)
                = ^(id <AFMultipartFormData> formData) {
                    api.apiRequestConstructingBodyBlock((id<LDMultipartFormData>)formData);
                };
                dataTask = [sessionManager POST:requestUrlStr parameters:requestParams constructingBodyWithBlock:block progress:apiProgressBlock success:successBlock failure:failureBlock];
            }
        }
            break;
        case LDRequestMethodTypeDELETE:
        {
            dataTask = [sessionManager DELETE:requestUrlStr parameters:requestParams success:successBlock failure:failureBlock];
        }
            break;
        case LDRequestMethodTypePATCH:
        {
            dataTask = [sessionManager PATCH:requestUrlStr parameters:requestParams success:successBlock failure:failureBlock];
        }
            break;
        case LDRequestMethodTypePUT:
        {
            dataTask = [sessionManager PUT:requestUrlStr parameters:requestParams success:successBlock failure:failureBlock];
        }
            break;
        case LDRequestMethodTypeHEAD:
        {
            dataTask = [sessionManager HEAD:requestUrlStr parameters:requestParams success:^(NSURLSessionDataTask * _Nonnull task) {
                if (successBlock) {
                    successBlock(task, nil);
                }
            } failure:failureBlock];
        }
            break;
        default:{
            dataTask = [sessionManager GET:requestUrlStr parameters:requestParams progress:apiProgressBlock success:successBlock failure:failureBlock];
        }
            break;
    }
    
    
    if (dataTask) {
        [self.sessionTasksCache setObject:dataTask forKey:hashKey];
    }
    
    if ([[NSThread currentThread] isMainThread]) {
        [api apiRequestDidSent];
    } else {
        dispatch_sync(dispatch_get_main_queue(), ^{
            [api apiRequestDidSent];
        });
    }
}

- (NSString *)apiCacheKey:(LDBaseAPI *)api
{
    return [NSString stringWithFormat:@"%p", api];
}

#pragma mark - Response Handle

- (void)callAPICompletion:(LDBaseAPI *)api response:(NSHTTPURLResponse *)response obj:(id)obj error:(NSError *)error {
    obj = [api apiResponseObjReformer:obj andError:error];
    if ([api apiCompletionHandler]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            api.response = response;
            api.apiCompletionHandler(api, obj, error);
        });
    }
}

@end


@implementation LDAPIManager (Extend)

- (void)sendBatchAPIRequests:(nonnull LDBatchAPI*) batchAPI{
    NSParameterAssert(batchAPI);
    
    NSAssert([[batchAPI.apiSet valueForKeyPath:@"hash"] count] == [batchAPI.apiSet count],
             @"Should not have same API");
    
    dispatch_group_t batch_api_group = dispatch_group_create();
    __weak typeof(self) weakSelf = self;
    [batchAPI.apiSet enumerateObjectsUsingBlock:^(id api, BOOL * stop) {
        dispatch_group_enter(batch_api_group);
        
        __strong typeof (weakSelf) strongSelf = weakSelf;
        AFHTTPSessionManager *sessionManager = [strongSelf sessionManagerWithAPI:api];
        if (!sessionManager) {
            *stop = YES;
            dispatch_group_leave(batch_api_group);
        }
        sessionManager.completionGroup = batch_api_group;
        [strongSelf sendSingleAPIRequest:api withsessionManager:sessionManager andCompletionGroup:batch_api_group];
    }];
    
    dispatch_group_notify(batch_api_group, dispatch_get_main_queue(), ^{
        if (batchAPI.batchAPIFinishedBlock) {
            batchAPI.batchAPIFinishedBlock(batchAPI);
        }
    });
}

@end
