//
//  UIScrollView+LDScrollToTop.m
//  LDKit
//
//  Created by 金秋实 on 7/19/16.
//  Copyright © 2017年 LDKit. All rights reserved.
//

#import "UIScrollView+LDScrollToTop.h"
#import <objc/runtime.h>

@implementation UIScrollView (LDScrollToTop)

@dynamic ld_scrollToTopIconEnabled;
@dynamic ld_scrollToTopIconShownOffset;
@dynamic ld_scrollToTopIconRightCenterDistance;
@dynamic ld_scrollToTopIconBottomCenterDistance;

#pragma mark - hook
+ (void)load
{
    @autoreleasepool {
        [UIScrollView ldkit_scrollToTop_hook_start];
    }
}

+ (void)ldkit_scrollToTop_hook_start
{
    Class clazz = NSClassFromString(@"UIScrollView");
    Method setContentOffsetMethod = class_getInstanceMethod(clazz, @selector(setContentOffset:));
    Method newSetContentOffsetMethod = class_getInstanceMethod(clazz, @selector(ldkit_setContentOffsetMethod:));
    if (setContentOffsetMethod && newSetContentOffsetMethod) {
        method_exchangeImplementations(setContentOffsetMethod, newSetContentOffsetMethod);
    }
}

#pragma mark - Getter & Setter

- (UIButton *)ld_scrollToTopIcon
{
    UIButton *icon = objc_getAssociatedObject(self, @selector(ld_scrollToTopIcon));
    if (icon == nil) {
        icon = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 38.0f, 38.0f)];
        icon.center = CGPointMake(CGRectGetWidth(self.bounds) - 29.0, CGRectGetHeight(self.bounds) - 29.0);
        [self addSubview:icon];
        [icon setBackgroundImage:[UIImage imageNamed:@"ld_scrollToTop"]
                        forState:UIControlStateNormal];
        [icon addTarget:self action:@selector(ld_scrollToTopIconTaped:) forControlEvents:UIControlEventTouchUpInside];
        [self bringSubviewToFront:icon];
        self.ld_scrollToTopIcon = icon;
        icon.hidden = YES;
    }
    return icon;
}

- (void)setLd_scrollToTopIcon:(UIButton *)scrollToTopIcon
{
    objc_setAssociatedObject(self, @selector(ld_scrollToTopIcon), scrollToTopIcon, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CGFloat)ld_scrollToTopIconShownOffset
{
    NSNumber *numberObj = objc_getAssociatedObject(self, @selector(ld_scrollToTopIconShownOffset));
    if (numberObj == nil) {
        self.ld_scrollToTopIconShownOffset = CGRectGetHeight(self.bounds);
        return CGRectGetHeight(self.bounds);
    }
    return [numberObj floatValue];
}

- (void)setLd_scrollToTopIconShownOffset:(CGFloat)offset
{
    NSNumber *numberObj = [NSNumber numberWithFloat:offset];
    objc_setAssociatedObject(self, @selector(ld_scrollToTopIconShownOffset), numberObj, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)ld_scrollToTopIconEnabled
{
    NSNumber *numberObj = objc_getAssociatedObject(self, @selector(ld_scrollToTopIconEnabled));
    return [numberObj boolValue];
}

- (void)setLd_scrollToTopIconEnabled:(BOOL)isEnabled
{
    NSNumber *numberObj = [NSNumber numberWithBool:isEnabled];
    if (isEnabled == NO) {
        self.ld_scrollToTopIcon.hidden = YES;
        self.ld_scrollToTopIcon = nil;
    }
    objc_setAssociatedObject(self, @selector(ld_scrollToTopIconEnabled), numberObj, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CGFloat)ld_scrollToTopIconRightCenterDistance
{
    NSNumber *numberObj = objc_getAssociatedObject(self, @selector(ld_scrollToTopIconRightCenterDistance));
    if (numberObj == nil) {
        self.ld_scrollToTopIconRightCenterDistance = 29.0;
        return 29.0;
    }
    return [numberObj floatValue];
}

- (void)setLd_scrollToTopIconRightCenterDistance:(CGFloat)distance
{
    NSNumber *numberObj = [NSNumber numberWithFloat:distance];
    objc_setAssociatedObject(self, @selector(ld_scrollToTopIconRightCenterDistance), numberObj, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CGFloat)ld_scrollToTopIconBottomCenterDistance
{
    NSNumber *numberObj = objc_getAssociatedObject(self, @selector(ld_scrollToTopIconBottomCenterDistance));
    if (numberObj == nil) {
        self.ld_scrollToTopIconBottomCenterDistance = 29.0;
        return 29.0;
    }
    return [numberObj floatValue];
}

- (void)setLd_scrollToTopIconBottomCenterDistance:(CGFloat)distance
{
    NSNumber *numberObj = [NSNumber numberWithFloat:distance];
    objc_setAssociatedObject(self, @selector(ld_scrollToTopIconBottomCenterDistance), numberObj, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

#pragma mark - Private Methods

- (void)ldkit_setContentOffsetMethod:(CGPoint)offset
{
    [self ldkit_setContentOffsetMethod:offset];
    if (self.ld_scrollToTopIconEnabled) {
        if (offset.y > self.ld_scrollToTopIconShownOffset) {
            self.ld_scrollToTopIcon.hidden = NO;
            CGPoint point = CGPointMake(CGRectGetWidth(self.bounds) - self.ld_scrollToTopIconRightCenterDistance, CGRectGetHeight(self.bounds) - self.ld_scrollToTopIconBottomCenterDistance);
            point.y += offset.y;
            self.ld_scrollToTopIcon.center = point;
        } else {
            self.ld_scrollToTopIcon.hidden = YES;
        }
    }
}

- (void)ld_scrollToTopIconTaped:(id)sender
{
    [self setContentOffset:CGPointZero animated:YES];
}

@end
