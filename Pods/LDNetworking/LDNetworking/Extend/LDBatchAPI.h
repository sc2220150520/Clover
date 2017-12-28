//
//  LDBatchAPI.h
//  LDNetworking
//
//  Created by philon on 16/7/22.
//  Copyright © 2016年 xuguoxing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LDBaseAPI.h"

NS_ASSUME_NONNULL_BEGIN

/**
 * 组装多个API请求，并发发出
 */
@interface LDBatchAPI : NSObject

/**
 * Batch执行的API集合
 */
@property (nonatomic, strong, readonly, nullable) NSMutableSet *apiSet;


/**
 * Batch API执行完成的回调
 */
@property (nonatomic, copy, nullable) void(^batchAPIFinishedBlock)(LDBatchAPI * _Nonnull batchAPI);

/**
 * 将API加入到BatchSet集合中
 * @param api
 */
- (void)addAPI:(nonnull LDBaseAPI *)api;

/**
 * 将带有API集合的Sets赋值
 * @param apis
 */
- (void)addBatchAPIs:(nonnull NSSet *)apis;

/**
 * 开启API请求
 */
- (void)start;

@end

NS_ASSUME_NONNULL_END
