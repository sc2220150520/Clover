//
//  UIViewController+LDToast.m
//  LDKit
//
//  Created by fanxuejiao on 17/3/17.
//  Copyright © 2017年 LDKit. All rights reserved.
//

#import "UIViewController+LDToast.h"
#import "LDLightAlert.h"
#import <objc/runtime.h>

@implementation UIViewController (LDToast)

- (UIActivityIndicatorView *)ld_indicator
{
    return objc_getAssociatedObject(self, @selector(ld_indicator));
}

- (void)setLd_indicator:(UIActivityIndicatorView *)ld_indicator
{
    return objc_setAssociatedObject(self, @selector(ld_indicator), ld_indicator, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)ld_createActivityIndicator
{
    [self ld_createActivityIndicatorWithStyle:UIActivityIndicatorViewStyleGray];
}

- (void)ld_createActivityIndicatorWithStyle:(UIActivityIndicatorViewStyle)style
{
    [self ld_createActivityIndicatorWithStyle:style center:self.view.center];
}

- (void)ld_createActivityIndicatorWithStyle:(UIActivityIndicatorViewStyle)style center:(CGPoint)center
{
    [self ld_removeActivityIndicator];
    self.ld_indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:style];
    self.ld_indicator.center = center;
    self.ld_indicator.autoresizingMask = UIViewAutoresizingFlexibleTopMargin |
                                         UIViewAutoresizingFlexibleBottomMargin;
    self.ld_indicator.hidesWhenStopped = YES;
    if (self.view.superview) {
        [self.view.superview addSubview:self.ld_indicator];
    } else {
        [self.view addSubview:self.ld_indicator];
    }
    [self.ld_indicator startAnimating];
}

- (void)ld_removeActivityIndicator
{
    if (self.ld_indicator) {
        [self.ld_indicator stopAnimating];
        [self.ld_indicator removeFromSuperview];
        self.ld_indicator = nil;
    }
}

- (void)ld_toastWithText:(NSString *)text
{
    if (text && text.length > 0) {
        [LDLightAlert
         ld_showMsg:text duration:1.5
         inView:self.navigationController ? self.navigationController.view : self.view];
    }
}

- (void)ld_toastWithError:(NSError *)error
{
    if ([error.localizedDescription length]) {
        [self ld_toastWithText:error.localizedDescription];
    } else {
        NSString *desc = [NSString stringWithFormat:@"%@ (%ld)", @"未知错误", (unsigned long)error.code];
        [self ld_toastWithText:desc];
    }
}

@end
