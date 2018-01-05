//
//  CLVFloatLayerView.h
//  Clover
//
//  Created by shen chen on 2018/1/4.
//  Copyright © 2018年 shenchen. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CLVFloatLayerDelegate <NSObject>
- (void) onHide;
@end

@interface CLVFloatLayerView : UIView

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, weak) id<CLVFloatLayerDelegate> delegate;

- (instancetype)initWithFrame:(CGRect)frame tableViewHeight:(CGFloat) tableViewHeight;

- (void)showInParentView:(UIView *)parentView;

- (void)hide;

@end
