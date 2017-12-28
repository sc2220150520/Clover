//
//  LDBaseAPI.m
//  LDCPNetworking
//
//  Created by philon on 16/7/19.
//  Copyright © 2016年 xuguoxing. All rights reserved.
//

#import "LDBaseAPI.h"
#import "LDAPIManager.h"

@implementation LDBaseAPI

- (instancetype)init {
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"requestUrl:%@", [self apiRequestUrl]];
}

- (NSUInteger)hash {
    
    NSMutableString *hashStr = [NSMutableString stringWithFormat:@"%@_%lu_%@",
                                [self apiRequestUrl], (unsigned long)[self apiRequestMethodType], [self apiRequestParameters] == nil ? @"":[self apiRequestParameters]];
    return [hashStr hash];
}

-(BOOL)isEqualToAPI:(LDBaseAPI *)api {
    if ([self hash] == [api hash] &&
        [[self apiRequestUrl] isEqualToString:[api apiRequestUrl]] &&
        [self apiRequestMethodType] == [api apiRequestMethodType] &&
        [self isEncyptPostRequestBody] == [api isEncyptPostRequestBody] &&
        [[self apiRequestParameters] isEqual:[api apiRequestParameters]]) {
        return YES;
    }
    return  NO;
}

- (BOOL)isEqual:(id)object {
    if (self == object) return YES;
    if (![object isKindOfClass:[LDBaseAPI class]]) return NO;
    return [self isEqualToAPI:(LDBaseAPI *) object];
}


#pragma mark - config methods

- (NSString *)apiRequestUrl {
    return nil;
}

- (LDRequestMethodType)apiRequestMethodType {
    return LDRequestMethodTypeGET;
}

- (nullable id)apiRequestParameters {
    return nil;
}

- (BOOL)isParamURLEncoding {
    return YES;
}

- (BOOL)isEncyptPostRequestBody{
    return NO;
}

- (nullable NSString *)apiEncyptRequestTimeStamp{
    return nil;
}

- (LDResponseSerializerType)apiResponseSerializerType {
    return LDResponseSerializerTypeHTTP;
}

- (NSURLRequestCachePolicy)apiRequestCachePolicy {
    return NSURLRequestUseProtocolCachePolicy;
}

- (NSTimeInterval)apiRequestTimeoutInterval {
    return LD_API_REQUEST_TIME_OUT;
}

- (nullable NSDictionary *)apiRequestHTTPHeaderField {
    return @{};
}

- (nullable NSSet *)apiResponseAcceptableContentTypes {
    return nil;
}

/**
 *  为了方便，在Debug模式下使用None来保证用Charles之类可以抓到HTTPS报文
 *  Production下，则用Pinning Certification PublicKey 来防止中间人攻击
 */
- (nonnull LDSecurityPolicy *)apiSecurityPolicy {
    LDSecurityPolicy *securityPolicy;
#ifdef DEBUG
    securityPolicy = [LDSecurityPolicy policyWithPinningMode:LDSSLPinningModeNone];
#else
    securityPolicy = [LDSecurityPolicy policyWithPinningMode:LDSSLPinningModePublicKey];
#endif
    return securityPolicy;
}

- (nullable id)apiResponseObjReformer:(id)responseObject andError:(NSError * _Nullable)error {
    return responseObject;
}


#pragma mark - process methods

- (void)apiRequestWillBeSent {
    return;
}

- (void)apiRequestDidSent {
    return;
}

- (void)start {
    [[LDAPIManager sharedAPIManager] sendAPIRequest:((LDBaseAPI *)self)];
}

- (void)cancel {
    [[LDAPIManager sharedAPIManager] cancelAPIRequest:((LDBaseAPI *)self)];
}

@end
