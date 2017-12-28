//
//  UIButton+LDAddition.h
//  LDKitDemo
//
//  Created by lixingdong on 16/8/5.
//  written by yingjie on 16/3/7.
//  ht-tp://stackoverflow.com/questions/808503/uibutton-making-the-hit-area-larger-than-the-default-hit-area
//  written by wangbo on 11-10-11.
//  written by yangning2014 on 14-8-1.
//  Copyright © 2016年 david. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (LDAddition)

@property (nonatomic, assign) UIEdgeInsets ld_hitTestEdgeInsets;

- (void)ld_setImageViewRight;

- (void)ld_setAllStateTitle:(NSString *)title;

- (void)ld_setAllStateImage:(UIImage *)image;


+ (UIButton *)ld_buttonWithImage:(UIImage *)image
                          target:(id)target
                          action:(SEL)selector;

@end
