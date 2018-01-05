//
//  CLVFloatLayerTableCell.m
//  Clover
//
//  Created by shen chen on 2018/1/4.
//  Copyright © 2018年 shenchen. All rights reserved.
//

#import "CLVFloatLayerTableCell.h"
#import "CLVFLoatViewConstans.h"
#import <Masonry.h>

@interface CLVFloatLayerTableCell()

@property (nonatomic, strong) UIView *clv_contentView;
@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) action actionCall;


@end

@implementation CLVFloatLayerTableCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self addSubviews];
        [self setupLayout];
        [self setupStyle];
    }
    return self;
}
- (void)addSubviews {
    [self.contentView addSubview:self.clv_contentView];
    [self.clv_contentView addSubview:self.label];
}
- (void)setupLayout {
    [self.clv_contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(20);
        make.right.equalTo(self.contentView).offset(-20);
        make.height.equalTo([NSNumber numberWithFloat:cellHeight]);
        make.top.bottom.equalTo(self.contentView);
    }];
    [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.clv_contentView);
        make.left.right.equalTo(self.clv_contentView);
        make.height.equalTo(self.clv_contentView);
    }];
}
- (void)setupStyle {
    self.contentView.backgroundColor = [UIColor ld_colorWithHex:0xf6f6f6];
    self.clv_contentView.backgroundColor = [UIColor whiteColor];
    self.label.font = [UIFont ld_defaultFontOfSize:17];
    self.label.textColor = [UIColor ld_colorWithHex:0x333333];
    self.label.textAlignment = NSTextAlignmentCenter;
}
- (void)setContent:(id)model {
    NSString *str = model;
    self.label.text = str;
}

- (void)setupAction:(action)actor {
    self.actionCall = actor;
}

- (void)didTappedWithInfo:(id)info {
    self.actionCall();
}

#pragma mark lazyLoad
- (UIView *)clv_contentView {
    if (_clv_contentView == nil) {
        _clv_contentView = [[UIView alloc] init];
    }
    return _clv_contentView;
}

- (UILabel *)label {
    if (_label == nil) {
        _label = [[UILabel alloc] init];
    }
    return _label;
}

@end
