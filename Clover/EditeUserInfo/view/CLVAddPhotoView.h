//
//  CLVAddPhotoView.h
//  Clover
//
//  Created by shen chen on 2017/12/28.
//  Copyright © 2017年 shenchen. All rights reserved.
//

#import <UIKit/UIKit.h>

#pragma mark - 添加照片View抽象类
@interface CLVAddPhotoView : UIView

- (void)addSubviews;
- (void)setupLayout;
- (void)setupStyle;
- (void)setContent:(id)model;
- (void)viewDidTapped:(id)sender;

@end

#pragma mark - 默认的具体类
@interface CLVAddPhotoViewDefault : CLVAddPhotoView
@end
