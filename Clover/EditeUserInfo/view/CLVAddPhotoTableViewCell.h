//
//  CLVAddPhotoTableViewCell.h
//  Clover
//
//  Created by shen chen on 2017/12/28.
//  Copyright © 2017年 shenchen. All rights reserved.
//

#import <UIKit/UIKit.h>

#pragma mark - 编辑我的页资料的照片抽象cell
@interface CLVAddPhotoTableViewCell : UITableViewCell

- (void)addSubviews;
- (void)setupLayout;
- (void)setupStyle;
- (void)setContent:(id)model;

@end

#pragma mark - 编辑我的页资料的照片默认cell
@interface CLVAddPhotoTableViewCellDefault : CLVAddPhotoTableViewCell

@end
