//
//  CLVFloatLayerTableCell.h
//  Clover
//
//  Created by shen chen on 2018/1/4.
//  Copyright © 2018年 shenchen. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^action)(void);
@interface CLVFloatLayerTableCell : UITableViewCell

- (void)setContent:(id)model;
- (void)didTappedWithInfo:(id)info;
- (void)setupAction:(action)actor;

@end
