//
//  UIView+LDHierarchy.m
//  LDKitDemo
//
//  Created by lixingdong on 16/8/8.
//  Copyright © 2016年 david. All rights reserved.
//

#import "UIView+LDHierarchy.h"

@implementation UIView (LDHierarchy)

- (UIViewController *)ld_detectParentController
{
    UIResponder *responder = [self nextResponder];
    while (responder) {
        if ([responder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *) responder;
        }
        responder = [responder nextResponder];
    }
    return nil;
}

- (void)ld_popViewController
{
    UIViewController *viewController = [self ld_detectParentController];
    if (viewController != nil) {
        [viewController.navigationController popViewControllerAnimated:YES];
    }
}

- (NSUInteger)ld_getSubviewIndex
{
    return [self.superview.subviews indexOfObject:self];
}

- (void)ld_bringToFront
{
    [self.superview bringSubviewToFront:self];
}

- (void)ld_sentToBack
{
    [self.superview sendSubviewToBack:self];
}

- (void)ld_bringOneLevelUp
{
    NSInteger currentIndex = [self ld_getSubviewIndex];
    [self.superview exchangeSubviewAtIndex:currentIndex withSubviewAtIndex:currentIndex+1];
}

- (void)ld_sendOneLevelDown
{
    NSInteger currentIndex = [self ld_getSubviewIndex];
    [self.superview exchangeSubviewAtIndex:currentIndex withSubviewAtIndex:currentIndex-1];
}

- (BOOL)ld_isInFront
{
    return ([self.superview.subviews lastObject]==self);
}

- (BOOL)ld_isAtBack
{
    return ([self.superview.subviews objectAtIndex:0]==self);
}

- (void)ld_swapDepthsWithView:(UIView*)swapView
{
    [self.superview exchangeSubviewAtIndex:[self ld_getSubviewIndex] withSubviewAtIndex:[swapView ld_getSubviewIndex]];
}

- (void)ld_removeAllSubviews
{
    while (self.subviews.count) {
        UIView* child = self.subviews.lastObject;
        [child removeFromSuperview];
    }
}
@end
