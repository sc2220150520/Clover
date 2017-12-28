//
//  UIImage+LDResize.h
//  LDKitDemo
//
//  Created by lixingdong on 16/8/5.
//  written by Trevor Harmon on 8/5/09.
//  written by wangbo on 11-10-8.
//  Copyright © 2016年 david. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (LDResize)

- (UIImage *)ld_croppedImage:(CGRect)bounds;

- (UIImage *)ld_thumbnailImage:(NSInteger)thumbnailSize transparentBorder:(NSUInteger)borderSize cornerRadius:(NSUInteger)cornerRadius interpolationQuality:(CGInterpolationQuality)quality;

- (UIImage *)ld_resizedImage:(CGSize)newSize interpolationQuality:(CGInterpolationQuality)quality;

- (UIImage *)ld_resizedImageWithContentMode:(UIViewContentMode)contentMode bounds:(CGSize)bounds interpolationQuality:(CGInterpolationQuality)quality;

- (UIImage *)ld_rotate:(UIImageOrientation)orient;

- (UIImage *)ld_resizeImageWithNewSize:(CGSize)newSize;

- (UIImage *)ld_resizedImage:(CGSize)newSize;

- (UIImage *)ld_roundedCornerImage:(NSInteger)cornerSize borderSize:(NSInteger)borderSize;

- (UIImage *)ld_imageWithRadius:(float) radius width:(float)width height:(float)height;

- (UIImage *)ld_stretchAndRetinaImage;

- (UIImage *)ld_stretch;

@end
