//
//  UINavigationItem+LDAddition.m
//  LDKit
//
//  Created by Anchor on 17/3/9.
//  Copyright © 2017年 LDKit. All rights reserved.
//

#import "UINavigationItem+LDAddition.h"

@implementation UINavigationItem (LDAddition)

// 以下两个方法对iOS11进行适配
// 暂时只处理UIButton，目前大多数情况均为UIButton
// 如果遇到其它情况，需要进一步完善
// 效果不理想，响应区域与显示位置有偏差，暂时先不做修改了 20171012
- (void)ld_addLeftBarButtonItem:(UIBarButtonItem *)leftBarButtonItem
{
//    if ([[UIDevice currentDevice].systemVersion floatValue] < 11.0) {
        UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                           initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                           target:nil action:nil];
        negativeSpacer.width = -18;
        [self setLeftBarButtonItems:[NSArray arrayWithObjects:negativeSpacer, leftBarButtonItem, nil]];
//    } else {
//        UIView *customView = leftBarButtonItem.customView;
//        if ([customView isKindOfClass:[UIButton class]]) {
//            UIButton *button = (UIButton *)customView;
//            button.imageEdgeInsets = UIEdgeInsetsMake(0, -18, 0, 18);
//            button.titleEdgeInsets = UIEdgeInsetsMake(0, -18, 0, 18);
//        }
//        [self setLeftBarButtonItems:[NSArray arrayWithObjects:leftBarButtonItem, nil]];
//    }
}

- (void)ld_addRightBarButtonItem:(UIBarButtonItem *)rightBarButtonItem
{
//    if ([[UIDevice currentDevice].systemVersion floatValue] < 11.0) {
        UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                           initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                           target:nil action:nil];
        negativeSpacer.width = -10;
        [self setRightBarButtonItems:[NSArray arrayWithObjects:negativeSpacer, rightBarButtonItem, nil]];
//    } else {
//        UIView *customView = rightBarButtonItem.customView;
//        if ([customView isKindOfClass:[UIButton class]]) {
//            UIButton *button = (UIButton *)customView;
//            button.imageEdgeInsets = UIEdgeInsetsMake(0, 10, 0, -10);
//            button.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, -10);
//        }
//        [self setRightBarButtonItems:[NSArray arrayWithObjects:rightBarButtonItem, nil]];
//    }
}

// 缩小barButtonItem之间的间隔(iOS 11上未适配，问题参考上面两个方法)
- (void)ld_addRightBarButtonItems:(NSArray *)rightBarButtonItems
{
    // Add a negative spacer on iOS >= 7.0
    NSMutableArray *tmpArray = [NSMutableArray array];
    for (UIBarButtonItem *item in rightBarButtonItems) {
        UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                           initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                           target:nil action:nil];
        negativeSpacer.width = -20;
        [tmpArray addObject:item];
        [tmpArray addObject:negativeSpacer];
    }
    [self setRightBarButtonItems:[NSArray arrayWithArray:tmpArray]];
}

@end
