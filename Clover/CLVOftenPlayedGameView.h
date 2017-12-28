//
//  CLVOftenPlayedGameView.h
//  Clover
//
//  Created by shen chen on 2017/12/26.
//  Copyright © 2017年 shenchen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CLVOftenPlayedGameView : UIView

- (void) setLayout;
- (void) setStyle;
- (void) setContent:(id)model;
- (void) addSubviews;

@end

@interface CLVDefaultOftenPlayedGameView : CLVOftenPlayedGameView
@end
