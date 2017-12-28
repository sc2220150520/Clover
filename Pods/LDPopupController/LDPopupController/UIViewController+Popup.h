//
//  UIViewController+Popup.h
//  LDPopupController
//
//  Created by zhangxuming on 16/4/25.
//  Copyright © 2016年 zhangxuming. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LDPopupDefine.h"

@interface UIViewController (Popup)

- (void)displayPopup;

- (void)displayPopupWithLevel:(PopupLevel)level;

- (void)displayPopupWithLevel:(PopupLevel)level completion:(nullable PopupCompletionBlock)completion;

- (void)displayPopupWithLevel:(PopupLevel)level
                     interval:(NSTimeInterval)interval
                   completion:(nullable PopupCompletionBlock)completion;

- (void)displayPopupWithLevel:(PopupLevel)level
                     priority:(LDPopupPriority)priority
                     interval:(NSTimeInterval)interval
                   completion:(nullable PopupCompletionBlock)completion;

- (void)displayPopupWithPriority:(LDPopupPriority)priority;

- (void)displayPopupWithPriority:(LDPopupPriority)priority
                      completion:(nullable PopupCompletionBlock)completion;

- (void)dismissPopup;

@end
