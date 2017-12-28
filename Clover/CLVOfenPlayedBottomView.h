//
//  CLVOfenPlayedBottomView.h
//  Clover
//
//  Created by shen chen on 2017/12/26.
//  Copyright © 2017年 shenchen. All rights reserved.
//

#import <UIKit/UIKit.h>

#pragma mark - 常玩游戏页底部的抽象View
@interface CLVOfenPlayedBottomView : UIView

- (void) setLayout;
- (void) setStyle;
- (void) setContent:(id)model;
- (void) addSubviews;

@end

#pragma mark - 常玩游戏页底部的具体朋友View
@interface CLVOfenPlayedBottomViewFri : CLVOfenPlayedBottomView
@end

#pragma mark - 常玩游戏页底部的具体路人View
@interface CLVOfenPlayedBottomViewStranger : CLVOfenPlayedBottomView
@end
