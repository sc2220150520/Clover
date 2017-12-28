//
//  LDHTTPRequestSerializer.h
//  LDCPNetworking
//
//  Created by 庞辉 on 3/9/16.
//  Copyright © 2016 xuguoxing. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>

NS_ASSUME_NONNULL_BEGIN

/**
 * @class LDHTTPRequestSerializer 
 * AFNetworking2.0以上版本把header的初始化，以及paramers的处理统一放到了requestSerializer中，由于彩票项目中对部分Post参数需要加密，该类主要根据调用者队httpBody的数据进行加密处理；
 */
@interface LDAFHTTPRequestSerializer : AFHTTPRequestSerializer

//加密block
@property (nonatomic, assign, nullable) NSData* _Nullable (^apiEncyptPostRequestBlock)(NSData *postBody, NSString * _Nullable timeStamp);

//post请求httpBody的加密时间戳
@property (nonatomic, assign, nullable) NSString *timeStamp;

@end

NS_ASSUME_NONNULL_END
