//
//  LDPopupItem.m
//  LDPopupController
//
//  Created by zhangxuming on 16/4/25.
//  Copyright © 2016年 zhangxuming. All rights reserved.
//

#import "LDPopupItem.h"
#import "UIView+Popup.h"
#import "UIViewController+Popup.h"
#import <objc/runtime.h>

@interface LDPopupItem ()

@property (nonatomic, strong) UIView *popupView;

@end

@implementation LDPopupItem

+ (instancetype)itemWithPopupView:(__kindof UIView *)popupView
                       popupLevel:(PopupLevel)popupLevel
                         priority:(LDPopupPriority)priority
                         interval:(NSTimeInterval)interval
                       completion:(PopupCompletionBlock)completion
{
    return [[LDPopupItem alloc]
            initWithPopupView:popupView popupLevel:popupLevel
            priority:priority interval:interval completion:completion];
}

+ (instancetype)itemWithPopupViewController:(__kindof UIViewController *)popupViewController
                                 popupLevel:(PopupLevel)popupLevel
                                   priority:(LDPopupPriority)priority
                                   interval:(NSTimeInterval)interval
                                 completion:(PopupCompletionBlock)completion
{
    return [[LDPopupItem alloc]
            initWithPopupViewController:popupViewController popupLevel:popupLevel
            priority:priority interval:interval completion:completion];
}

- (void)dismissImmediately
{
    if (_popupView) {
        if ([_popupView respondsToSelector:@selector(ld_dismissSelfImmediately)]){
            [_popupView performSelector:@selector(ld_dismissSelfImmediately)];
        }
    } else {
        if ([_popupViewController respondsToSelector:@selector(ld_dismissSelfImmediately)]){
            [_popupViewController performSelector:@selector(ld_dismissSelfImmediately)];
        }
    }
}

- (NSDictionary *)LDPopupInfo
{
    if (self.popupView) {
        return @{LDPopupInfoClassNameKey : NSStringFromClass([self.popupView class]),
                 LDPopupInfoMermoryAddressKey : [NSString stringWithFormat:@"%p", self.popupView]};
    } else if (self.popupViewController) {
        return @{LDPopupInfoClassNameKey : NSStringFromClass([self.popupViewController class]),
                 LDPopupInfoMermoryAddressKey : [NSString stringWithFormat:@"%p", self.popupViewController]};
    } else {
        return nil;
    }
}

- (instancetype)initWithPopupView:(__kindof UIView *)popupView
                       popupLevel:(PopupLevel)popupLevel
                         priority:(LDPopupPriority)priority
                         interval:(NSTimeInterval)interval
                       completion:(PopupCompletionBlock)completion
{
    if (self = [super init]) {
        _popupView = popupView;
        _popupLevel = popupLevel;
        _popupInterval = interval >= 0 ? interval : defaultPopupInterval;
        _popupCompletion = [completion copy];
        _popupViewController = [[UIViewController alloc] init];
        _popupViewController.view.backgroundColor = [UIColor clearColor];
        [_popupViewController.view addSubview:popupView];
        _popupLegalFlag = NO;
        if ([self isPopupLevelLegal]) {
            if ([popupView isKindOfClass:[UIView class]] && ![popupView isKindOfClass:[UIWindow class]]) {
                _popupLegalFlag = YES;
            }
        }
    }
    return self;
}

- (instancetype)initWithPopupViewController:(__kindof UIViewController *)popupViewController
                                 popupLevel:(PopupLevel)popupLevel
                                   priority:(LDPopupPriority)priority
                                   interval:(NSTimeInterval)interval
                                 completion:(PopupCompletionBlock)completion
{
    if (self = [super init]) {
        _popupViewController = popupViewController;
        _popupLevel = popupLevel;
        _priority = priority;
        _popupInterval = interval >= 0 ? interval : defaultPopupInterval;
        _popupCompletion = [completion copy];
        if ([self isPopupLevelLegal]) {
            if ([popupViewController isKindOfClass:[UIViewController class]]) {
                _popupLegalFlag = YES;
            }
        }
    }
    return self;
}

- (void)dealloc
{
    if (_popupView) {
        objc_removeAssociatedObjects(_popupView);
    } else {
        objc_removeAssociatedObjects(_popupViewController);
    }
}

- (BOOL)isPopupLevelLegal
{
    if (_popupLevel >= PopupLevelNormal && _popupLevel <= PopupLevelAlert) {
        return YES;
    } else {
        return NO;
    }
}

@end

static void *kPopupUIViewKey = "kPopupUIViewKey";
static void *kPopupUIViewControllerKey = "kPopupUIViewControllerKey";

@implementation UIView (PopupItem)

- (void)setPopupItem:(LDPopupItem *)popupItem
{
    objc_setAssociatedObject(self, kPopupUIViewKey, popupItem, OBJC_ASSOCIATION_ASSIGN);
}

- (LDPopupItem *)popupItem
{
    return  objc_getAssociatedObject(self, kPopupUIViewKey);
}

@end

@implementation UIViewController (PopupItem)

- (void)setPopupItem:(LDPopupItem *)popupItem
{
    objc_setAssociatedObject(self, kPopupUIViewControllerKey, popupItem, OBJC_ASSOCIATION_ASSIGN);
}

- (LDPopupItem *)popupItem
{
    return objc_getAssociatedObject(self, kPopupUIViewControllerKey);
}

@end
