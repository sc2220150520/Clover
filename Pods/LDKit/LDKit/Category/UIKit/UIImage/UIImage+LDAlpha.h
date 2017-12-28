//
//  UIImage+LDAlpha.h
//  LDKitDemo
//
//  Created by lixingdong on 16/8/5.
//  written by Trevor Harmon on 9/20/09.
//  written by Matt Gemmell on 04/07/2010.
//  written by david on 14-7-28.
//  Copyright © 2016年 david. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (LDAlpha)

- (BOOL)ld_hasAlpha;

- (UIImage *)ld_imageWithAlpha;

- (UIImage *)ld_transparentBorderImage:(NSUInteger)borderSize;

- (UIImage *)ld_imageWithShadow:(UIColor*)_shadowColor shadowSize:(CGSize)_shadowSize blur:(CGFloat)_blur;

- (UIImage *)ld_maskWithColor:(UIColor *)color;

- (UIImage *)ld_maskWithColor:(UIColor *)color shadowColor:(UIColor *)shadowColor shadowOffset:(CGSize)shadowOffset shadowBlur:(CGFloat)shadowBlur;

- (UIImage *)ld_imageTintedWithColor:(UIColor *)color;

- (UIImage *)ld_imageTintedWithColor:(UIColor *)color fraction:(CGFloat)fraction;

+ (UIImage *)ld_createImageWithColor:(UIColor *)color;

/**
 获得指定颜色 大小 边角度 边框颜色 边框宽度 的图片
 
 @param color 图片颜色
 @param targetSize 图片大小
 @param cornerRadius 图片边框的角度
 @param borderColor 图片边框的颜色
 @param borderWidth 边框宽度

 @return 指定图片
 */
+ (UIImage *)ld_imageWithBackgroundColor:(UIColor *)color toSize:(CGSize)targetSize cornerRadius:(CGFloat)cornerRadius  borderColor:(UIColor *)borderColor borderWidth:(CGFloat)borderWidth ;

/**
 对一个UIImage，修改她的alpha获得新的UIImage
 
 @param alpha 设置的alpha
 
 @return 生成的图片
 */
- (UIImage *)ld_imageByApplyingAlpha:(CGFloat)alpha;

@end
