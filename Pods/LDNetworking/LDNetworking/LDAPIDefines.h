//
//  LDAPIDefines.h
//  LDCPNetworking
//
//  Created by philon on 16/7/19.
//  Copyright © 2016年 xuguoxing. All rights reserved.
//

#ifndef LDAPIDefines_h
#define LDAPIDefines_h

/**
 * 网络请求类型
 */
typedef NS_ENUM(NSUInteger, LDRequestMethodType) {
    LDRequestMethodTypeGET     = 0,
    LDRequestMethodTypePOST    = 1,
    LDRequestMethodTypeHEAD    = 2,
    LDRequestMethodTypePUT     = 3,
    LDRequestMethodTypePATCH   = 4,
    LDRequestMethodTypeDELETE  = 5
};

/**
 *  请求返回的序列化格式
 */
typedef NS_ENUM(NSUInteger, LDResponseSerializerType) {
    LDResponseSerializerTypeHTTP    = 0,
    LDResponseSerializerTypeJSON    = 1,
    LDResponseSerializerTypeXML     = 2
};

/**
 * SSL Pinning
 * 校验Pinning证书中的PublicKey.
 * 知识点可以参考: https://en.wikipedia.org/wiki/HTTP_Public_Key_Pinning
 */
typedef NS_ENUM(NSUInteger, LDSSLPinningMode) {
    LDSSLPinningModeNone,       //不校验Pinning证书
    LDSSLPinningModePublicKey,  //PublicKey校验证书
    LDSSLPinningModeCertificate //校验整个Pinning证书
};

#define LD_API_REQUEST_TIME_OUT     30  //默认的请求超时时间
#define MAX_HTTP_CONNECTION_PER_HOST 5  //默认的sessionManager的最大连接数

#endif /* LDAPIDefines_h */
