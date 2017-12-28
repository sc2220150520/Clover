//
//  UICollectionReusableView+LDSeparatorLine.m
//  LDKitDemo
//
//  Created by lixingdong on 16/8/15.
//  Copyright © 2016年 david. All rights reserved.
//

#import "UICollectionReusableView+LDSeparatorLine.h"
#import <objc/runtime.h>

#define kScreenScale_collectionCell [UIScreen mainScreen].scale

@interface UICollectionReusableView ()

@end

@implementation UICollectionReusableView (LDSeparatorLine)

@dynamic ld_topSeparatorLine;
@dynamic ld_bottomSeparatorLine;
@dynamic ld_leftSeparatorLine;
@dynamic ld_rightSeparatorLine;

@dynamic ld_topSeparatorLineInsets;
@dynamic ld_bottomSeparatorLineInsets;
@dynamic ld_leftSeparatorLineInsets;
@dynamic ld_rightSeparatorLineInsets;

#pragma mark - Property Setter & Getter

- (UIView *)ld_topSeparatorLine
{
    UIView *separatorLine = objc_getAssociatedObject(self, @selector(ld_topSeparatorLine));
    if (separatorLine == nil) {
        separatorLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 1.0/kScreenScale_collectionCell)];
        
        separatorLine.backgroundColor = [UIColor lightGrayColor];
        [self addSubview:separatorLine];
        self.ld_topSeparatorLine = separatorLine;
        separatorLine.hidden = YES;
    }
    return separatorLine;
}

- (void)setLd_topSeparatorLine:(UIView *)topSeparatorLine
{
    objc_setAssociatedObject(self, @selector(ld_topSeparatorLine), topSeparatorLine, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIView *)ld_bottomSeparatorLine
{
    UIView *separatorLine = objc_getAssociatedObject(self, @selector(ld_bottomSeparatorLine));
    if (separatorLine == nil) {
        separatorLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 1.0/kScreenScale_collectionCell)];
        separatorLine.backgroundColor = [UIColor lightGrayColor];
        [self addSubview:separatorLine];
        self.ld_bottomSeparatorLine = separatorLine;
        separatorLine.hidden = YES;
    }
    return separatorLine;
}

- (void)setLd_bottomSeparatorLine:(UIView *)bottomSeparatorLine
{
    objc_setAssociatedObject(self, @selector(ld_bottomSeparatorLine), bottomSeparatorLine, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIView *)ld_leftSeparatorLine
{
    UIView *separatorLine = objc_getAssociatedObject(self, @selector(ld_leftSeparatorLine));
    if (separatorLine == nil) {
        separatorLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1.0/kScreenScale_collectionCell, 0)];
        separatorLine.backgroundColor = [UIColor lightGrayColor];
        [self addSubview:separatorLine];
        self.ld_leftSeparatorLine = separatorLine;
        separatorLine.hidden = YES;
    }
    return separatorLine;
}

- (void)setLd_leftSeparatorLine:(UIView *)leftSeparatorLine
{
    objc_setAssociatedObject(self, @selector(ld_leftSeparatorLine), leftSeparatorLine, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIView *)ld_rightSeparatorLine
{
    UIView *separatorLine = objc_getAssociatedObject(self, @selector(ld_rightSeparatorLine));
    if (separatorLine == nil) {
        separatorLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1.0/kScreenScale_collectionCell, 0)];
        separatorLine.backgroundColor = [UIColor lightGrayColor];
        [self addSubview:separatorLine];
        self.ld_rightSeparatorLine = separatorLine;
        separatorLine.hidden = YES;
    }
    return separatorLine;
}

