//
//  UIAlertView+MKBlockAdditions.h
//  UIKitCategoryAdditions
//
//  Created by Mugunth on 21/03/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MKBlockAdditions.h"

@interface UIAlertView (Block) <UIAlertViewDelegate>

/**
 *  创建带有标题和消息的AlertView。创建后自动显示，不用再调用[alert show]。
 *
 *  @param title   标题
 *  @param message 消息
 */
+ (void)alertViewWithTitle:(nullable NSString *)title
                   message:(nullable NSString *)message;

/**
 *  创建带有标题、消息、取消键的AlertView。创建后自动显示，不用再调用[alert show]。
 *
 *  @param title             标题
 *  @param message           消息
 *  @param cancelButtonTitle 取消键的标题
 */
+ (void)alertViewWithTitle:(nullable NSString *)title
                   message:(nullable NSString *)message
         cancelButtonTitle:(nullable NSString *)cancelButtonTitle;

/**
 *  创建带有标题、消息、取消键、其他自定义键的AlertView。键的点击事件通过回调block的形式定义。创建后自动显示，不用再调用[alert show]。
 *
 *  @param title             标题
 *  @param message           消息
 *  @param cancelButtonTitle 取消键的标题
 *  @param otherButtons      其他自定义键的标题数组
 *  @param dismissed         其他自定义键的点击事件回调block
 *  @param cancelled         取消键的点击事件回调block
 *
 *  @attention 若同一时间连续调用显示多个AlertView，在8.0以下的Device上，AlertView将按调用顺序的倒序，从后往前依次显示。在8.0以上的设备上，不允许同时显示多个AlertView，只有第一个调用的可以正常显示，后面的AlertView会被丢弃，并有log报错：“WARNING: you could NOT synchronously present multiple alert on the same view controller.”
 */
+ (void)alertViewWithTitle:(nullable NSString *)title
                   message:(nullable NSString *)message
         cancelButtonTitle:(nullable NSString *)cancelButtonTitle
         otherButtonTitles:(nullable NSArray<NSString *> *)otherButtons
                 onDismiss:(nullable DismissBlock)dismissed
                  onCancel:(nullable CancelBlock)cancelled;

@end

