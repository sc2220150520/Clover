//
//  UIViewController+MKTopMostViewController.m
//  Pods
//
//  Created by bjshiweiran on 16/5/17.
//
//

#import "UIViewController+MKTopMostViewController.h"

@implementation UIViewController (TopMostViewController)

+ (UIViewController *)mk_topViewController {
    return [self mk_topViewControllerWithRootViewController:[UIApplication sharedApplication].keyWindow.rootViewController];
}

+ (UIViewController *)mk_topViewControllerWithRootViewController:(UIViewController *)rootViewController {
    if ([rootViewController isKindOfClass:[UITabBarController class]]) {
        UITabBarController *tabBarController = (UITabBarController *)rootViewController;
        return [self mk_topViewControllerWithRootViewController:tabBarController.selectedViewController];
    } else if ([rootViewController isKindOfClass:[UINavigationController class]]) {
        UINavigationController *navigationController = (UINavigationController *)rootViewController;
        return [self mk_topViewControllerWithRootViewController:navigationController.topViewController];
    } else if (rootViewController.presentedViewController) {
        UIViewController *presentedViewController = rootViewController.presentedViewController;
        return [self mk_topViewControllerWithRootViewController:presentedViewController];
    } else {
        return rootViewController;
    }
}

@end
