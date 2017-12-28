//
//  LDSecurityPolicy.h
//  LDCPNetworking
//
//  Created by philon on 16/7/19.
//  Copyright © 2016年 xuguoxing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LDAPIDefines.h"

@interface LDSecurityPolicy : NSObject

/**
 * SSL Pinning证书的校验模式
 * @default DRDSSLPinningModeNone
 */
@property (readonly, nonatomic, assign) LDSSLPinningMode SSLPinningMode;

/**
 * 是否允许使用Invalid证书
 * @default NO
 */
@property (nonatomic, assign) BOOL allowInvalidCertificates;

/**
 * 是否校验在证书CN字段中的domain name
 * @default YES
 */
@property (nonatomic, assign) BOOL validatesDomainName;

/**
 * 创建新的SecurityPolicy
 * @param pinningMode 证书校验模式
 */
+ (instancetype)policyWithPinningMode:(LDSSLPinningMode)pinningMode;

@end
