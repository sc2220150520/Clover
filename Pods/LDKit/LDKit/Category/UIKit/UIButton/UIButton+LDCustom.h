//
//  UIButton+LDCustom.h
//  LDKitDemo
//
//  Created by ITxiansheng on 2016/11/11.
//  Copyright © 2016年 LDKit. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, LDCustomButtonStyle) {
    LDCustomButtonDefaultStyle = 0 ,//默认样式 什么都没设置
    LDCustomButtonRBgWTxtStyle = 1, //红底白字
    LDCustomButtonWBgRTxtStyle = 2 ,//白底红字红边框
    LDCustomButtonCBgRTxtStyle = 3 ,//透明底红字红边框
};

@interface UIButton (LDCustom)

/**
  根据样式获得不同样式的按钮

 @param ldCustomButtonStyle 按钮样式，默认圆角半径为4
 @return 指定样式的按钮
 */
+ (instancetype)ld_createButtonWithStyle:(LDCustomButtonStyle )ldCustomButtonStyle;

/**
 根据样式和圆角大小获得不同样式的按钮
 
 @param ldCustomButtonStyle 按钮样式
 @param cornerRaidus 圆角半径
 @return 指定样式的按钮
 */
+ (instancetype)ld_createButtonWithStype:(LDCustomButtonStyle )ldCustomButtonStyle cornerRadius:(CGFloat)cornerRaidus;


@end
