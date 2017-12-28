//
//  LDSecurityPolicy.m
//  LDCPNetworking
//
//  Created by philon on 16/7/19.
//  Copyright © 2016年 xuguoxing. All rights reserved.
//

#import "LDSecurityPolicy.h"

@interface LDSecurityPolicy ()

@property (readwrite, nonatomic, assign) LDSSLPinningMode SSLPinningMode;

@end


@implementation LDSecurityPolicy

+ (instancetype)policyWithPinningMode:(LDSSLPinningMode)pinningMode {
    LDSecurityPolicy *securityPolicy = [[LDSecurityPolicy alloc] init];
    if (securityPolicy) {
        securityPolicy.SSLPinningMode           = pinningMode;
        securityPolicy.allowInvalidCertificates = NO;
        securityPolicy.validatesDomainName      = YES;
    }
    return securityPolicy;
}

@end
