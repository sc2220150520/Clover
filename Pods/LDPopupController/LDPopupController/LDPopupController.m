//
//  LDPopupController.m
//  LDPopupController
//
//  Created by zhangxuming on 16/4/25.
//  Copyright © 2016年 zhangxuming. All rights reserved.
//

#import "LDPopupController.h"
#import "LDPopupItem.h"

@interface PopupContainerController : UIViewController
@end

@implementation PopupContainerController

/* Autorotata may cause status bar confused.*/
- (BOOL)shouldAutorotate
{
    return NO;
}

@end


@interface LDPopupController ()

@property (nonatomic, strong) LDPopupItem *foremostPopup;
@property (nonatomic, strong) NSMutableArray<LDPopupItem *> *popups;

@property (nonatomic, strong) PopupContainerController *containerViewController;
@property (nonatomic, strong) UIWindow *popupBasedWindow;

@end

@implementation LDPopupController

+ (LDPopupController *)sharedController
{
    static LDPopupController *popupController;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        popupController = [[LDPopupController alloc] init];
    });
    return popupController;
}

#pragma mark - 初始化
- (instancetype)init
{
    if (self = [super init])
    {
        //处理问题：刚进入应用时，由于系统横纵屏切换导致页面size不对问题；
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(windowBecomKey:)
                                                     name:UIWindowDidBecomeKeyNotification
                                                   object:nil];
    }
    return self;
}
    
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIWindowDidBecomeKeyNotification object:nil];
}
    
#pragma mark - 通知
- (void)windowBecomKey:(NSNotification *)notification
{
    self.popupBasedWindow.frame = [((UIWindow*)notification.object) bounds];
}

#pragma mark - Public Methods

- (void)displayPopup:(LDPopupItem *)popupItem
{
    if (popupItem.isPopupLegal) {
        [self addPopup:popupItem];
        if (_popups.count == 1) {
            self.foremostPopup = _popups[0];
            [self showForemostPopup];
        }
    } else {
        if (_logsSwitch) {
            NSLog(@"LDPopupController Error:%s %d: Illegal popup.", __func__, __LINE__);
        }
    }
}

- (void)dismissPopup:(LDPopupItem *)popupItem
{
    if (self.isPopupShowing) {
        if (popupItem.popupViewController) {
            [self dismissViewController:popupItem.popupViewController];
        }
    } else {
        if (_logsSwitch) {
            NSLog(@"LDPopupController Tips:%s %d: There is no popup showing.", __func__, __LINE__);
        }
    }
}

- (void)dismissShowingPopup
{
    if (self.isPopupShowing) {
        if (self.containerViewController.presentedViewController) {
            [self.containerViewController dismissViewControllerAnimated:NO completion:^{
                [_foremostPopup dismissImmediately];
            }];
        } else {
            [_foremostPopup dismissImmediately];
        }
    }
}

- (nullable NSDictionary *)showingPopupInfo
{
    if (self.isPopupShowing) {
        return [_foremostPopup LDPopupInfo];
    } else {
        return nil;
    }
}


#pragma mark - Private Methods

- (void)addPopup:(LDPopupItem *)newPopup
{
    if (!_popups) {
        self.popups = [NSMutableArray array];
    }
    
    if (self.foremostPopup) {
        if (newPopup.priority >= self.foremostPopup.priority) {
            [self.popups addObject:newPopup];
        } else {
            if (newPopup.popupCompletion) {
                NSError *error = [[NSError alloc]
                                  initWithDomain:LDPopupErrorDomain code:LDPopupErrorPriorityDeny
                                  userInfo:@{NSLocalizedDescriptionKey : @"A high priority is showing now."}];
                newPopup.popupCompletion(newPopup.popupViewController, newPopup.popupLevel, error);
            }
            if (_logsSwitch) {
                NSLog(@"LDPopupController Tips:%s %d: A low priority popup has been ignored.", __func__, __LINE__);
            }
        }
    } else {
        [self.popups addObject:newPopup];
    }
}

- (BOOL)showForemostPopup
{
    if (self.isPopupShowing) {
        return NO;
    }

    // There is no need to check _foremostPopup == nil here.
    if (_foremostPopup.popupViewController) {
        [self.containerViewController addChildViewController:_foremostPopup.popupViewController];
        [self.containerViewController.view addSubview:_foremostPopup.popupViewController.view];
        [self.foremostPopup.popupViewController didMoveToParentViewController:_containerViewController];
        [self.popupBasedWindow makeKeyAndVisible];
        
        if (_foremostPopup.popupCompletion) {
            _foremostPopup.popupCompletion(_foremostPopup.popupViewController, _foremostPopup.popupLevel, nil);
        }
        return YES;
    } else {
        return NO;
    }
}

- (void)dismissViewController:(__kindof UIViewController *)viewController
{
    if (viewController == _foremostPopup.popupViewController && _popups.count > 0) {
        [self.foremostPopup.popupViewController willMoveToParentViewController:nil];
        [self.foremostPopup.popupViewController.view removeFromSuperview];
        [self.foremostPopup.popupViewController removeFromParentViewController];
        [self clean];
        
        if (_foremostPopup) {
            NSTimeInterval interval = _foremostPopup.popupInterval;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(interval * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self showForemostPopup];
            });
        }
    }
}

- (void)clean
{
    self.popupBasedWindow.hidden = YES;
    self.containerViewController = nil;
    self.popupBasedWindow = nil;
    [self deleteForemostPopupItem];
}

- (void)deleteForemostPopupItem
{
    if (_popups.count > 0) {
        if (_popups.count == 1) {
            self.foremostPopup = nil;
        } else {
            self.foremostPopup = _popups[1];
        }
        [self.popups removeObjectAtIndex:0];
    }
}


#pragma mark - Getter

- (BOOL)isPopupShowing
{
    if (_popupBasedWindow) {
        return !_popupBasedWindow.hidden;
    } else {
        return NO;
    }
}

- (PopupContainerController *)containerViewController
{
    if (!_containerViewController) {
        _containerViewController = [[PopupContainerController alloc] init];
        _containerViewController.view.backgroundColor = [UIColor clearColor];
    }
    return _containerViewController;
}

- (UIWindow *)popupBasedWindow
{
    if (!_popupBasedWindow) {
        _popupBasedWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _popupBasedWindow.tintColor = [UIColor whiteColor];
        _popupBasedWindow.backgroundColor = [UIColor clearColor];
        if (_foremostPopup.popupLevel == PopupLevelAlert) {
            _popupBasedWindow.windowLevel = UIWindowLevelAlert;
        } else {
            _popupBasedWindow.windowLevel = UIWindowLevelNormal;
        }
        [_popupBasedWindow setRootViewController:self.containerViewController];
    }
    return _popupBasedWindow;
}

@end
