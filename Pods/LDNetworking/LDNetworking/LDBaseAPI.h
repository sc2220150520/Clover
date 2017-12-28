//
//  LDBaseAPI.h
//  LDCPNetworking
//
//  Created by philon on 16/7/19.
//  Copyright © 2016年 xuguoxing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LDAPIDefines.h"
#import "LDMultipartFormData.h"
#import "LDSecurityPolicy.h"

NS_ASSUME_NONNULL_BEGIN

@interface LDBaseAPI : NSObject

/**
 * 文件上传组装Block
 */
@property (nonatomic, copy, nullable) void (^apiRequestConstructingBodyBlock)(id<LDMultipartFormData> _Nonnull formData);

/**
 * 请求进度Block
 */
@property (nonatomic, copy, nullable) void (^apiProgressBlock)(NSProgress * _Nullable progress);

/**
 * api请求的状态结果
 */
@property (nonatomic, readwrite, nullable) NSHTTPURLResponse *response;

/**
 * 请求完成的回调Block
 * @param response 请求状态信息
 * @param responseObject 返回的序列化数据或者Model化的数据
 * @param error 请求失败的错误信息
 */
@property (nonatomic, copy, nullable) void (^apiCompletionHandler)(LDBaseAPI * _Nonnull api, _Nullable id responseObject,  NSError * _Nullable error);

/**
 * 请求接口地址，绝对全地址到path，
 *  @example 如"http://host/path"
 */
- (nullable NSString *)apiRequestUrl;

/**
 * 请求的类型:GET, POST
 * @default LDRequestMethodTypeGET
 */
- (LDRequestMethodType)apiRequestMethodType;

/**
 * 请求传入的参数列表
 * @return 一般来说是NSDictionary
 */
- (nullable id)apiRequestParameters;

/**
 * 是否对请求参数进行URLEncoding
 * @default YES
 */
- (BOOL)isParamURLEncoding;

/**
 * 是否对post请求进行加密处理
 * @default NO 如果设置为YES，通过config设置的apiEncyptPostRequestBlock进行加密
 */
- (BOOL)isEncyptPostRequestBody;

/**
 * post请求的加密时间戳
 * @default nil, 系统将生成一个时间戳
 */
- (nullable NSString *)apiEncyptRequestTimeStamp;

/**
 * 请求返回数据序列化方式: JSON, HTTP, XML
 * @default 默认为HTTP 不进行任何序列化
 */
- (LDResponseSerializerType)apiResponseSerializerType;

/**
 * 请求的Cache策略
 * @default NSURLRequestUseProtocolCachePolicy NSURLConneciton的默认策略
 */
- (NSURLRequestCachePolicy)apiRequestCachePolicy;

/**
 * 请求超时的时间
 * @default 30s
 */
- (NSTimeInterval)apiRequestTimeoutInterval;

/**
 * 请求特定的requestHeader选项
 * @default @{} 默认为空
 */
- (nullable NSDictionary *)apiRequestHTTPHeaderField;

/**
 * 请求返回可接受的内容类型
 * @default nil 默认不设置，将根据序列化类型默认设置
 */
- (nullable NSSet *)apiResponseAcceptableContentTypes;

/**
 * 请求的Security策略
 * @default LDSSLPinningModePublicKey
 */
- (nonnull LDSecurityPolicy *)apiSecurityPolicy;

/**
 * 请求返回数据的Reform处理
 * @default 默认直接返回responseObject
 */
- (nullable id)apiResponseObjReformer:(id)responseObject andError:(NSError * _Nullable)error;


#pragma mark - Process Method

/**
 *  API 即将被Sent
 */
- (void)apiRequestWillBeSent;

/**
 *  API 已经被Sent
 */
- (void)apiRequestDidSent;

/**
 *  开启API 请求
 */
- (void)start;

/**
 *  取消API 请求
 */
- (void)cancel;

@end

NS_ASSUME_NONNULL_END
