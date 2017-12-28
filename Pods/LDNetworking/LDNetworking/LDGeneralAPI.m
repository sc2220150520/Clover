//
//  LDGeneralAPI.m
//  LDCPNetworking
//
//  Created by philon on 16/7/19.
//  Copyright © 2016年 xuguoxing. All rights reserved.
//

#import "LDGeneralAPI.h"

@implementation LDGeneralAPI

#pragma mark - Init

- (instancetype)init {
    if (self = [super init]) {
        // 继承LDBaseAPI 默认值
        self.apiRequestUrl                     = [super apiRequestUrl];
        self.apiRequestMethodType              = [super apiRequestMethodType];
        self.apiRequestParameters              = [super apiRequestParameters];
        self.isParamURLEncoding                = [super isParamURLEncoding];
        self.isEncyptPostRequestBody           = [super isEncyptPostRequestBody];
        self.apiEncyptRequestTimeStamp         = [super apiEncyptRequestTimeStamp];
        
        self.apiResponseSerializerType         = [super apiResponseSerializerType];
        self.apiRequestCachePolicy             = [super apiRequestCachePolicy];
        self.apiRequestTimeoutInterval         = [super apiRequestTimeoutInterval];
        self.apiRequestHTTPHeaderField         = [super apiRequestHTTPHeaderField];
        self.apiResponseAcceptableContentTypes = [super apiResponseAcceptableContentTypes];
        self.apiSecurityPolicy                 = [super apiSecurityPolicy];
    }
    return self;
}

- (void)apiRequestWillBeSent {
    if (self.apiRequestWillBeSentBlock) {
        self.apiRequestWillBeSentBlock();
    }
}

- (void)apiRequestDidSent {
    if (self.apiRequestDidSentBlock) {
        self.apiRequestDidSentBlock();
    }
}

- (nullable id)apiResponseObjReformer:(id)responseObject andError:(NSError * _Nullable)error {
    if (self.apiResponseObjReformerBlock) {
        return self.apiResponseObjReformerBlock(responseObject, error);
    }
    
    return responseObject;
}

@end
