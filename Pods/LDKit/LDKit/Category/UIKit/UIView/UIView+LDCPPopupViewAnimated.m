//
//  UIView+LDCPPopupViewAnimated.m
//  Pods
//
//  Created by xuejiao fan on 6/30/16.
//
//

#import "UIView+LDCPPopupViewAnimated.h"
#import <objc/runtime.h>

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
@interface UIView () <CAAnimationDelegate>
#else
@interface UIView ()
#endif

@property (nullable, nonatomic, strong) LDCPPopupViewAnimateFinished showAnimateFinishedBlock;
@property (nullable, nonatomic, strong) LDCPPopupViewAnimateFinished dismissAnimateFinishedBlock;

@property (nullable, nonatomic, strong) UIView *animateSubview;

@property (nullable, nonatomic, strong) UIView *shadowView;
@property (nullable, nonatomic, strong) LDCPPopupViewShadowResponse shadowResponseBlock;

@end

@implementation UIView (LDCPPopupViewAnimated)

#pragma mark - public method

#pragma mark - view出现的动画
- (void)animateAddSubview:(nonnull UIView *)view
            beginPosition:(LDCPAnimationVerticalPositionType)beginPosition
              endPosition:(LDCPAnimationVerticalPositionType)endPosition
                 duration:(CFTimeInterval)duration
            timingFuction:(nullable CAMediaTimingFunction *)timingFuction
               completion:(void (^ __nullable)(BOOL finished))completion
      shadowResponseBlock:(void (^ __nullable)(void))shadowResponse
{
    if (view) {
        CGRect showAnimateBeginFrame = [self animateSubview:view postionType:beginPosition];
        CGRect showAnimateEndFrame = [self animateSubview:view postionType:endPosition];
        
        [self animateAddSubview:view
                     beginFrame:showAnimateBeginFrame
                       endFrame:showAnimateEndFrame
                       duration:duration
                  timingFuction:timingFuction
                     completion:completion
            shadowResponseBlock:shadowResponse];
        
    }
    
}

- (void)animateAddSubview:(nonnull UIView *)view
            beginFrame:(CGRect)beginFrame
              endFrame:(CGRect)endFrame
                 duration:(CFTimeInterval)duration
            timingFuction:(nullable CAMediaTimingFunction *)timingFuction
               completion:(void (^ __nullable)(BOOL finished))completion
      shadowResponseBlock:(void (^ __nullable)(void))shadowResponse
{
    if (self.animateSubview) {
        NSAssert(0, @"已经存在一个动画展示的view");
    }
    if (!CGRectEqualToRect(beginFrame, CGRectZero) && !CGRectEqualToRect(endFrame, CGRectZero)) {
        self.animateSubview = view;
        self.shadowResponseBlock = shadowResponse;
        self.showAnimateFinishedBlock = completion;
        [self addSubview:self.shadowView];
        [self addSubview:view];
        //减速划入的动画
        view.alpha = 1;
        view.frame = endFrame;
        self.shadowView.alpha = 1;
        
        CFTimeInterval animationDuration = duration;
        if (animationDuration <= 0) {
            animationDuration = LDCPPopupViewAnimateShowDuration;
        }
        CAMediaTimingFunction *animationTimingFuction = timingFuction;
        if (animationTimingFuction == nil) {
            animationTimingFuction = [[CAMediaTimingFunction alloc] initWithControlPoints:0.0f :0.0f :0.2f :1.0f];
        }
        
        //判断view的初始位置是否在self内
        if ([self isTheFrameInside:beginFrame]) {
            CABasicAnimation *viewAlphaAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
            [viewAlphaAnimation setFillMode:kCAFillModeBoth];
            [viewAlphaAnimation setRemovedOnCompletion:YES];
            viewAlphaAnimation.duration = animationDuration;
            [viewAlphaAnimation setFromValue:@(0)];
            [viewAlphaAnimation setToValue:@(1)];
            [view.layer addAnimation:viewAlphaAnimation forKey:@"presentViewAlphaAnimation"];
        }
        
        CABasicAnimation *presentPostionAnimation = [CABasicAnimation animationWithKeyPath:@"position"];
        [presentPostionAnimation setFromValue:[NSValue valueWithCGPoint:CGPointMake(CGRectGetMidX(beginFrame), CGRectGetMidY(beginFrame))]];
        [presentPostionAnimation setToValue:[NSValue valueWithCGPoint:CGPointMake(CGRectGetMidX(endFrame), CGRectGetMidY(endFrame))]];
        
        CABasicAnimation *presentBoundsAnimation = [CABasicAnimation animationWithKeyPath:@"bounds"];
        [presentBoundsAnimation setFromValue:[NSValue valueWithCGSize:beginFrame.size]];
        [presentBoundsAnimation setToValue:[NSValue valueWithCGSize:endFrame.size]];
        
        CAAnimationGroup *presentGroup = [CAAnimationGroup animation];
        presentGroup.animations = @[presentPostionAnimation,presentBoundsAnimation];
        presentGroup.delegate = self;
        [presentGroup setFillMode:kCAFillModeBoth];
        [presentGroup setRemovedOnCompletion:YES];
        presentGroup.duration = animationDuration;
        [presentGroup setTimingFunction:animationTimingFuction];
        [presentGroup setValue:LDCPPopupViewShowAnimationValue forKeyPath:LDCPPopupViewShowAnimationKey];
        [view.layer addAnimation:presentGroup forKey:LDCPPopupViewShowAnimationKey];
        
        
        CABasicAnimation *presentAlphaAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
        [presentAlphaAnimation setFillMode:kCAFillModeBoth];
        [presentAlphaAnimation setRemovedOnCompletion:YES];
        presentAlphaAnimation.duration = animationDuration;
        [presentAlphaAnimation setFromValue:@(0)];
        [presentAlphaAnimation setToValue:@(1)];
        [self.shadowView.layer addAnimation:presentAlphaAnimation forKey:@"presentAlphaAnimation"];
        
    }
}

