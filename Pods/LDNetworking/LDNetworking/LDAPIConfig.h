//
//  LDAPIConfig.h
//  LDCPNetworking
//
//  Created by philon on 16/7/20.
//  Copyright © 2016年 xuguoxing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LDAPIDefines.h"


NS_ASSUME_NONNULL_BEGIN

@interface LDAPIConfig : NSObject<NSCopying>

/**
 * UserAgent
 */
@property (nonatomic, copy, nullable) NSString *userAgent;

/**
 * 通用的query参数
 * 类似于product=%@&mobileType=%@&ver=%@&channel=%@&apiVer=%@&apiLevel=%@&deviceId=%@
 */
@property (nonatomic, copy, nullable) NSString *interfaceHeader;

/**
 * 加密post请求的加密Block
 * @default: nil 表示不对任何post请求进行加密
 * @param postBody: 需要加密的post请求的body数据
 * @param timeStamp: 加密时间戳，可以为nil
 */
@property (nonatomic, copy, nullable) NSData* _Nullable (^apiEncyptPostRequestBlock)(NSData * _Nullable postBody, NSString * _Nullable timeStamp);

/**
 * 每个Host的最大连接数
 * @default 默认为2
 */
@property (nonatomic, assign) NSUInteger maxHttpConnectionPerHost;


/**
 * 统一指定需要使用证书验证的host
 * @default @{} 默认都不使用证书验证（scheme为https，并不一定要进行证书验证，可以设置为serverTrust，就不进行证书验证）
 */
@property (nonatomic, copy, nonnull) NSSet<NSString *> *sslHosts;


@end

NS_ASSUME_NONNULL_END
