//
//  LDGeneralAPI.h
//  LDCPNetworking
//
//  Created by philon on 16/7/19.
//  Copyright © 2016年 xuguoxing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LDBaseAPI.h"

NS_ASSUME_NONNULL_BEGIN

@interface LDGeneralAPI : LDBaseAPI

/**
 * 同BaseAPI customRequestUrl
 */
@property (nonatomic, copy,   nullable) NSString *apiRequestUrl;

/**
 * 同BaseAPI apiRequestMethodType
 */
@property (nonatomic, assign) LDRequestMethodType apiRequestMethodType;

/**
 * 同BaseAPI apiRequestParameters
 */
@property (nonatomic, copy, nullable) id apiRequestParameters;

/**
 * 同BaseAPI isParamURLEncoding
 */
@property (nonatomic, assign) BOOL isParamURLEncoding;

/**
 * 同BaseAPI isEncyptPostRequestBody
 */
@property (nonatomic, assign) BOOL isEncyptPostRequestBody;

/**
 * 同BaseAPI apiEncyptRequestTimeStamp
 */
@property (nonatomic, strong, nullable) NSString *apiEncyptRequestTimeStamp;

/**
 * 同BaseAPI apiResponseSerializerType
 */
@property (nonatomic, assign) LDResponseSerializerType apiResponseSerializerType;

/**
 * 同BaseAPI apiRequestCachePolicy
 */
@property (nonatomic, assign) NSURLRequestCachePolicy apiRequestCachePolicy;

/**
 * 同BaseAPI apiRequestTimeoutInterval
 */
@property (nonatomic, assign) NSTimeInterval apiRequestTimeoutInterval;

/**
 * 同BaseAPI apiRequestHTTPHeaderField
 */
@property (nonatomic, strong, nullable) NSDictionary *apiRequestHTTPHeaderField;

/**
 * 同BaseAPI apiResponseAcceptableContentTypes
 */
@property (nonatomic, strong, nullable) NSSet *apiResponseAcceptableContentTypes;

/**
 * 同BaseAPI apiSecurityPolicy
 */
@property (nonatomic, strong) LDSecurityPolicy *apiSecurityPolicy;

/**
 * 同BaseAPI apiRequestWillBeSent
 */
@property (nonatomic, copy, nullable) void (^apiRequestWillBeSentBlock)();

/**
 * 同BaseAPI apiRequestDidSent
 */
@property (nonatomic, copy, nullable) void (^apiRequestDidSentBlock)();

/**
 * 同BaseAPI apiResponseObjReformer
 */
@property (nonatomic, copy, nullable) id _Nullable (^apiResponseObjReformerBlock)(id responseObject, NSError * _Nullable error);

@end

NS_ASSUME_NONNULL_END