#pragma mark - view消失的动画
- (void)animateRemoveWithEndPosition:(LDCPAnimationVerticalPositionType)endPosition
                            duration:(CFTimeInterval)duration
                       timingFuction:(nullable CAMediaTimingFunction *)timingFuction
                          completion:(void (^ __nullable)(BOOL finished))completion
{
    if (self.superview) {
        CGRect animateEndFrame = [self.superview animateSubview:self postionType:endPosition];
        [self animateRemoveWithEndFrame:animateEndFrame duration:duration timingFuction:timingFuction completion:completion];
    }
}

- (void)animateRemoveWithEndFrame:(CGRect)endFrame
                         duration:(CFTimeInterval)duration
                    timingFuction:(nullable CAMediaTimingFunction *)timingFuction
                       completion:(void (^ __nullable)(BOOL finished))completion
{
    self.animateSubview = self;
    self.dismissAnimateFinishedBlock = completion;
    
    CGRect beginFrame = self.frame;
    //加速划出的动画
    self.frame = endFrame;
    self.shadowView.alpha = 0;
    
    CFTimeInterval animationDuration = duration;
    if (animationDuration <= 0) {
        animationDuration = LDCPPopupViewAnimateDismissDuration;
    }
    CAMediaTimingFunction *animationTimingFuction = timingFuction;
    if (animationTimingFuction == nil) {
        animationTimingFuction = [[CAMediaTimingFunction alloc] initWithControlPoints:0.4f :0.0f :1.0f :1.0f];
    }
    
    //判断view的初始位置是否在self内
    if ([self isTheFrameInside:endFrame]) {
        CABasicAnimation *viewAlphaAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
        [viewAlphaAnimation setFillMode:kCAFillModeBoth];
        [viewAlphaAnimation setRemovedOnCompletion:YES];
        viewAlphaAnimation.duration = animationDuration;
        [viewAlphaAnimation setFromValue:@(1)];
        [viewAlphaAnimation setToValue:@(0)];
        [self.layer addAnimation:viewAlphaAnimation forKey:@"dismissViewAlphaAnimation"];
    }
    
    CABasicAnimation *dismissPostionAnimation = [CABasicAnimation animationWithKeyPath:@"position"];
    [dismissPostionAnimation setFromValue:[NSValue valueWithCGPoint:CGPointMake(CGRectGetMidX(beginFrame), CGRectGetMidY(beginFrame))]];
    [dismissPostionAnimation setToValue:[NSValue valueWithCGPoint:CGPointMake(CGRectGetMidX(endFrame), CGRectGetMidY(endFrame))]];
    
    CABasicAnimation *dismissBoundsAnimation = [CABasicAnimation animationWithKeyPath:@"bounds"];
    [dismissBoundsAnimation setFromValue:[NSValue valueWithCGSize:beginFrame.size]];
    [dismissBoundsAnimation setToValue:[NSValue valueWithCGSize:endFrame.size]];
    
    CAAnimationGroup *dismissGroup = [CAAnimationGroup animation];
    dismissGroup.animations = @[dismissPostionAnimation,dismissBoundsAnimation];
    dismissGroup.delegate = self;
    [dismissGroup setFillMode:kCAFillModeBoth];
    [dismissGroup setRemovedOnCompletion:YES];
    dismissGroup.duration = animationDuration;
    [dismissGroup setTimingFunction:animationTimingFuction];
    [dismissGroup setValue:LDCPPopupViewDismissAnimationValue forKeyPath:LDCPPopupViewDismissAnimationKey];
    [self.layer addAnimation:dismissGroup forKey:LDCPPopupViewDismissAnimationKey];
    
    
    CABasicAnimation *dismissAlphaAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    [dismissAlphaAnimation setFillMode:kCAFillModeBoth];
    [dismissAlphaAnimation setRemovedOnCompletion:YES];
    dismissAlphaAnimation.duration = animationDuration;
    [dismissAlphaAnimation setFromValue:@(1)];
    [dismissAlphaAnimation setToValue:@(0)];
    [self.shadowView.layer addAnimation:dismissAlphaAnimation forKey:@"dissmissAlphaAnimation"];
}
/*
- (void)animateRemoveSubview:(nonnull UIView *)view
                 endPosition:(LDCPAnimationVerticalPositionType)endPosition
                    duration:(CFTimeInterval)duration
               timingFuction:(nullable CAMediaTimingFunction *)timingFuction
                  completion:(void (^ __nullable)(BOOL finished))completion
{
    CGRect animateEndFrame = [self animateSubview:view postionType:endPosition];
    
    [self animateRemoveSubview:view
                      endFrame:animateEndFrame
                      duration:duration
                 timingFuction:timingFuction
                    completion:completion];
}

- (void)animateRemoveSubview:(nonnull UIView *)view
                    endFrame:(CGRect)endFrame
                    duration:(CFTimeInterval)duration
               timingFuction:(nullable CAMediaTimingFunction *)timingFuction
                  completion:(void (^ __nullable)(BOOL finished))completion
{
    self.dismissAnimateFinishedBlock = completion;
    self.animateSubview = view;
    
    CGRect beginFrame = view.frame;
    //加速划出的动画
    view.frame = endFrame;
    self.shadowView.alpha = 0;
    
    CFTimeInterval animationDuration = duration;
    if (animationDuration <= 0) {
        animationDuration = LDCPPopupViewAnimateDismissDuration;
    }
    CAMediaTimingFunction *animationTimingFuction = timingFuction;
    if (animationTimingFuction == nil) {
        animationTimingFuction = [[CAMediaTimingFunction alloc] initWithControlPoints:0.4f :0.0f :1.0f :1.0f];
    }
    
    //判断view的初始位置是否在self内
    if ([self isTheFrameInside:endFrame]) {
        CABasicAnimation *viewAlphaAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
        [viewAlphaAnimation setFillMode:kCAFillModeBoth];
        [viewAlphaAnimation setRemovedOnCompletion:YES];
        viewAlphaAnimation.duration = animationDuration;
        [viewAlphaAnimation setFromValue:@(1)];
        [viewAlphaAnimation setToValue:@(0)];
        [view.layer addAnimation:viewAlphaAnimation forKey:@"dismissViewAlphaAnimation"];
    }
    
    CABasicAnimation *dismissPostionAnimation = [CABasicAnimation animationWithKeyPath:@"position"];
    [dismissPostionAnimation setFromValue:[NSValue valueWithCGPoint:CGPointMake(CGRectGetMidX(beginFrame), CGRectGetMidY(beginFrame))]];
    [dismissPostionAnimation setToValue:[NSValue valueWithCGPoint:CGPointMake(CGRectGetMidX(endFrame), CGRectGetMidY(endFrame))]];
    
    CABasicAnimation *dismissBoundsAnimation = [CABasicAnimation animationWithKeyPath:@"bounds"];
    [dismissBoundsAnimation setFromValue:[NSValue valueWithCGSize:beginFrame.size]];
    [dismissBoundsAnimation setToValue:[NSValue valueWithCGSize:endFrame.size]];
    
    CAAnimationGroup *dismissGroup = [CAAnimationGroup animation];
    dismissGroup.animations = @[dismissPostionAnimation,dismissBoundsAnimation];
    dismissGroup.delegate = self;
    [dismissGroup setFillMode:kCAFillModeBoth];
    [dismissGroup setRemovedOnCompletion:YES];
    dismissGroup.duration = animationDuration;
    [dismissGroup setTimingFunction:animationTimingFuction];
    [dismissGroup setValue:LDCPPopupViewDismissAnimationValue forKeyPath:LDCPPopupViewDismissAnimationKey];
    [view.layer addAnimation:dismissGroup forKey:LDCPPopupViewDismissAnimationKey];
    
    
    CABasicAnimation *dismissAlphaAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    [dismissAlphaAnimation setFillMode:kCAFillModeBoth];
    [dismissAlphaAnimation setRemovedOnCompletion:YES];
    dismissAlphaAnimation.duration = animationDuration;
    [dismissAlphaAnimation setFromValue:@(1)];
    [dismissAlphaAnimation setToValue:@(0)];
    [self.shadowView.layer addAnimation:dismissAlphaAnimation forKey:@"dissmissAlphaAnimation"];
}*/

