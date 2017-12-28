//
//  UIScrollView+LDScrollToTop.h
//  LDKit
//
//  Created by 金秋实 on 7/19/16.
//  Copyright © 2017年 LDKit. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIScrollView (LDScrollToTop)

/**
 * 返回顶部按钮中心到tableview右边的距离，默认值29.0
 */
@property (nonatomic, assign) CGFloat ld_scrollToTopIconRightCenterDistance;

/**
 * 返回顶部按钮中心到tableview底部的距离，默认值29.0
 */
@property (nonatomic, assign) CGFloat ld_scrollToTopIconBottomCenterDistance;


/**
 * 返回顶部按钮开始显示时候屏幕的tableview偏移量，默认值为 该tableview高度
 */
@property (nonatomic, assign) CGFloat ld_scrollToTopIconShownOffset;

/**
 * 是否开启返回顶部按钮
 */
@property (nonatomic, assign) BOOL ld_scrollToTopIconEnabled;

@property (nonatomic, strong, readonly) UIButton *ld_scrollToTopIcon;

@end
