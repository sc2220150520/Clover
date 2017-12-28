//
//  UIViewController+LDAddition.h
//  LDKitDemo
//
//  Created by lixingdong on 16/8/8.
//  written by zhangxuming on 16/1/27.
//  written by fanxuejiao on 15/6/4.
//  written by bjzhangyuan on 14-7-29.
//  written by Jared Sinclair on 10/16/13.
//  Copyright © 2016年 david. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (LDAddition)

+ (BOOL)ld_isMainTab;

+ (UIViewController *)ld_topmostViewController;

+ (UIViewController *)ld_parentMostViewControllerForPresentingViewController:(UIViewController *)presentingVC;

// 若当前ViewController，是包在UINavigationController中，然后被present显示的,返回YES;否则返回NO。
// 一般用于判断导航栏左侧按钮是否显示“返回”;在通过ntescaipiao://跳转到不同页面时会使用。
- (BOOL)ld_isModalStyle;

//对dismissViewControllerAnimated:completion,简单封装，用于上述情况"返回"button按钮的action。避免传递参数。
- (void)ld_dismissModalViewController;


@end
