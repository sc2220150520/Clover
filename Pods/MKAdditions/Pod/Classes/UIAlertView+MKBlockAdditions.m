//
//  UIAlertView+MKBlockAdditions.m
//  UIKitCategoryAdditions
//
//  Created by Mugunth on 21/03/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "UIAlertView+MKBlockAdditions.h"
#import "UIViewController+MKTopMostViewController.h"
#import <objc/runtime.h>
#import "MKBlockAlertController.h"

static char DISMISS_IDENTIFER;
static char CANCEL_IDENTIFER;

@interface UIAlertView ()

/**
 *  其他自定义键的点击事件回调block。
 *
 *  @attention block的输入参数buttonIndex是不包括取消键的索引号。比如AlertView里有“取消”键和“确定”键，则“确定”键的buttonIndex是0而不是1。
 */
@property (nullable, nonatomic, copy) DismissBlock dismissBlock;

/**
 *  取消键的点击事件回调block
 */
@property (nullable, nonatomic, copy) CancelBlock cancelBlock;

@end

@implementation UIAlertView (Block)

#pragma mark - Custom Accessors

- (void)setDismissBlock:(DismissBlock)dismissBlock {
    objc_setAssociatedObject(self, &DISMISS_IDENTIFER, dismissBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (DismissBlock)dismissBlock {
    return objc_getAssociatedObject(self, &DISMISS_IDENTIFER);
}

- (void)setCancelBlock:(CancelBlock)cancelBlock {
    objc_setAssociatedObject(self, &CANCEL_IDENTIFER, cancelBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (CancelBlock)cancelBlock {
    return objc_getAssociatedObject(self, &CANCEL_IDENTIFER);
}

#pragma mark - Public Methods

+ (void)alertViewWithTitle:(NSString *)title
                   message:(NSString *)message
         cancelButtonTitle:(NSString *)cancelButtonTitle
         otherButtonTitles:(NSArray<NSString *> *)otherButtons
                 onDismiss:(DismissBlock)dismissed
                  onCancel:(CancelBlock)cancelled {
    if ([[[UIDevice currentDevice] systemVersion] compare:@"8.0" options:NSNumericSearch] == NSOrderedAscending) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                        message:message
                                                       delegate:[self class]
                                              cancelButtonTitle:cancelButtonTitle
                                              otherButtonTitles:nil];

        [alert setDismissBlock:dismissed];
        [alert setCancelBlock:cancelled];

        for (NSString *buttonTitle in otherButtons) {
            [alert addButtonWithTitle:buttonTitle];
        }

        [alert show];
        
    } else {
        
        MKBlockAlertController *alertController = [MKBlockAlertController alertControllerWithTitle:title
                                                                                           message:message
                                                                                    preferredStyle:UIAlertControllerStyleAlert];
        if (cancelButtonTitle) {
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelButtonTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                if (cancelled) {
                    cancelled();
                }
            }];
            [alertController addAction:cancelAction];
        }
        
        [otherButtons enumerateObjectsUsingBlock:^(NSString * _Nonnull title, NSUInteger idx, BOOL * _Nonnull stop) {
            UIAlertAction *otherAction = [UIAlertAction actionWithTitle:title style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                if (dismissed) {
                    dismissed(idx);
                }
            }];
            [alertController addAction:otherAction];
        }];
        
        UIViewController *topViewController = [UIViewController mk_topViewController];
        if (![topViewController isKindOfClass:[UIAlertController class]]) {
            [topViewController presentViewController:alertController animated:YES completion:nil];
            
            //设置tintColor，否则UIAlertActionStyleDefault和UIAlertActionStyleCancel样式按钮文字颜色会白色
            alertController.view.tintColor = [UIColor colorWithRed:0 green:0.478431 blue:1. alpha:1];
        } else if ([topViewController isKindOfClass:[UIAlertController class]]) {
            NSLog(@"WARNING: you could NOT synchronously present multiple alert on the same view controller.");
        }
    }
}

+ (void)alertViewWithTitle:(NSString *)title
                   message:(NSString *)message {
    
    [UIAlertView alertViewWithTitle:title
                            message:message
                  cancelButtonTitle:@"取消"];
}

+ (void)alertViewWithTitle:(NSString *)title
                   message:(NSString *)message
         cancelButtonTitle:(NSString *)cancelButtonTitle {
    
    [UIAlertView alertViewWithTitle:title
                            message:message
                  cancelButtonTitle:cancelButtonTitle
                  otherButtonTitles:nil
                          onDismiss:nil
                           onCancel:nil];
}

#pragma mark - Protocol Conformance

#pragma mark - UIAlertView Delegate

+ (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger) buttonIndex {
    
	if (buttonIndex == [alertView cancelButtonIndex]) {
		if (alertView.cancelBlock) {
            alertView.cancelBlock();
            alertView.cancelBlock = nil;
        }
	} else {
        if (alertView.dismissBlock) {
            alertView.dismissBlock(buttonIndex - 1); // cancel button is button 0
            alertView.dismissBlock = nil;
        }
    }
}

@end
