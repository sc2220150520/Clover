//
//  COSetUpTableViewCell.m
//  Clover
//
//  Created by shen chen on 2017/12/25.
//  Copyright © 2017年 shenchen. All rights reserved.
//

#import "COSetUpTableViewCell.h"
#import <Masonry.h>
#import "COUserInforView.h"
#import "COSetupModel.h"
#import "UserInfoModel.h"

@implementation COSetUpTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier shouldShowBottomLine:(BOOL)shouldShowBottomLine {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.shouldShowBottomLine = shouldShowBottomLine;
    }
    return self;
}
- (void)addSubViews {};
- (void) setUpLayOut {}
- (void) setStyle {}
- (void) setContent:(id)model {}

#pragma mark - 画cell底部分割线
-(void)drawRect:(CGRect)rect{
    if (self.shouldShowBottomLine) {
        CGContextRef context = UIGraphicsGetCurrentContext();
        
        CGContextSetFillColorWithColor(context, [UIColor clearColor].CGColor);
        CGContextFillRect(context, rect);
        
        CGContextSetStrokeColorWithColor(context, [UIColor ld_colorWithHex:0xE8E8E8].CGColor);
        CGContextStrokeRect(context, CGRectMake(15, rect.size.height, rect.size.width - 15, 1.0 / [UIScreen mainScreen].scale));
    }
}

@end

#pragma mark - 具体的关于设置风格的cell
@interface COConcretSetUpCell ()
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UIView *numView;
@property (nonatomic, strong) UIImageView *arrowView;
@property (nonatomic, strong) UILabel *numLabel;

@end

@implementation COConcretSetUpCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier shouldShowBottomLine:(BOOL)shouldShowBottomLine {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier shouldShowBottomLine:shouldShowBottomLine];
    if (self) {
        [self addSubViews];
        [self setUpLayOut];
        [self setStyle];
    }
    return self;
}

- (void)setUpLayOut {
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(17);
        make.left.equalTo(self.contentView).offset(16);
        make.width.equalTo(@14);
        make.height.equalTo(@14);
        make.bottom.equalTo(self.contentView).offset(-17);
    }];
    
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.iconImageView);
        make.left.equalTo(self.iconImageView.mas_right).offset(15);
        make.width.lessThanOrEqualTo(@100);
        make.height.equalTo(@20);
    }];
    
    self.arrowView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mine_arrow"]];
    [self.contentView addSubview:self.arrowView];
    [self.arrowView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.right.equalTo(self.contentView).offset(-15);
        make.width.equalTo(@15);
        make.height.equalTo(@15);
    }];
    
    [self.numView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.iconImageView);
        make.right.equalTo(self.arrowView.mas_left).offset(-10);
        make.width.height.equalTo(@20);
    }];
    [self.numLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.numView);
        make.width.equalTo(self.numView);
        make.height.equalTo(self.numView);
    }];
    UIImageView *numImageView = [[UIImageView alloc] init];
    [self.numView addSubview:numImageView];
    [self.numView bringSubviewToFront:self.numLabel];
    [numImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.numView);
        make.width.equalTo(self.numView);
        make.height.equalTo(self.numView);
    }];
    //注释
    numImageView.backgroundColor = [UIColor yellowColor];
}

- (void)setStyle {
    self.contentLabel.textColor = [UIColor ld_colorWithHex:0x333333];
    self.contentLabel.font = [UIFont ld_defaultFontOfSize:15];
    self.numLabel.textColor = [UIColor ld_colorWithHex:0xF75147];
    self.numLabel.font = [UIFont ld_defaultFontOfSize:14];
    
    //注释
    self.arrowView.backgroundColor = [UIColor redColor];
    self.iconImageView.backgroundColor = [UIColor blueColor];
    self.numView.backgroundColor = [UIColor greenColor];
}

- (void)setContent:(id)model {
    COSetupModel *item = model;
    if (item == nil) {
        return;
    }
    self.iconImageView.image = [UIImage imageNamed:item.imageUrl];
    self.contentLabel.text = item.text;
    if (item.num.length == 0 || [item.num integerValue] == 0) {
         self.numView.hidden = YES;
    } else {
        self.numView.hidden = NO;
        self.numLabel.text = item.num;
    }
}

- (void)addSubViews {
    [self.contentView addSubview:self.iconImageView];
    [self.contentView addSubview:self.contentLabel];
    [self.contentView addSubview:self.numView];
    [self.numView addSubview:self.numLabel];
    [self.contentView addSubview:self.arrowView];
}

#pragma mark lazyLoad
- (UIImageView *)iconImageView {
    if (_iconImageView == nil) {
        _iconImageView = [[UIImageView alloc] init];
    }
    return _iconImageView;
}

- (UILabel *)contentLabel {
    if (_contentLabel == nil) {
        _contentLabel = [[UILabel alloc] init];
    }
    return _contentLabel;
}

- (UIView *)numView {
    if (_numView == nil) {
        _numView = [[UILabel alloc] init];
    }
    return _numView;
}

- (UIImageView *)arrowView {
    if (_arrowView == nil) {
        _arrowView = [[UIImageView alloc] init];
    }
    return _arrowView;
}

- (UILabel *)numLabel {
    if (_numLabel == nil) {
        _numLabel = [[UILabel alloc] init];
    }
    return _numLabel;
}
@end

#pragma mark - inforCell
@interface COConcretInfoCell()
@property (nonatomic, strong) COUserInforView *userInfoView;
@end;

@implementation COConcretInfoCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier shouldShowBottomLine:(BOOL)shouldShowBottomLine {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier shouldShowBottomLine:shouldShowBottomLine];
    if (self) {
        [self addSubViews];
        [self setUpLayOut];
        [self setStyle];
    }
    return self;
}
- (void)addSubViews {
    [self.contentView addSubview:self.userInfoView];
}

- (void)setContent:(id)model {
    [self.userInfoView setContent:model];
}

- (void)setUpLayOut {
    [self.userInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(0);
        make.right.equalTo(self.contentView).offset(0);
        make.top.equalTo(self.contentView).offset(0);
        make.height.equalTo(@221);
        make.bottom.equalTo(self.contentView).offset(0);
    }];
}

- (void)setStyle {
    self.userInfoView.backgroundColor = [UIColor ld_colorWithHex:0xEC4D4C];
}

- (COUserInforView *)userInfoView {
    if (_userInfoView == nil) {
        _userInfoView = [[COConcreteUserInforViewS alloc] init];
    }
    return _userInfoView;
}
@end
