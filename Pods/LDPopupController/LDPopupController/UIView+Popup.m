//
//  UIView+Popup.m
//  LDPopupController
//
//  Created by zhangxuming on 16/4/25.
//  Copyright © 2016年 zhangxuming. All rights reserved.
//

#import "UIView+Popup.h"
#import "LDPopupItem.h"
#import "LDPopupController.h"

@implementation UIView (Popup)

- (void)displayPopup
{
    [self displayPopupWithLevel:PopupLevelNormal interval:defaultPopupInterval completion:nil];
}

- (void)displayPopupWithLevel:(PopupLevel)level
{
    [self displayPopupWithLevel:level interval:defaultPopupInterval completion:nil];
}

- (void)displayPopupWithLevel:(PopupLevel)level completion:(PopupCompletionBlock)completion
{
    [self displayPopupWithLevel:level interval:defaultPopupInterval completion:completion];
}

- (void)displayPopupWithLevel:(PopupLevel)level
                     interval:(NSTimeInterval)interval
                   completion:(PopupCompletionBlock)completion
{
    [self displayPopupWithLevel:level priority:LDPopupPriorityNormal interval:interval completion:completion];
}

- (void)displayPopupWithLevel:(PopupLevel)level
                     priority:(LDPopupPriority)priority
                     interval:(NSTimeInterval)interval
                   completion:(nullable PopupCompletionBlock)completion
{
    if (!self.popupItem) {
        LDPopupItem *item = [LDPopupItem itemWithPopupView:self popupLevel:level priority:priority
                                                  interval:interval completion:completion];
        self.popupItem = item;
        [[LDPopupController sharedController] displayPopup:self.popupItem];
    }
}

- (void)displayPopupWithPriority:(LDPopupPriority)priority
{
    [self displayPopupWithLevel:PopupLevelNormal priority:priority
                       interval:defaultPopupInterval completion:nil];
}

- (void)displayPopupWithPriority:(LDPopupPriority)priority completion:(PopupCompletionBlock)completion
{
    [self displayPopupWithLevel:PopupLevelNormal priority:priority
                       interval:defaultPopupInterval completion:completion];
}

- (void)dismissPopup
{
    [[LDPopupController sharedController] dismissPopup:self.popupItem];
}

@end
