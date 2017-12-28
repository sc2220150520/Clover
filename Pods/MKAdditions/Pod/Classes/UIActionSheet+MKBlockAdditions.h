//
//  UIActionSheet+MKBlockAdditions.h
//  UIKitCategoryAdditions
//
//  Created by Mugunth on 21/03/11.
//  Copyright 2011 Steinlogic All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MKBlockAdditions.h"

NS_ASSUME_NONNULL_BEGIN
@interface UIActionSheet (MKBlockAdditions) <UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

/**
 *  创建带有标题、消息、取消键、其他自定义键的ActionSheet。键的点击事件通过回调block的形式定义。创建后自动显示，不用再调用[actionSheet show]。
 *
 *  @param title        标题
 *  @param message      消息
 *  @param buttonTitles 其他自定义键标题数组
 *  @param view         actionSheet展示所在的view
 *  @param dismissed    其他自定义键的点击事件回调block
 *  @param cancelled    取消键的点击事件回调block
 */
+ (void)actionSheetWithTitle:(nullable NSString *)title
                     message:(nullable NSString *)message
                     buttons:(nullable NSArray<NSString *> *)buttonTitles
                  showInView:(UIView *)view
                   onDismiss:(nullable DismissBlock)dismissed
                    onCancel:(nullable CancelBlock)cancelled;

/**
 *  创建带有标题、消息、取消键、破坏性键、其他自定义键的ActionSheet。键的点击事件通过回调block的形式定义。创建后自动显示，不用再调用[actionSheet show]。
 *
 *  @param title                  标题
 *  @param message                消息
 *  @param destructiveButtonTitle 破坏性键标题
 *  @param buttonTitles           其他自定义键标题数组
 *  @param view                   actionSheet展示所在的view
 *  @param dismissed              其他自定义键的点击事件回调block
 *  @param cancelled              取消键的点击事件回调block
 */
+ (void)actionSheetWithTitle:(nullable NSString *)title
                     message:(nullable NSString *)message
      destructiveButtonTitle:(nullable NSString *)destructiveButtonTitle
                     buttons:(nullable NSArray<NSString *> *)buttonTitles
                  showInView:(UIView *)view
                   onDismiss:(nullable DismissBlock)dismissed
                    onCancel:(nullable CancelBlock)cancelled;


/**
 *  创建用于从相机拍照或从相册选择图片的ActionSheet。键的点击事件通过回调block的形式定义。创建后自动显示，不用再调用[actionSheet show]。
 *
 *  @param title       标题
 *  @param view        actionSheet展示所在的view
 *  @param presentVC actionSheet展示所在的view controller
 *  @param photoPicked 选择所用照片后的回调block
 *  @param cancelled   取消键的点击事件回调block
 */
+ (void)photoPickerWithTitle:(NSString *)title
                  showInView:(UIView *)view
                   presentVC:(UIViewController *)presentVC
               onPhotoPicked:(nullable PhotoPickedBlock)photoPicked
                    onCancel:(nullable CancelBlock)cancelled;

@end
NS_ASSUME_NONNULL_END