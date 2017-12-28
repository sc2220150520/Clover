//
//  LDPopupDefine.h
//  LDPopupController
//
//  Created by zhangxuming on 16/4/25.
//  Copyright © 2016年 zhangxuming. All rights reserved.
//

#ifndef LDPopupDefine_h
#define LDPopupDefine_h

typedef NS_ENUM(NSInteger, PopupLevel) {
    PopupLevelNormal = 0,   // PopupWindow's windowLevel is UIWindowLevelNormal
    PopupLevelAlert  = 1,   // PopupWindow's windowLevel is UIWindowLevelAlert
};

typedef NS_ENUM(NSInteger, LDPopupErrorCode) {
    LDPopupErrorPriorityDeny = -600
};

typedef void (^PopupCompletionBlock)(UIViewController *__nonnull popupViewController, PopupLevel popupLevel, NSError *__nullable error);

typedef CGFloat LDPopupPriority;
static const LDPopupPriority LDPopupPriorityHigh   = 4000;
static const LDPopupPriority LDPopupPriorityMedium = 3000;
static const LDPopupPriority LDPopupPriorityNormal = 2000;
static const LDPopupPriority LDPopupPriorityLow    = 1000;

@protocol LDPopupLifeCycleProtocol <NSObject>

@optional

/**
 LDPopupController will invoke this method when receive a dismissShowingPopup message.
 It is recommended to implement this method with a no animation close operation.
 */
- (void)ld_dismissSelfImmediately;

@end


/**
 The Following Keys are used to get information of the showing popup.
 */
static NSString *__nonnull const LDPopupInfoClassNameKey = @"LDPopupInfoClassNameKey";
static NSString *__nonnull const LDPopupInfoMermoryAddressKey = @"LDPopupInfoMermoryAddressKey";

static const NSTimeInterval defaultPopupInterval = 0.75;

static NSString *__nonnull const LDPopupErrorDomain = @"error.ldpopup";

#endif /* LDPopupDefine_h */
