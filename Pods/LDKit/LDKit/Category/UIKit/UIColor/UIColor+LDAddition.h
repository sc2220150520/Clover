//
//  UIColor+LDAddition.h
//  LDKitDemo
//
//  Created by lixingdong on 16/8/5.
//  written by yangning2014 on 15/7/1.
//  written by Jared Sinclair on 10/24/13.
//  Copyright © 2016年 david. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (LDAddition)

+ (UIColor *)ld_colorWithHexString:(NSString *)colorString;

+ (UIColor *)ld_colorWithHexString:(NSString *)colorString alpha:(CGFloat)alpha;

+ (UIColor *)ld_colorWithHex:(NSInteger)hexValue alpha:(CGFloat)alphaValue;

+ (UIColor *)ld_colorWithHex:(NSInteger)hexValue;

- (CGColorSpaceModel)ld_colorSpaceModel;

- (BOOL)ld_canProvideRGBComponents;

- (CGFloat)ld_luminance;

- (UIColor *)ld_colorByInterpolatingToColor:(UIColor *)color byFraction:(CGFloat)fraction;

- (UIColor *)ld_contrastingColor;

/*
 * 取两个颜色按比例的中间颜色的方法
 * self是颜色1，endColor是颜色2，ratio是颜色1到颜色2的线性变化的比例
 * 返回值是中间颜色
 */
- (UIColor *)ld_intermediateColorWithEndColor:(UIColor *)endColor ratio:(CGFloat)ratio;

@end
