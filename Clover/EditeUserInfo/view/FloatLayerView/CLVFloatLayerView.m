//
//  CLVFloatLayerView.m
//  Clover
//
//  Created by shen chen on 2018/1/4.
//  Copyright © 2018年 shenchen. All rights reserved.
//

#import "CLVFloatLayerView.h"
#import "CLVFLoatViewConstans.h"

@interface CLVFloatLayerView() <CAAnimationDelegate,UIGestureRecognizerDelegate>

@property (nonatomic, strong) UIView *shadowView;
@property (nonatomic, assign) CGFloat tableViewHeight;


@end

@implementation CLVFloatLayerView

#pragma mark - init
- (instancetype)initWithFrame:(CGRect)frame tableViewHeight:(CGFloat) tableViewHeight{
    self = [super initWithFrame:frame];
    if (self) {
        self.tableViewHeight = tableViewHeight;
        [self addSubview:self.tableView];
        self.backgroundColor = [UIColor clearColor];
        UITapGestureRecognizer * gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hide)];
        gesture.delegate = self;
        [self addGestureRecognizer:gesture];
    }
    return self;
}

#pragma mark - public Method

- (void)showInParentView:(UIView *)parentView {
    [parentView addSubview:self];
    [self addSubview:self.shadowView];
    [self bringSubviewToFront:self.tableView];
    [self.superview bringSubviewToFront:self];
    //CGFloat sheetViewCenterY = self.center.y + self.center.y/2.0; //self.center.y;
    CGFloat sheetViewCenterY = (CGRectGetHeight(self.bounds) - self.tableViewHeight) + self.tableViewHeight/2.0;
    self.shadowView.alpha = 1.0;
    CABasicAnimation *presentPostionAnimation = [CABasicAnimation animationWithKeyPath:@"position.y"];
    presentPostionAnimation.delegate = self;
    [presentPostionAnimation setFillMode:kCAFillModeBoth];
    [presentPostionAnimation setRemovedOnCompletion:YES];
    presentPostionAnimation.duration = 0.3;
    [presentPostionAnimation setTimingFunction:[[CAMediaTimingFunction alloc] initWithControlPoints:0.0f :0.0f :0.2f :1.0f]];
    [presentPostionAnimation setFromValue:@(sheetViewCenterY + CGRectGetHeight(self.bounds) + 50)];
    [presentPostionAnimation setToValue:@(sheetViewCenterY)];
    [presentPostionAnimation setValue:@"presentationAnimationValue" forKeyPath:@"presentationAnimationKey"];
    [self.tableView.layer addAnimation:presentPostionAnimation forKey:@"presentationAnimationKey"];
    
    CABasicAnimation *presentAlphaAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    [presentAlphaAnimation setFillMode:kCAFillModeBoth];
    [presentAlphaAnimation setRemovedOnCompletion:YES];
    presentAlphaAnimation.duration = 0.3;
    [presentAlphaAnimation setFromValue:@(0)];
    [presentAlphaAnimation setToValue:@(1)];
    [self.shadowView.layer addAnimation:presentAlphaAnimation forKey:@"presentAlphaAnimation"];
}

- (void)hide {
    [self.delegate onHide];
    self.shadowView.alpha = 0;
    //self.couponTableView.center = CGPointMake(self.center.x, self.center.y + self.center.y/2.0 + CGRectGetHeight(self.bounds) + 50);
    self.tableView.center = CGPointMake(self.center.x, (CGRectGetHeight(self.bounds)-self.tableViewHeight) + self.tableViewHeight/2.0 + CGRectGetHeight(self.bounds) + 50);
    CABasicAnimation *dismissPostionAnimation = [CABasicAnimation animationWithKeyPath:@"position.y"];
    dismissPostionAnimation.delegate = self;
    [dismissPostionAnimation setFillMode:kCAFillModeBoth];
    [dismissPostionAnimation setRemovedOnCompletion:YES];
    dismissPostionAnimation.duration = 0.3;
    [dismissPostionAnimation setTimingFunction:[[CAMediaTimingFunction alloc] initWithControlPoints:0.4f :0.0f :1.0f :1.0f]];
    [dismissPostionAnimation setFromValue:@(self.tableView.center.y - CGRectGetHeight(self.bounds) - 50)];
    [dismissPostionAnimation setToValue:@(self.tableView.center.y)];
    [dismissPostionAnimation setValue:@"dissmissAnimationValue" forKeyPath:@"dismissAnimationKey"];
    [self.tableView.layer addAnimation:dismissPostionAnimation forKey:@"dismissAnimationKey"];
    
    CABasicAnimation *dismissAlphaAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    [dismissAlphaAnimation setFillMode:kCAFillModeBoth];
    [dismissAlphaAnimation setRemovedOnCompletion:YES];
    dismissAlphaAnimation.duration = 0.3;
    [dismissAlphaAnimation setFromValue:@(1)];
    [dismissAlphaAnimation setToValue:@(0)];
    [self.shadowView.layer addAnimation:dismissAlphaAnimation forKey:@"dismissAlphaAnimation"];
}

#pragma mark - lazyLoad

- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.bounds)-self.tableViewHeight, CGRectGetWidth(self.frame),self.tableViewHeight) style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor ld_colorWithHex:0xf6f6f6];
        _tableView.estimatedRowHeight = 117;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.scrollEnabled = NO;
        _tableView.tableHeaderView = nil;
    }
    return _tableView;
}

- (UIView *)shadowView {
    if (_shadowView == nil) {
        _shadowView = [[UIView alloc] initWithFrame:self.bounds];
        _shadowView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        UIColor *color = [UIColor blackColor];
        _shadowView.backgroundColor = [color colorWithAlphaComponent:0.5];
        _shadowView.alpha = 1;
    }
    return _shadowView;
}

#pragma mark - animationDelegate
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    if ([[anim valueForKey:@"dismissAnimationKey"] isEqualToString:@"dissmissAnimationValue"]) {
        //dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.shadowView removeFromSuperview];
            self.shadowView = nil;
            [self removeFromSuperview];
        //});
    } else if ([[anim valueForKey:@"presentationAnimationKey"] isEqualToString:@"presentationAnimationValue"]) {
        
    }
}

#pragma mark - gestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if([touch.view isDescendantOfView:self.tableView]) {
        return NO;
    } else {
        return YES;
    }
}


@end
