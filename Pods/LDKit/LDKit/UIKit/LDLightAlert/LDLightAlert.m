//
//  LDLightAlert.m
//  LDKit
//
//  Created by Anchor on 17/3/1.
//  Copyright © 2017年 netease. All rights reserved.
//

#import "LDLightAlert.h"
#import "NSTimer+LDBreakRetainLoop.h"

@interface LDLightAlert ()

@property (nonatomic, strong) UILabel *msgLabel;
@property (nonatomic, strong) UIImageView *hudView;
@property (nonatomic, strong) UIWindow *overlayWindow;

@property (nonatomic, assign) BOOL repeatFlag;
@property (nonatomic, assign) CGPoint hudCenter;
@property (nonatomic, assign) CGFloat hudAngle;

@end

@implementation LDLightAlert

+ (instancetype)sharedAlert
{
    static LDLightAlert *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[LDLightAlert alloc] initWithFrame:[UIScreen mainScreen].bounds];
    });
    return instance;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.alpha = 0.0;
        _repeatFlag = NO;
        self.backgroundColor = [UIColor clearColor];
        self.userInteractionEnabled = NO;
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth |
                                UIViewAutoresizingFlexibleHeight;
    }
    return self;
}


#pragma mark - Public Interface

+ (void)ld_showMsg:(NSString *)msg duration:(NSTimeInterval)duration
{
    [[LDLightAlert sharedAlert] ld_showMsg:msg duration:duration];
}

+ (void)ld_showMsg:(NSString *)msg
          duration:(NSTimeInterval)duration
             point:(CGPoint)point
{
    [[LDLightAlert sharedAlert] ld_showMsg:msg
                                  duration:duration
                                     point:point];
}

+ (void)ld_showMsg:(NSString *)msg
          duration:(NSTimeInterval)duration
            inView:(UIView *)superView
{
    [[LDLightAlert sharedAlert] ld_showMsg:msg
                                  duration:duration
                                    inView:superView];
}

+ (void)ld_showMsg:(NSString *)msg
          duration:(NSTimeInterval)duration
             point:(CGPoint)point
            inView:(UIView *)superView
{
    [[LDLightAlert sharedAlert] ld_showMsg:msg duration:duration
                                     point:point inView:superView];
}

- (void)ld_showMsg:(NSString *)msg duration:(NSTimeInterval)duration
{
    self.overlayWindow.hidden = NO;
    [self calculateHudParamsWithSuperView:self.overlayWindow];
    [self ld_showMsg:msg inView:self.overlayWindow duration:duration
            location:self.hudCenter rotateAngle:self.hudAngle];
}

- (void)ld_showMsg:(NSString *)msg
          duration:(NSTimeInterval)duration
             point:(CGPoint)point
{
    self.overlayWindow.hidden = NO;
    [self calculateHudParamsWithSuperView:self.overlayWindow];
    [self ld_showMsg:msg inView:self.overlayWindow
            duration:duration location:point rotateAngle:self.hudAngle];
}

- (void)ld_showMsg:(NSString *)msg
          duration:(NSTimeInterval)duration
            inView:(UIView *)superView
{
    [self calculateHudParamsWithSuperView:superView];
    [self ld_showMsg:msg inView:superView duration:duration
            location:self.hudCenter rotateAngle:self.hudAngle];
}

- (void)ld_showMsg:(NSString *)msg
          duration:(NSTimeInterval)duration
             point:(CGPoint)point
            inView:(UIView *)superView
{
    [self calculateHudParamsWithSuperView:superView];
    [self ld_showMsg:msg inView:superView duration:duration
            location:point rotateAngle:self.hudAngle];
}


#pragma mark - Core Handler
/**
 此处未添加连续调用保护 意义不大 现象是瞬间连续调用会都走0.0 == self.alpha分支
 产生多个NSTimer触发的dismiss调用 后续再调用时进0.0 != self.alpha分支repeatFlag只能
 取消掉一个dismiss效果 就可能造成后续调用Alert显示时间和预期的不一致
 若要添加保护 则再加个isShowing的BOOL标识即可
 */
- (void)ld_showMsg:(NSString *)msg
            inView:(UIView *)superView
          duration:(NSTimeInterval)duration
          location:(CGPoint)center
       rotateAngle:(CGFloat)rotateAngle
{
    if (0.0 == self.alpha) {
        dispatch_async(dispatch_get_main_queue(), ^{
        [self removeFromSuperview];
        [superView addSubview:self];
        [self layoutLabelWithMsg:msg];
        [self moveHudToCenter:center rotateAngle:rotateAngle];
        [NSTimer ld_scheduledTimerWithTimeInterval:duration repeats:NO
                                             block:^{[self dismiss];}];
        self.hudView.transform = CGAffineTransformScale(self.hudView.transform, 1.3, 1.3);
        UIViewAnimationOptions options =
        UIViewAnimationCurveEaseOut |
        UIViewAnimationOptionAllowUserInteraction |
        UIViewAnimationOptionBeginFromCurrentState;
        [UIView
         animateWithDuration:0.15 delay:0.0 options:options
         animations:^{
             self.alpha = 1.0;
             self.hudView.transform = CGAffineTransformScale(self.hudView.transform, 1 / 1.3, 1 / 1.3);
         } completion:NULL];
        [self setNeedsDisplay];
        });
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
        [self layoutLabelWithMsg:msg];
        [self moveHudToCenter:center rotateAngle:rotateAngle];
        self.repeatFlag = YES;
        [NSTimer ld_scheduledTimerWithTimeInterval:duration repeats:NO
                                             block:^{[self dismiss];}];
        });
    }
}

