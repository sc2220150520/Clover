//
//  LDMBView.m
//  LDKitDemo
//
//  Created by Yang Ning on 9/8/16.
//  Copyright © 2016 LDKit. All rights reserved.
//

#import "LDMBView.h"
#import "LDMBTitleView.h"
#import "LDMBTextView.h"
#import "LDMBHintView.h"
#import "LDMBCheckboxView.h"
#import "LDMBButtonView.h"

@interface LDMBView ()

@property (nonatomic, strong) LDMBNormalView *normalView;

@property (nonatomic, strong) LDMBButtonView *buttonView;

@property (nonatomic, strong) UIView *shadowView;//背景蒙层 和self是同一个superView

@property (nonatomic, copy) LDMBDissmissBlock dismissBlock;

@property (nonatomic, strong) NSLayoutConstraint *centerYWithOffset;

@property (nonatomic, assign) LDCPAnimationVerticalPositionType beginPosition;
@property (nonatomic, assign) LDCPAnimationVerticalPositionType dismissPosition;

@end

@implementation LDMBView

- (nonnull instancetype)initWithNormalView:(nonnull LDMBNormalView *)normalView
                              confirmTitle:(nullable NSString *)confirmTitle
                               cancelTitle:(nullable NSString *)cancelTitle
                                 onDismiss:(nullable LDMBDissmissBlock)dismissBlock
{
    if (self = [super initWithFrame:CGRectZero]) {
        self.dismissPosition = 0;
        self.beginPosition = 0;
        
        self.translatesAutoresizingMaskIntoConstraints = NO;
        self.backgroundColor = [UIColor whiteColor];
        self.layer.cornerRadius = 5.0;
        self.layer.masksToBounds = YES;
        self.layer.borderWidth = 1 / [UIScreen mainScreen].scale;
        self.layer.borderColor = [UIColor colorWithRed:0xFD / 255.0 green:0xFD / 255.0 blue:0xFD / 255.0 alpha:1.0].CGColor;
        _normalView = normalView;
        _dismissBlock = [dismissBlock copy];
        [self addSubview:_normalView];
        
        __weak typeof(self) weakSelf = self;
        self.buttonView = [[LDMBButtonView alloc] initWithConfirmTitle:confirmTitle cancelTitle:cancelTitle clickedAction:^(NSInteger index, NSString * _Nonnull dismissButtonTitle) {
            __strong typeof(self) strongSelf  = weakSelf;
            [strongSelf dismissWithIndex:index buttonTitle:dismissButtonTitle];
        }];
        [self addSubview:self.buttonView];

        [self setupConstraints];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillPop:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardHidden:) name:UIKeyboardWillHideNotification object:nil];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setupConstraints
{
    NSDictionary *views = NSDictionaryOfVariableBindings(_normalView, _buttonView);
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_normalView(270)]|"
                                                                 options:0
                                                                 metrics:nil
                                                                   views:views]];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_buttonView]|"
                                                                 options:0
                                                                 metrics:nil
                                                                   views:views]];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_normalView][_buttonView(44)]|"
                                                                 options:0
                                                                 metrics:nil
                                                                   views:views]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_normalView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationLessThanOrEqual toItem:nil attribute:NSLayoutAttributeHeight multiplier:0.0 constant:281.0]];
}

#pragma mark - lazy init
- (UIView *)shadowView
{
    if (!_shadowView) {
        _shadowView = [UIView new];
        _shadowView.translatesAutoresizingMaskIntoConstraints = NO;
        _shadowView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
    }
    return _shadowView;
}

#pragma mark - show and dismiss
- (void)show
{
    UIWindow *window = [self topValidWindow];
    if (window) {
        if ([[window subviews] containsObject:self]) {
            return;
        }
        [self addOnWindow:window];
    } else {
        NSAssert(0, @"当前没有window可以用");
    }
}

- (void)animateShowWithBeginPosition:(LDCPAnimationVerticalPositionType)beginPosition
                  andDismissPosition:(LDCPAnimationVerticalPositionType)dismissPosition
{
    UIWindow *window = [self topValidWindow];
    if (window) {
        if ([[window subviews] containsObject:self]) {
            return;
        }
        self.beginPosition = beginPosition;
        self.dismissPosition = dismissPosition;
        [self addOnWindow:window];
    } else {
        NSAssert(0, @"当前没有window可以用");
    }
}

- (void)addOnWindow:(nonnull UIWindow *)window
{
    [window addSubview:self.shadowView];
    NSDictionary *views = NSDictionaryOfVariableBindings(_shadowView);
    [window addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_shadowView]|" options:0 metrics:nil views:views]];
    [window addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_shadowView]|" options:0 metrics:nil views:views]];
    
    [window addSubview:self];
}

