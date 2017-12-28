//
//  LDPopupItem.h
//  LDPopupController
//
//  Created by zhangxuming on 16/4/25.
//  Copyright © 2016年 zhangxuming. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LDPopupDefine.h"

NS_ASSUME_NONNULL_BEGIN

@interface LDPopupItem : NSObject

@property (nonatomic, strong, readonly) UIViewController *popupViewController;
@property (nonatomic, assign, readonly) PopupLevel popupLevel;
@property (nonatomic, assign, readonly) LDPopupPriority priority;
@property (nonatomic, assign, readonly) NSTimeInterval popupInterval;
@property (nonatomic, assign, readonly, getter=isPopupLegal) BOOL popupLegalFlag;
@property (nonatomic, copy, readonly, nullable) PopupCompletionBlock popupCompletion;

+ (instancetype)itemWithPopupView:(__kindof UIView *)popupView
                       popupLevel:(PopupLevel)popupLevel
                         priority:(LDPopupPriority)priority
                         interval:(NSTimeInterval)interval
                       completion:(nullable PopupCompletionBlock)completion;

+ (instancetype)itemWithPopupViewController:(__kindof UIViewController *)popupViewController
                                 popupLevel:(PopupLevel)popupLevel
                                   priority:(LDPopupPriority)priority
                                   interval:(NSTimeInterval)interval
                                 completion:(nullable PopupCompletionBlock)completion;
- (void)dismissImmediately;

- (nullable NSDictionary *)LDPopupInfo;

@end

@interface UIView (PopupItem)

@property (nonatomic, weak, nullable) LDPopupItem *popupItem;

@end

@interface  UIViewController (PopupItem)

@property (nonatomic, weak, nullable) LDPopupItem *popupItem;

@end

NS_ASSUME_NONNULL_END