- (void)dismiss
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.repeatFlag) {
            self.repeatFlag = NO;
            return;
        }
        UIViewAnimationOptions options =
        UIViewAnimationCurveEaseIn |
        UIViewAnimationOptionAllowUserInteraction;
        [UIView
         animateWithDuration:0.15 delay:0.0 options:options
         animations:^{
             self.alpha = 0.0;
             self.hudView.transform = CGAffineTransformScale(self.hudView.transform, 0.8, 0.8);
         } completion:^(BOOL finished) {
             [self.hudView removeFromSuperview];
             self.overlayWindow.hidden = YES;
             self.hudView = nil;
             self.overlayWindow = nil;
         }];
    });
}


#pragma Helper Method

- (void)layoutLabelWithMsg:(NSString *)msg
{
    CGFloat hudWidth = 100.0, hudHeight = 0.0;
    CGFloat msgWidth = 0.0, msgHeight = 0.0;
    CGRect msgLabelRect = CGRectZero;
    
    if (msg.length > 0) {
        NSStringDrawingOptions options =
        NSStringDrawingUsesFontLeading |NSStringDrawingUsesLineFragmentOrigin;
        CGSize msgSize =
        [msg boundingRectWithSize:CGSizeMake(300.0, 300.0)
                          options:options
                       attributes:@{NSFontAttributeName : self.msgLabel.font}
                          context:nil].size;
        msgWidth  = msgSize.width;
        msgHeight = msgSize.height;
        hudHeight = msgHeight + 40.0;
        
        if (msgWidth > hudWidth) hudWidth = ceilf(msgWidth / 2.0) * 2.0;
        
        if (hudHeight > 100.0) {
            msgLabelRect = CGRectMake(12.0, 20.0, hudWidth, msgHeight);
        } else {
            msgLabelRect = CGRectMake(0.0, 20.0, hudWidth + 24.0, msgHeight);
        }
        hudWidth += 24.0;
    }
    
    self.hudView.bounds = CGRectMake(0.0, 0.0, hudWidth, hudHeight);
    self.msgLabel.text = msg;
    self.msgLabel.frame = msgLabelRect;
}

- (void)calculateHudParamsWithSuperView:(UIView *)superView
{
    CGRect orienBounds = [UIScreen mainScreen].bounds;
    CGFloat posX = orienBounds.size.width / 2.0;
    CGFloat posY = floorf(orienBounds.size.height * 0.5);
    self.hudCenter = CGPointMake(posX, posY);
    self.hudAngle = 0.0;
    
    BOOL shouldTransform =
    [superView isKindOfClass:[UIWindow class]] &&
    ![(UIWindow *)superView rootViewController];
    UIInterfaceOrientation orien = [[UIApplication sharedApplication] statusBarOrientation];
    if (shouldTransform) {
        // 直接加在UIWindow上时 需要自己处理旋转
        switch (orien) {
            case UIInterfaceOrientationPortraitUpsideDown:
                self.hudAngle = M_PI;
                self.hudCenter = CGPointMake(posX, orienBounds.size.height - posY);
                break;
            case UIInterfaceOrientationLandscapeLeft:
                self.hudAngle = -M_PI_2;
                self.hudCenter = CGPointMake(posY, posX);
                break;
            case UIInterfaceOrientationLandscapeRight:
                self.hudAngle = M_PI_2;
                self.hudCenter = CGPointMake(orienBounds.size.height - posY, posX);
                break;
            default: // as UIInterfaceOrientationPortrait
                self.hudAngle = 0.0;
                self.hudCenter = CGPointMake(posX, posY);
                break;
        }
    }
}

- (void)moveHudToCenter:(CGPoint)center rotateAngle:(CGFloat)angle
{
    self.hudView.center = center;
    self.hudView.transform = CGAffineTransformMakeRotation(angle);
}

#pragma mark - Getter

- (UILabel *)msgLabel
{
    if (!_msgLabel) {
        _msgLabel = [UILabel new];
        _msgLabel.numberOfLines = 0;
        _msgLabel.textColor = [UIColor whiteColor];
        _msgLabel.textAlignment = NSTextAlignmentCenter;
        _msgLabel.backgroundColor = [UIColor clearColor];
        _msgLabel.font = [UIFont boldSystemFontOfSize:16.0];
        _msgLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
    }
    if (!_msgLabel.superview) [self.hudView addSubview:_msgLabel];
    return _msgLabel;
}

- (UIImageView *)hudView
{
    if (!_hudView) {
        _hudView = [UIImageView new];
        // 背景图边框不拉伸 注意此图不能用imageOptim压缩 有损/无损压过后半透边框会消失
        UIImage *alertBg = [[UIImage imageNamed:@"LightAlertBg"]
                            resizableImageWithCapInsets:UIEdgeInsetsMake(5.0, 5.0, 5.0, 5.0)
                            resizingMode:UIImageResizingModeStretch];
        _hudView.image = alertBg;
        _hudView.autoresizingMask =
        UIViewAutoresizingFlexibleTopMargin |
        UIViewAutoresizingFlexibleLeftMargin |
        UIViewAutoresizingFlexibleRightMargin |
        UIViewAutoresizingFlexibleBottomMargin;
        [self addSubview:_hudView];
    }
    return _hudView;
}

- (UIWindow *)overlayWindow
{
    if (!_overlayWindow) {
        _overlayWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _overlayWindow.userInteractionEnabled = NO;
        _overlayWindow.windowLevel = UIWindowLevelAlert;
        _overlayWindow.backgroundColor = [UIColor clearColor];
        _overlayWindow.autoresizingMask = UIViewAutoresizingFlexibleWidth |
                                          UIViewAutoresizingFlexibleHeight;
    }
    return _overlayWindow;
}

@end
