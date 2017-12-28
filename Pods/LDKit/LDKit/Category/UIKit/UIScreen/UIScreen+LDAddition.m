//
//  UIScreen+LDAddition.m
//  LDKit
//
//  Created by Anchor on 17/3/19.
//  Copyright © 2017年 netease. All rights reserved.
//

#import "UIScreen+LDAddition.h"

@implementation UIScreen (LDAddition)

+ (UIImage *)currentScreenshot
{
    CGSize imageSize = [UIScreen mainScreen].bounds.size;
    //检测横竖屏
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    if (UIInterfaceOrientationIsPortrait(orientation)) {
        imageSize = [UIScreen mainScreen].bounds.size; //竖屏
    } else {
        imageSize = CGSizeMake([UIScreen mainScreen].bounds.size.height,
                               [UIScreen mainScreen].bounds.size.width); //横屏
    }

    UIGraphicsBeginImageContextWithOptions(imageSize, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    /**
     iOS 8 之后神一样的UIAlertView不在windows里
     */
    for (UIWindow *window in [[UIApplication sharedApplication] windows]) {
        CGContextSaveGState(context);
        CGContextTranslateCTM(context, window.center.x, window.center.y);
        CGContextConcatCTM(context, window.transform);
        CGContextTranslateCTM(context, -window.bounds.size.width * window.layer.anchorPoint.x,
                              -window.bounds.size.height * window.layer.anchorPoint.y);
        
        //根据偏转修改坐标系，来显示图片
        if (orientation == UIInterfaceOrientationLandscapeLeft) {
            CGContextRotateCTM(context, M_PI_2);
            CGContextTranslateCTM(context, 0, -imageSize.width);
        } else if (orientation == UIInterfaceOrientationLandscapeRight) {
            CGContextRotateCTM(context, -M_PI_2);
            CGContextTranslateCTM(context, -imageSize.height, 0);
        } else if (orientation == UIInterfaceOrientationPortraitUpsideDown) {
            CGContextRotateCTM(context, M_PI);
            CGContextTranslateCTM(context, -imageSize.width, -imageSize.height);
        }
        
        //if ([window respondsToSelector:@selector(drawViewHierarchyInRect:afterScreenUpdates:)]) {
        [window drawViewHierarchyInRect:window.bounds afterScreenUpdates:YES];
        //} else {
        //    [window.layer renderInContext:context];
        //}
        CGContextRestoreGState(context);
    }
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

@end
