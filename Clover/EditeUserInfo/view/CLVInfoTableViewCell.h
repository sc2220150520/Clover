//
//  CLVInfoTableViewCell.h
//  Clover
//
//  Created by shen chen on 2017/12/27.
//  Copyright © 2017年 shenchen. All rights reserved.
//

#import <UIKit/UIKit.h>

#pragma mark - 编辑个人信息页的tableViewCell抽象基类
@interface CLVInfoTableViewCell : UITableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier aboutTheme:(NSString *)str shouldShowBottomLine:(BOOL)shouldShowBottomLine;
- (void)addSubviews;
- (void)setupLayout;
- (void)setupStyle;
- (void)setContent:(id)model;
- (void)didTapped;

@end

#pragma mark - 编辑头像的cell
@interface CLVEditImageTableViewCell : CLVInfoTableViewCell
@end

#pragma mark - 编辑昵称或者个性签名类型的cell
@interface CLVEditTextTableViewCell : CLVInfoTableViewCell
@end

#pragma mark - 编辑性别的cell
@interface CLVEditButtonTableViewCell : CLVInfoTableViewCell
@end

#pragma mark - 编辑地址的cell
@interface CLVEditAddressTableViewCell : CLVInfoTableViewCell
@end

#pragma mark - 编辑年龄的cell
@interface CLVEditAgeTableViewCell : CLVInfoTableViewCell
@end