- (void)setLd_rightSeparatorLine:(UIView *)rightSeparatorLine
{
    objc_setAssociatedObject(self, @selector(ld_rightSeparatorLine), rightSeparatorLine, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
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

- (UIEdgeInsets)ld_leftSeparatorLineInsets
{
    NSValue *valueObj = objc_getAssociatedObject(self, @selector(ld_leftSeparatorLineInsets));
    return [valueObj UIEdgeInsetsValue];
}

- (void)setLd_leftSeparatorLineInsets:(UIEdgeInsets)insets
{
    NSValue *valueObj = [NSValue valueWithUIEdgeInsets:insets];
    objc_setAssociatedObject(self, @selector(ld_leftSeparatorLineInsets), valueObj, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    [self setNeedsLayout];
}

- (UIEdgeInsets)ld_rightSeparatorLineInsets
{
    NSValue *valueObj = objc_getAssociatedObject(self, @selector(ld_rightSeparatorLineInsets));
    return [valueObj UIEdgeInsetsValue];
}

- (void)setLd_rightSeparatorLineInsets:(UIEdgeInsets)insets
{
    NSValue *valueObj = [NSValue valueWithUIEdgeInsets:insets];
    objc_setAssociatedObject(self, @selector(ld_rightSeparatorLineInsets), valueObj, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
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

- (void)ld_showLeftSeparatorLine
{
    self.ld_leftSeparatorLine.hidden = NO;
    
    [self setNeedsLayout];
}

- (void)ld_hideLeftSeparatorLine
{
    self.ld_leftSeparatorLine.hidden = YES;
}

- (void)ld_setLeftSeparatorLineWidth:(CGFloat)width
{
    CGRect frame = self.ld_leftSeparatorLine.frame;
    frame.size.width = width;
    self.ld_leftSeparatorLine.frame = frame;
    
    [self setNeedsLayout];
}

- (void)ld_setLeftSeparatorLineColor:(UIColor *)color
{
    self.ld_leftSeparatorLine.backgroundColor = color;
}

- (void)ld_showRightSeparatorLine
{
    self.ld_rightSeparatorLine.hidden = NO;
    
    [self setNeedsLayout];
}

- (void)ld_hideRightSeparatorLine
{
    self.ld_rightSeparatorLine.hidden = YES;
}

- (void)ld_setRightSeparatorLineWidth:(CGFloat)width
{
    CGRect frame = self.ld_rightSeparatorLine.frame;
    frame.size.width = width;
    self.ld_rightSeparatorLine.frame = frame;
    
    [self setNeedsLayout];
}

- (void)ld_setRightSeparatorLineColor:(UIColor *)color
{
    self.ld_rightSeparatorLine.backgroundColor = color;
}

#pragma mark - Private Methods

- (void)ld_updateSeparatorLine
{
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
    
    if (self.ld_leftSeparatorLine.hidden == NO) {
        CGFloat leftMargin = self.ld_leftSeparatorLineInsets.left;
        CGFloat topMargin = self.ld_leftSeparatorLineInsets.top;
        CGFloat bottomMargin = self.ld_leftSeparatorLineInsets.bottom;
        if (self.ld_leftSeparatorLineInsets.top < 1.0) {
            topMargin = CGRectGetWidth(self.bounds) * MAX(0, self.ld_leftSeparatorLineInsets.top);
        }
        if (self.ld_leftSeparatorLineInsets.bottom < 1.0) {
            bottomMargin = CGRectGetWidth(self.bounds) * MAX(0, self.ld_leftSeparatorLineInsets.bottom);
        }
        self.ld_leftSeparatorLine.frame = CGRectMake(leftMargin, topMargin, CGRectGetWidth(self.ld_leftSeparatorLine.bounds), CGRectGetHeight(self.bounds) - topMargin - bottomMargin);
        [self.ld_leftSeparatorLine.superview bringSubviewToFront:self.ld_leftSeparatorLine];
    }
    
    if (self.ld_rightSeparatorLine.hidden == NO) {
        CGFloat rightMargin = self.ld_rightSeparatorLineInsets.right;
        CGFloat topMargin = self.ld_rightSeparatorLineInsets.top;
        CGFloat bottomMargin = self.ld_rightSeparatorLineInsets.bottom;
        if (self.ld_rightSeparatorLineInsets.top < 1.0) {
            topMargin = CGRectGetWidth(self.bounds) * MAX(0, self.ld_rightSeparatorLineInsets.top);
        }
        if (self.ld_rightSeparatorLineInsets.bottom < 1.0) {
            bottomMargin = CGRectGetWidth(self.bounds) * MAX(0, self.ld_rightSeparatorLineInsets.bottom);
        }
        self.ld_rightSeparatorLine.frame = CGRectMake(CGRectGetWidth(self.bounds) - rightMargin - CGRectGetWidth(self.ld_rightSeparatorLine.bounds), topMargin, CGRectGetWidth(self.ld_rightSeparatorLine.bounds), CGRectGetHeight(self.bounds) - topMargin - bottomMargin);
        [self.ld_rightSeparatorLine.superview bringSubviewToFront:self.ld_rightSeparatorLine];
        
    }
}


@end