#pragma mark - setter and getter

- (void)setShowAnimateFinishedBlock:(LDCPPopupViewAnimateFinished)showAnimateFinishedBlock
{
    objc_setAssociatedObject(self, @"showAnimateFinishedBlock", showAnimateFinishedBlock, OBJC_ASSOCIATION_COPY);
}

- (LDCPPopupViewAnimateFinished)showAnimateFinishedBlock
{
    return objc_getAssociatedObject(self, @"showAnimateFinishedBlock");
}

- (void)setDismissAnimateFinishedBlock:(LDCPPopupViewAnimateFinished)dismissAnimateFinishedBlock
{
    objc_setAssociatedObject(self, @"dismissAnimateFinishedBlock", dismissAnimateFinishedBlock, OBJC_ASSOCIATION_COPY);
}

- (LDCPPopupViewAnimateFinished)dismissAnimateFinishedBlock
{
    return objc_getAssociatedObject(self, @"dismissAnimateFinishedBlock");
}

- (void)setAnimateSubview:(UIView *)animateSubview
{
    objc_setAssociatedObject(self, @"animateSubview", animateSubview, OBJC_ASSOCIATION_RETAIN);
}

- (UIView *)animateSubview
{
    return objc_getAssociatedObject(self, @"animateSubview");
}

