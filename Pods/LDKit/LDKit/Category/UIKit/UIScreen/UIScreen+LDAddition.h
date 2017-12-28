//
//  UIScreen+LDAddition.h
//  LDKit
//
//  Created by Anchor on 17/3/19.
//  Copyright © 2017年 netease. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIScreen (LDAddition)

/**
   获取当前屏幕的截屏 包含[UIApplication sharedApplication].windows的内容
   不包含状态栏及iOS 8之后的UIAlertView/UIActionSheet
 */
+ (UIImage *)currentScreenshot;

@end
