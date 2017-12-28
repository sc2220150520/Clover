//
//  UIButton+CLVCustom.h
//  Clover
//
//  Created by shen chen on 2017/12/27.
//  Copyright © 2017年 shenchen. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, CLVCustomButtonStyle) {
    CLVCustomButtonDefaultStyle = 0 ,//默认样式 什么都没设置
    CLVCustomButtonRBgWTxtStyle = 1, //红底白字
    CLVCustomButtonBBgWTexStyle = 2 //蓝底白字
};

@interface UIButton (CLVCustom)

/**
 根据样式获得不同样式的按钮
 
 @param clvCustomButtonStyle 按钮样式，默认圆角半径为2
 @return 指定样式的按钮
 */
+ (instancetype)clv_createButtonWithStyle:(CLVCustomButtonStyle )clvCustomButtonStyle;

/**
 根据样式和圆角大小获得不同样式的按钮
 
 @param clvCustomButtonStyle 按钮样式
 @param cornerRaidus 圆角半径
 @return 指定样式的按钮
 */
+ (instancetype)clv_createButtonWithStype:(CLVCustomButtonStyle )clvCustomButtonStyle cornerRadius:(CGFloat)cornerRaidus;

- (void )setBackgroundColor:(UIColor *)backgroundColor  cornerRadius:(CGFloat)cornerRadius borderColor:(UIColor *)borderColor borderWidth:(CGFloat)borderWidth forState:(UIControlState)state;

@end
