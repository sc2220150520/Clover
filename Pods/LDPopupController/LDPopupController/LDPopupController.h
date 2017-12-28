//
//  LDPopupController.h
//  LDPopupController
//
//  Created by zhangxuming on 16/4/25.
//  Copyright © 2016年 zhangxuming. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class LDPopupItem;
@interface LDPopupController : NSObject

@property (nonatomic, assign, readonly, getter=isPopupShowing) BOOL popupShowingFlag;

// Set 'YES' to print logs for debug.
@property (nonatomic, assign) BOOL logsSwitch;

+ (LDPopupController *)sharedController;

- (void)displayPopup:(LDPopupItem *)popupItem;
- (void)dismissPopup:(LDPopupItem *)popupItem;

/**
 Dismiss the showing poppup.
 If no popup is showing, this method does nothing.
 
 @warning Generally, you must not call this method to dismiss the showing popup.
 The showing popup may have some clean operation when close, this method may make these operation undo.
 */
- (void)dismissShowingPopup;

/**
 The information of showing Popup, use LDPopupInfoClassNameKey LDPopupInfoMermoryAddressKey
 to get the details.
 
 @warning Please don't close the showing popup throw the popup instance which get from these info.
 */
- (nullable NSDictionary *)showingPopupInfo;

@end

NS_ASSUME_NONNULL_END