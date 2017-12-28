//
//  UIView+LDAutoLayoutHelper.h
//  LDKitDemo
//
//  Created by lixingdong on 16/8/8.
//  written by Di Wu on 6/1/15.
//  Copyright © 2016年 david. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (LDAutoLayoutHelper)

/**
 @brief 移除跟 UIView 自身相关的所有 contraints, 无论该 constraint 的持有者是自己，还是自己的 superview 视图
 @note 必须在 UI 线程上调用
 */
- (void)ld_cleanConstraints;

@end
