//
//  UIFont+LDDefault.h
//  LDKit
//
//  Created by Anchor on 2017/6/8.
//  Take heart, young one. The Earth mother is near.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIFont (LDDefault)

/**
 设置项目默认字体与备用字体
 @param fontName        项目默认字体
 @param reserveFontName 项目备用字体 可为空
 */
+ (void)ld_setDefaultFont:(NSString *)fontName reserveFont:(nullable NSString *)reserveFontName;

/**
 返回项目默认字体 若当前iOS版本不支持默认字体 则尝试获取备用字体 再失败则返回系统默认字体
 @param  size 字号
 @return 默认字体UIFont对象
 */
+ (UIFont *)ld_defaultFontOfSize:(CGFloat)size;

+ (NSString *)ld_defaultFontName;

+ (nullable NSString *)ld_reserveFontName;

@end

NS_ASSUME_NONNULL_END
