//
//  COUserInforView.h
//  Clover
//
//  Created by shen chen on 2017/12/22.
//  Copyright © 2017年 shenchen. All rights reserved.
//

#import <UIKit/UIKit.h>

#pragma mark - 用户基本信息View抽象类
@interface COUserInforView : UIView
//抽象函数
- (void)setLayOut;
- (void)setStyle;
- (void)setContent:(id)model;
- (void)addSubviews;
@end

#pragma mark -非自己用户基本信息View类
@interface COConcreteUserInfoViewP:COUserInforView
@end

#pragma mark -用户基本信息View具体类
@interface COConcreteUserInforViewS:COConcreteUserInfoViewP

@end

#pragma mark -非自己个人信息常玩游戏页
@interface COUserInfoDetailP:COConcreteUserInfoViewP
@end

#pragma mark -用户个人信息常玩游戏页
@interface COUserInfoDetailS:COUserInfoDetailP
@end