- (void)setShadowResponseBlock:(LDCPPopupViewShadowResponse)shadowResponseBlock
{
    objc_setAssociatedObject(self.animateSubview, @"popupShadowResponseBlock", shadowResponseBlock, OBJC_ASSOCIATION_COPY);
}

- (LDCPPopupViewShadowResponse)shadowResponseBlock
{
    return objc_getAssociatedObject(self.animateSubview, @"popupShadowResponseBlock");
}

- (void)setShadowView:(UIView *)shadowView
{
    objc_setAssociatedObject(self.animateSubview, @"popupShadowView", shadowView, OBJC_ASSOCIATION_RETAIN);
}

- (UIView *)shadowView
{
    if (objc_getAssociatedObject(self.animateSubview, @"popupShadowView")) {
        return objc_getAssociatedObject(self.animateSubview, @"popupShadowView");
    } else {
        UIView *shadowView = [[UIView alloc] initWithFrame:self.bounds];
        shadowView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        shadowView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.25];
        shadowView.alpha = 0;
        
        UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(shadowViewResponse:)];
        recognizer.numberOfTapsRequired = 1;
        [shadowView addGestureRecognizer:recognizer];
        
        self.shadowView = shadowView;
        return shadowView;
    }
    
}

#pragma mark - animation delegate
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    if ([[anim valueForKey:LDCPPopupViewShowAnimationKey] isEqualToString:LDCPPopupViewShowAnimationValue]) {
        //展示动画结束后
        if (self.showAnimateFinishedBlock) {
            self.showAnimateFinishedBlock(flag);
            self.showAnimateFinishedBlock = nil;
        }
    } else if ([[anim valueForKey:LDCPPopupViewDismissAnimationKey] isEqualToString:LDCPPopupViewDismissAnimationValue]) {
        //消失动画结束后
        //view remove
        [self.shadowView removeFromSuperview];
        self.superview.animateSubview = nil;
        [self removeFromSuperview];
        if (self.dismissAnimateFinishedBlock) {
            self.dismissAnimateFinishedBlock(flag);
            self.dismissAnimateFinishedBlock = nil;
        }
    }
}

