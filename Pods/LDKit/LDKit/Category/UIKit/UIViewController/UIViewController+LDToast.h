//
//  UIViewController+LDToast.h
//  LDKit
//
//  Created by fanxuejiao on 17/3/17.
//  Copyright © 2017年 LDKit. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (LDToast)

@property (nonatomic, strong) UIActivityIndicatorView *ld_indicator;

/**
 *   在屏幕中间显示或移除 系统ActivityView - UIActivityIndicatorView
 */
- (void)ld_createActivityIndicator;

/**
 *  @param style       系统类型
 *  位置为 self.view.center 指定样式 系统ActivityView - UIActivityIndicatorView
 */
- (void)ld_createActivityIndicatorWithStyle:(UIActivityIndicatorViewStyle)style;

/**
 *  @param style       系统类型
 *  @param center      中心位置
 *   指定位置 指定样式 系统ActivityView - UIActivityIndicatorView
 */
- (void)ld_createActivityIndicatorWithStyle:(UIActivityIndicatorViewStyle)style center:(CGPoint)center;

- (void)ld_removeActivityIndicator;


/**
 *  创建临时弹出消息(Toast) 使用LDLightAlert显示 1.5s后消失
 */
- (void)ld_toastWithText:(NSString *)text;
- (void)ld_toastWithError:(NSError *)error;

@end
