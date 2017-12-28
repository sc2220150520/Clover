//
//  UITableViewCell+LDSeparatorLine.m
//  LDKitDemo
//
//  Created by lixingdong on 16/8/8.
//  Copyright © 2016年 david. All rights reserved.
//

#import "UITableViewCell+LDSeparatorLine.h"
#import <objc/runtime.h>

@interface UITableViewCell()

@end


@implementation UITableViewCell (LDSeparatorLine)
@dynamic ld_topSeparatorLine;
@dynamic ld_bottomSeparatorLine;
@dynamic ld_topSeparatorLineInsets;
@dynamic ld_bottomSeparatorLineInsets;

+ (void)load
{
    Method orgMethod = class_getInstanceMethod(self, @selector(layoutSubviews));
    Method hookMethod = class_getInstanceMethod(self, @selector(ld_hook_layoutSubviews));
    
    if (orgMethod && hookMethod) {
        method_exchangeImplementations(orgMethod, hookMethod);
    }
}

#pragma mark - Property Setter & Getter

- (UIView *)ld_topSeparatorLine
{
    UIView *separatorLine = objc_getAssociatedObject(self, @selector(ld_topSeparatorLine));
    if (separatorLine == nil) {
        separatorLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0.5f)];
        separatorLine.backgroundColor = [UIColor lightGrayColor];
        [self addSubview:separatorLine];
        self.ld_topSeparatorLine = separatorLine;
        separatorLine.hidden = YES;
    }
    return separatorLine;
}

- (void)setLd_topSeparatorLine:(UIView *)ld_topSeparatorLine
{
    objc_setAssociatedObject(self, @selector(ld_topSeparatorLine), ld_topSeparatorLine, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIView *)ld_bottomSeparatorLine
{
    UIView *separatorLine = objc_getAssociatedObject(self, @selector(ld_bottomSeparatorLine));
    if (separatorLine == nil) {
        separatorLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0.5f)];
        separatorLine.backgroundColor = [UIColor lightGrayColor];
        [self addSubview:separatorLine];
        self.ld_bottomSeparatorLine = separatorLine;
        separatorLine.hidden = YES;
    }
    return separatorLine;
}

- (void)setLd_bottomSeparatorLine:(UIView *)ld_bottomSeparatorLine
{
    objc_setAssociatedObject(self, @selector(ld_bottomSeparatorLine), ld_bottomSeparatorLine, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIEdgeInsets)ld_topSeparatorLineInsets
{
    NSValue *valueObj = objc_getAssociatedObject(self, @selector(ld_topSeparatorLineInsets));
    return [valueObj UIEdgeInsetsValue];
}

- (void)setLd_topSeparatorLineInsets:(UIEdgeInsets)insets
{
    NSValue *valueObj = [NSValue valueWithUIEdgeInsets:insets];
    objc_setAssociatedObject(self, @selector(ld_topSeparatorLineInsets), valueObj, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    [self setNeedsLayout];
}

- (UIEdgeInsets)ld_bottomSeparatorLineInsets
{
    NSValue *valueObj = objc_getAssociatedObject(self, @selector(ld_bottomSeparatorLineInsets));
    return [valueObj UIEdgeInsetsValue];
}

- (void)setLd_bottomSeparatorLineInsets:(UIEdgeInsets)insets
{
    NSValue *valueObj = [NSValue valueWithUIEdgeInsets:insets];
    objc_setAssociatedObject(self, @selector(ld_bottomSeparatorLineInsets), valueObj, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    [self setNeedsLayout];
}

#pragma mark - Public Methods

- (void)ld_showTopSeparatorLine
{
    self.ld_topSeparatorLine.hidden = NO;
    
    [self setNeedsLayout];
}

- (void)ld_hideTopSeparatorLine
{
    self.ld_topSeparatorLine.hidden = YES;
}

- (void)ld_setTopSeparatorLineHeight:(CGFloat)height
{
    CGRect frame = self.ld_topSeparatorLine.frame;
    frame.size.height = height;
    self.ld_topSeparatorLine.frame = frame;
    
    [self setNeedsLayout];
}

- (void)ld_setTopSeparatorLineColor:(UIColor *)color
{
    self.ld_topSeparatorLine.backgroundColor = color;
}

- (void)ld_showBottomSeparatorLine
{
    self.ld_bottomSeparatorLine.hidden = NO;
    
    [self setNeedsLayout];
}

- (void)ld_hideBottomSeparatorLine
{
    self.ld_bottomSeparatorLine.hidden = YES;
}

- (void)ld_setBottomSeparatorLineHeight:(CGFloat)height
{
    CGRect frame = self.ld_bottomSeparatorLine.frame;
    frame.size.height = height;
    self.ld_bottomSeparatorLine.frame = frame;
    
    [self setNeedsLayout];
}

- (void)ld_setBottomSeparatorLineColor:(UIColor *)color
{
    self.ld_bottomSeparatorLine.backgroundColor = color;
}

#pragma mark - Private Methods

- (void)ld_hook_layoutSubviews
{
    [self ld_hook_layoutSubviews];
    
    if (self.ld_topSeparatorLine.hidden == NO) {
        CGFloat topMargin = self.ld_topSeparatorLineInsets.top;
        CGFloat leftMargin = self.ld_topSeparatorLineInsets.left;
        CGFloat rightMargin = self.ld_topSeparatorLineInsets.right;
        if (self.ld_topSeparatorLineInsets.left < 1.0) {
            leftMargin = CGRectGetWidth(self.bounds) * MAX(0, self.ld_topSeparatorLineInsets.left);
        }
        if (self.ld_topSeparatorLineInsets.right < 1.0) {
            rightMargin = CGRectGetWidth(self.bounds) * MAX(0, self.ld_topSeparatorLineInsets.right);
        }
        self.ld_topSeparatorLine.frame = CGRectMake(leftMargin, topMargin, CGRectGetWidth(self.bounds) - leftMargin - rightMargin, CGRectGetHeight(self.ld_topSeparatorLine.bounds));
        [self.ld_topSeparatorLine.superview bringSubviewToFront:self.ld_topSeparatorLine];
    }
    
    if (self.ld_bottomSeparatorLine.hidden == NO) {
        CGFloat bottomMargin = self.ld_bottomSeparatorLineInsets.bottom;
        CGFloat leftMargin = self.ld_bottomSeparatorLineInsets.left;
        CGFloat rightMargin = self.ld_bottomSeparatorLineInsets.right;
        if (self.ld_bottomSeparatorLineInsets.left < 1.0) {
            leftMargin = CGRectGetWidth(self.bounds) * MAX(0, self.ld_bottomSeparatorLineInsets.left);
        }
        if (self.ld_bottomSeparatorLineInsets.right < 1.0) {
            rightMargin = CGRectGetWidth(self.bounds) * MAX(0, self.ld_bottomSeparatorLineInsets.right);
        }
        self.ld_bottomSeparatorLine.frame = CGRectMake(leftMargin, CGRectGetHeight(self.bounds) - bottomMargin - CGRectGetHeight(self.ld_bottomSeparatorLine.bounds), CGRectGetWidth(self.bounds) - leftMargin - rightMargin, CGRectGetHeight(self.ld_bottomSeparatorLine.bounds));
        [self.ld_bottomSeparatorLine.superview bringSubviewToFront:self.ld_bottomSeparatorLine];
    }
}

@end