#pragma mark - private method

- (CGRect)animateSubview:(UIView *)subview postionType:(LDCPAnimationVerticalPositionType)type {
    CGRect frame = CGRectZero;
    
    switch (type) {
        case LDCPAnimationVerticalPositionTypeTop:
            frame = CGRectMake((CGRectGetWidth(self.bounds) - CGRectGetWidth(subview.bounds)) / 2, 0, CGRectGetWidth(subview.bounds), CGRectGetHeight(subview.bounds));
            break;
            
        case LDCPAnimationVerticalPositionTypeTopUpperPlace:
            frame = CGRectMake((CGRectGetWidth(self.bounds) - CGRectGetWidth(subview.bounds)) / 2, - CGRectGetHeight(subview.bounds) - LDCPPopupViewAnimateBufferSpace, CGRectGetWidth(subview.bounds), CGRectGetHeight(subview.bounds));
            break;
            
        case LDCPAnimationVerticalPositionTypeMiddle:
            frame = CGRectMake((CGRectGetWidth(self.bounds) - CGRectGetWidth(subview.bounds)) / 2, (CGRectGetHeight(self.bounds) - CGRectGetHeight(subview.bounds)) / 2, CGRectGetWidth(subview.bounds), CGRectGetHeight(subview.bounds));
            break;
            
        case LDCPAnimationVerticalPositionTypeMiddleUpperPlace:
            frame = CGRectMake((CGRectGetWidth(self.bounds) - CGRectGetWidth(subview.bounds)) / 2, (CGRectGetHeight(self.bounds) - CGRectGetHeight(subview.bounds)) / 2 - 100, CGRectGetWidth(subview.bounds), CGRectGetHeight(subview.bounds));
            break;
            
        case LDCPAnimationVerticalPositionTypeMiddleLowerPlace:
            frame = CGRectMake((CGRectGetWidth(self.bounds) - CGRectGetWidth(subview.bounds)) / 2, (CGRectGetHeight(self.bounds) - CGRectGetHeight(subview.bounds)) / 2 + 100, CGRectGetWidth(subview.bounds), CGRectGetHeight(subview.bounds));
            break;
            
        case LDCPAnimationVerticalPositionTypeBottom:
            frame = CGRectMake((CGRectGetWidth(self.bounds) - CGRectGetWidth(subview.bounds)) / 2, CGRectGetHeight(self.bounds) - CGRectGetHeight(subview.bounds), CGRectGetWidth(subview.bounds), CGRectGetHeight(subview.bounds));
            break;
           
        case LDCPAnimationVerticalPositionTypeBottomLowerPlace:
            frame = CGRectMake((CGRectGetWidth(self.bounds) - CGRectGetWidth(subview.bounds)) / 2, CGRectGetHeight(self.bounds) + LDCPPopupViewAnimateBufferSpace, CGRectGetWidth(subview.bounds), CGRectGetHeight(subview.bounds));
            break;
            
        default:
            break;
    }
    
    return frame;
}

- (void)shadowViewResponse:(UITapGestureRecognizer *)recognizer
{
    if (self.shadowResponseBlock) {
        self.shadowResponseBlock();
    }
}

- (BOOL)isTheFrameInside:(CGRect)rect
{
    return CGRectIntersectsRect(rect, self.bounds);
}

@end
