//
//  UIView+LDCPPopupLayoutSubViewAnimated.m
//  LDKitDemo
//
//  Created by xuejiao fan on 11/10/16.
//  Copyright © 2016 LDKit. All rights reserved.
//

#import "UIView+LDCPPopupLayoutSubViewAnimated.h"
#import <objc/runtime.h>

@interface UIView ()

//@property (nullable, nonatomic, strong) LDCPPopupViewAnimateFinished showAnimateFinishedBlock;
//@property (nullable, nonatomic, strong) LDCPPopupViewAnimateFinished dismissAnimateFinishedBlock;

@property (nullable, nonatomic, strong) UIView *animateSubview;

@property (nullable, nonatomic, strong) UIView *shadowView;
@property (nullable, nonatomic, strong) LDCPPopupViewShadowResponse shadowResponseBlock;

@property (nullable, nonatomic, strong) NSLayoutConstraint *categoryCenterYConstraint;

@end

@implementation UIView (LDCPPopupLayoutSubViewAnimated)

- (void)animateCenterYConstraintFromPosition:(LDCPAnimationVerticalPositionType)benginPosition
                      toPosition:(LDCPAnimationVerticalPositionType)endPosition
                        duration:(CFTimeInterval)duration
                      completion:(void (^ __nullable)(BOOL finished, NSLayoutConstraint * _Nullable constraint))completion
{
    NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.superview attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:[self centerYOffSet:benginPosition]];
    [self.superview addConstraint:constraint];
    [self.superview layoutIfNeeded];
        
    CFTimeInterval animationDuration = duration;
    if (animationDuration <= 0) {
        animationDuration = LDCPPopupViewAnimateShowDuration;
    }
    self.alpha = 0;
    constraint.constant = [self centerYOffSet:endPosition];
    [UIView animateWithDuration:animationDuration animations:^{
        [self.superview layoutIfNeeded];
        self.alpha = 1;
    } completion:^(BOOL finished) {
        if (completion) {
            completion(finished, constraint);
        }
    }];
}

- (void)animateCenterYConstraint:(nonnull NSLayoutConstraint *)constraint
                      toPosition:(LDCPAnimationVerticalPositionType)endPosition
                        duration:(CFTimeInterval)duration
                      completion:(void (^ __nullable)(BOOL finished, NSLayoutConstraint * _Nullable constraint))completion
{
    if (!constraint) {
        return;
    }
    CFTimeInterval animationDuration = duration;
    if (animationDuration <= 0) {
        animationDuration = LDCPPopupViewAnimateShowDuration;
    }
    self.alpha = 1;
    [self.superview layoutIfNeeded];
    constraint.constant = [self centerYOffSet:endPosition];
    [UIView animateWithDuration:animationDuration animations:^{
        [self.superview layoutIfNeeded];
        self.alpha = 0;
    } completion:^(BOOL finished) {
        if (completion) {
            completion(finished, nil);
        }
    }];
}

- (CGFloat)centerYOffSet:(LDCPAnimationVerticalPositionType)position
{
    [self.superview setNeedsLayout];
    [self.superview layoutIfNeeded];
    CGSize size = [self systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
//    CGSize size = self.bounds.size;

    switch (position) {
        case LDCPAnimationVerticalPositionTypeTopUpperPlace:
            return size.height - (CGRectGetHeight(self.superview.bounds)) / 2 - LDCPPopupViewAnimateBufferSpace;
            break;
            
        case LDCPAnimationVerticalPositionTypeTop:
            return (size.height - CGRectGetHeight(self.superview.bounds)) / 2;
            break;
            
        case LDCPAnimationVerticalPositionTypeMiddleUpperPlace:
            return -100;
            break;
            
        case LDCPAnimationVerticalPositionTypeMiddle:
            return 0;
            break;
            
        case LDCPAnimationVerticalPositionTypeMiddleLowerPlace:
            return 100;
            break;
            
        case LDCPAnimationVerticalPositionTypeBottom:
            return (CGRectGetHeight(self.superview.bounds) - size.height) / 2;
            break;
            
        case LDCPAnimationVerticalPositionTypeBottomLowerPlace:
            return (CGRectGetHeight(self.superview.bounds)) / 2 + size.height + LDCPPopupViewAnimateBufferSpace;
            break;
            
        default:
            return 0;
            break;
    }
}

//- (BOOL)isThePageVisible:(CGFloat)centerYOffset
//{
//    CGSize size = [self.animateSubview systemLayoutSizeFittingSize:self.animateSubview.intrinsicContentSize];
//    if (centerYOffset <= - (CGRectGetHeight(self.superview.bounds) + size.height) / 2) {
//        return NO;
//    } else if (centerYOffset >= (CGRectGetHeight(self.superview.bounds) + size.height) / 2) {
//        return NO;
//    } else {
//        return YES;
//    }
//}

@end
