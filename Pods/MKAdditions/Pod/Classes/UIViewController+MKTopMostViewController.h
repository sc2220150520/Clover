//
//  UIViewController+MKTopMostViewController.h
//  Pods
//
//  Created by bjshiweiran on 16/5/17.
//
//

#import <UIKit/UIKit.h>

@interface UIViewController (MKTopMostViewController)

/**
 *  返回当前view controller栈最顶端的控制器对象。
 */
+ (UIViewController *)mk_topViewController;

@end
