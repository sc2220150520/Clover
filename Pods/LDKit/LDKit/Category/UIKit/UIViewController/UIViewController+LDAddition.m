//
//  UIViewController+LDAddition.m
//  LDKitDemo
//
//  Created by lixingdong on 16/8/8.
//  Copyright © 2016年 david. All rights reserved.
//

#import "UIViewController+LDAddition.h"

@implementation UIViewController (LDAddition)

+ (BOOL)ld_isMainTab
{
    //rootViewController需要是TabBarController
    UIViewController *rootViewController = [UIApplication sharedApplication].delegate.window.rootViewController;
    if (rootViewController && [rootViewController isKindOfClass:[UITabBarController class]]) {
        //当前显示哪个tab页
        UINavigationController *rootNavController = (UINavigationController *) [(UITabBarController*)rootViewController selectedViewController];
        if (rootNavController) {
            UIViewController *topViewController = rootNavController.topViewController;
            if (rootNavController.viewControllers.count == 1 && !topViewController.presentedViewController) {
                return YES;
            }
        }
    }
    return NO;
}

+ (UIViewController *)ld_topmostViewController
{
    UIViewController *rootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    if (!rootVC) {
        rootVC = [UIApplication sharedApplication].delegate.window.rootViewController;
    }
    return [self ld_topViewControllerRecursivityWithRootViewController:rootVC];
}

+ (UIViewController *)ld_topViewControllerRecursivityWithRootViewController:(UIViewController *)rootViewController
{
    if ([rootViewController isKindOfClass:[UITabBarController class]]) {
        UITabBarController *tabBarController = (UITabBarController *)rootViewController;
        return [self ld_topViewControllerRecursivityWithRootViewController:tabBarController.selectedViewController];
    } else if ([rootViewController isKindOfClass:[UINavigationController class]]) {
        UINavigationController *navigationController = (UINavigationController *)rootViewController;
        return [self ld_topViewControllerRecursivityWithRootViewController:navigationController.topViewController];
    } else if (rootViewController.presentedViewController) {
        UIViewController *presentedViewController = rootViewController.presentedViewController;
        return [self ld_topViewControllerRecursivityWithRootViewController:presentedViewController];
    } else {
        return rootViewController;// 暂未考虑childViewController
    }
}

+ (UIViewController *)ld_parentMostViewControllerForPresentingViewController:(UIViewController *)presentingVC {
    UIViewController *parentMostVC = presentingVC;
    UIViewController *nextViewController = presentingVC;
    while (nextViewController.parentViewController != nil) {
        nextViewController = nextViewController.parentViewController;
        if (nextViewController) {
            parentMostVC = nextViewController;
        }
    }
    return parentMostVC;
}

- (BOOL)ld_isModalStyle
{
    if (self.navigationController && self.navigationController.viewControllers.count == 1 && self.presentingViewController) {
        return YES;
    }
    return NO;
}


- (void)ld_dismissModalViewController
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