- (void)doDefaultDisplayAnimation
{
    CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    scaleAnimation.fromValue = @(1.15);
    scaleAnimation.toValue   = @(1.0);
    scaleAnimation.fillMode  = kCAFillModeBackwards;
    scaleAnimation.duration  = 0.23;
    scaleAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    
    CABasicAnimation *opacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    opacityAnimation.fromValue = @(0.0);
    opacityAnimation.toValue   = @(1.0);
    opacityAnimation.fillMode  = kCAFillModeBackwards;
    opacityAnimation.duration  = 0.23;
    
    CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
    animationGroup.animations = @[scaleAnimation, opacityAnimation];
    [self.layer addAnimation:animationGroup forKey:nil];
    
    CABasicAnimation *shadowAnimation = [CABasicAnimation animationWithKeyPath:@"backgroundColor"];
    shadowAnimation.fromValue = (id)[UIColor clearColor].CGColor;
    shadowAnimation.toValue = (id)[[UIColor blackColor] colorWithAlphaComponent:0.4].CGColor;
    shadowAnimation.fillMode = kCAFillModeBackwards;
    shadowAnimation.duration = 0.23;
    [self.shadowView.layer addAnimation:shadowAnimation forKey:nil];
}

- (void)dismissWithIndex:(NSInteger)index buttonTitle:(NSString *)title
{
    if (self.dismissPosition >= LDCPAnimationVerticalPositionTypeTopUpperPlace && self.dismissPosition <= LDCPAnimationVerticalPositionTypeBottomLowerPlace) {
        __weak typeof(self) weakSelf = self;
        [self animateCenterYConstraint:self.centerYWithOffset toPosition:self.dismissPosition duration:0 completion:^(BOOL finished, NSLayoutConstraint * _Nullable constraint) {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            if (strongSelf.dismissBlock) {
                strongSelf.dismissBlock(strongSelf, index, title, strongSelf.normalView.constructor.showCheck, [strongSelf.normalView checkBoxEnable], strongSelf.normalView.constructor.showTextField, [strongSelf.normalView textFieldText]);
                strongSelf.dismissBlock = nil;
            }
            [strongSelf removeSelfAddShadow];
        }];
    } else {
        [UIView
         animateWithDuration:0.23
         animations:^{
             self.alpha = 0.0;
             self.shadowView.backgroundColor = [UIColor clearColor];
         } completion:^(BOOL finished) {
             if (self.dismissBlock) {
                 __weak typeof(self) weakSelf = self;
                 self.dismissBlock(weakSelf, index, title, weakSelf.normalView.constructor.showCheck, [weakSelf.normalView checkBoxEnable], weakSelf.normalView.constructor.showTextField, [weakSelf.normalView textFieldText]);
                 self.dismissBlock = nil;
             }
             [self removeSelfAddShadow];
         }];
    }
}

- (void)removeSelfAddShadow
{
    [self.shadowView removeFromSuperview];
    [self removeFromSuperview];
}

- (nullable UIWindow *)topValidWindow {
    NSEnumerator *frontToBackWindows = [UIApplication.sharedApplication.windows reverseObjectEnumerator];
    for (UIWindow *window in frontToBackWindows) {
        BOOL windowOnMainScreen = window.screen == UIScreen.mainScreen;
        BOOL windowIsVisible = !window.hidden && window.alpha > 0;
        BOOL windowLevelSupported = (window.windowLevel >= UIWindowLevelNormal);// && window.windowLevel <= self.maxSupportedWindowLevel
        
        if(windowOnMainScreen && windowIsVisible && windowLevelSupported) {
            return window;
        }
    }
    
    return nil;
}

#pragma mark - self被加在父view上或从父view移除
- (void)didMoveToSuperview
{
    [super didMoveToSuperview];
    if (self.superview) {        
        [self.superview addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.superview attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0.0]];
        
        if (_beginPosition == 0) {
            _centerYWithOffset = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.superview attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0.0];
            [self.superview addConstraint:_centerYWithOffset];
            [self doDefaultDisplayAnimation];
        } else {
            __weak typeof(self) weakSelf = self;
            [self animateCenterYConstraintFromPosition:weakSelf.beginPosition toPosition:LDCPAnimationVerticalPositionTypeMiddle duration:0 completion:^(BOOL finished, NSLayoutConstraint * _Nullable constraint) {
                weakSelf.centerYWithOffset = constraint;
            }];
        }
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
}

#pragma mark 键盘通知处理

#pragma mark - LDCPTextFieldViewDelegate

- (void)keyBoardWillPop:(NSNotification *)notification
{
    NSNumber *animationCurve = [notification.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    NSNumber *animationDuration = [notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSValue *endFrameValue = [notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    
    CGRect newFrame = self.frame;
    CGFloat temp = CGRectGetMinY(newFrame) + CGRectGetMaxY([self.normalView.weakTextField convertRect:self.normalView.weakTextField.bounds toView:self]) - CGRectGetMinY([endFrameValue CGRectValue]);
    if (temp > 0.0) {
        [self.superview layoutIfNeeded];
        _centerYWithOffset.constant = - temp;
        [UIView animateWithDuration:[animationDuration doubleValue] delay:0.0 options:[animationCurve integerValue] << 16 animations:^{
            [self.superview layoutIfNeeded];
        } completion:nil];
    }
}

- (void)keyBoardHidden:(NSNotification *)notification
{
    NSNumber *animationCurve = [notification.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    NSNumber *animationDuration = [notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    
    if (self.centerYWithOffset.constant < 0.0) {
        [self.superview layoutIfNeeded];
        _centerYWithOffset.constant = 0.0;
        [UIView animateWithDuration:[animationDuration doubleValue] delay:0.0 options:[animationCurve integerValue] << 16 animations:^{
            [self.superview layoutIfNeeded];
        } completion:nil];
    }
}

@end
