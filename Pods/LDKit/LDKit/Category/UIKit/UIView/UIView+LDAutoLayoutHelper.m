//
//  UIView+LDAutoLayoutHelper.m
//  LDKitDemo
//
//  Created by lixingdong on 16/8/8.
//  Copyright © 2016年 david. All rights reserved.
//

#import "UIView+LDAutoLayoutHelper.h"

@implementation UIView (LDAutoLayoutHelper)

- (void)ld_cleanConstraints {
    [self removeConstraints:self.constraints];
    UIView *superview = self.superview;
    if (superview) {
        NSInteger index = [superview.subviews indexOfObject:self];
        [self removeFromSuperview];
        [superview insertSubview:self atIndex:index];
    }
}

@end
