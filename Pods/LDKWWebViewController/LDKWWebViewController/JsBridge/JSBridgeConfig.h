//
//  JSBridgeConfig.h
//  Pods
//
//  Created by david on 16/4/8.
//
//

#import <Foundation/Foundation.h>

@interface JSBridgeConfig : NSObject

+ (instancetype)sharedInstance;
/**
 *  注册NativeService实现类及JSApi接口
 *
 *  @param domain  JS接口域。如果域名相同会去重添加。
 *  @param clsName Native实现类。如果类名相同会去重添加sels。
 *  @param sels    注册接口数组。其中每一个元素代表一个方法，格式：@[@(level),@"showname",@"realname"],如果showname与realname相同，可不传第三个参数。
 *  @param isLocal 是否为Native类实现（目前均为YES）。
 */
- (void)registerJSApi:(NSString *)domain service:(NSString *)clsName selectors:(NSArray<NSArray *> *)sels local:(BOOL)isLocal;

/**
 *  全部NativeService配置
 */
- (NSArray<NSDictionary *> *)serviceConfig;

/**
 * 全部JSApi
 */
- (NSString *)jsApi;

/**
 *  注销全部配置
 */
- (void)resignAllConfig;

@end
