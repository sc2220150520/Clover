//
//  LDAPIManager.h
//  LDCPNetworking
//
//  Created by philon on 16/7/19.
//  Copyright © 2016年 xuguoxing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LDBaseAPI.h"
#import "LDAPIConfig.h"
#import "LDBatchAPI.h"

NS_ASSUME_NONNULL_BEGIN

@interface LDAPIManager : NSObject

/**
 * APIManager的配置
 */
@property (nonatomic, strong, nonnull) LDAPIConfig *configuration;

/**
 * API请求组装、发送、处理的单例
 */
+ (nullable LDAPIManager *)sharedAPIManager;

/**
 * 发送API请求
 */
- (void)sendAPIRequest:(nonnull LDBaseAPI  *)api;

/**
 * 取消API请求: 如果该请求已经发送或者正在发送，则无法取消
 */
- (void)cancelAPIRequest:(nonnull LDBaseAPI  *)api;

@end


/**
 * 用于在base基础上的所有扩展接口
 */
@interface LDAPIManager (Extend)

/**
 * 批量发送API请求
 * @param apis 批量API请求集合
 */
- (void)sendBatchAPIRequests:(nonnull LDBatchAPI*) batchAPI;

@end

NS_ASSUME_NONNULL_END
