//
//  COUserInforView.m
//  Clover
//
//  Created by shen chen on 2017/12/22.
//  Copyright © 2017年 shenchen. All rights reserved.
//

#import "COUserInforView.h"
#import <Masonry.h>
#import <UIKit/UIKit.h>
#import "UserInfoModel.h"

@implementation COUserInforView

- (void)setContent:(id)model {}

- (void)setLayOut {}

- (void)setStyle {}

- (void)addSubviews {};

#pragma mark - 获得所在控制器
- (UIViewController *)viewController {
    for (UIView *next = self.superview; next; next = next.superview) {
        UIResponder *nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)nextResponder;
        }
    }
    return nil;
}

@end

#pragma mark - 具体用户信息View1
@interface COConcreteUserInfoViewP()
@property (nonatomic, strong) UIImageView *headImageView;
@property (nonatomic, strong) UIView *downView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *ageLabel;
@property (nonatomic, strong) UILabel *addressLabel;
@property (nonatomic, strong) UILabel *idLabel;
@property (nonatomic, strong) UILabel *descLabel;
@property (nonatomic, strong) UILabel *sexLabel;
@property (nonatomic, strong) UIView *nameSexAddView;
@property (nonatomic, strong) UITapGestureRecognizer *gesture;

@end

@implementation COConcreteUserInfoViewP
#pragma mark -init
- (instancetype)init {
    self = [super init];
    if (self) {
        self.gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapped:)];
        [self addGestureRecognizer:self.gesture];
        [self addSubviews];
        [self setLayOut];
        [self setStyle];
    }
    return self;
}

- (void)addSubviews {
    [self addSubview:self.headImageView];
    [self addSubview:self.nameLabel];
    [self addSubview:self.downView];
    [self.downView addSubview:self.nameSexAddView];
    [self.nameSexAddView addSubview:self.sexLabel];
    [self.nameSexAddView addSubview:self.ageLabel];
    [self.nameSexAddView addSubview:self.addressLabel];
    [self.nameSexAddView addSubview:self.idLabel];
    [self.downView addSubview:self.descLabel];
}

- (void)setLayOut {
    [self.headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self).offset(30);
        make.width.height.equalTo(@60);
    }];
    
    [self.downView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.equalTo(self.headImageView.mas_bottom).offset(30);
        make.bottom.equalTo(self);
    }];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        //注释
        make.height.width.equalTo(@0);
    }];
    [self.sexLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        //注释
        make.height.width.equalTo(@0);
    }];
    //设置年龄地址id
    [self.nameSexAddView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.downView);
        make.height.equalTo(@18);
        make.centerX.equalTo(self.downView);
        make.left.equalTo(self.ageLabel);
        make.right.equalTo(self.idLabel);
    }];
    [self.ageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@37);
        make.top.equalTo(self.nameSexAddView);
        make.height.equalTo(self.nameSexAddView);
    }];
    [self.addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nameSexAddView);
        make.height.equalTo(self.nameSexAddView);
        make.left.equalTo(self.ageLabel.mas_right).offset(12.5);
        make.width.equalTo(@55);
    }];
    [self.idLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nameSexAddView);
        make.height.equalTo(self.nameSexAddView);
        make.left.equalTo(self.addressLabel.mas_right).offset(9);
        make.width.equalTo(@122);
    }];
    
    [self.descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.ageLabel.mas_bottom).offset(21);
        make.centerX.equalTo(self.downView);
        make.height.equalTo(@23);
    }];
}

- (void)setStyle {
    self.backgroundColor = [UIColor whiteColor];
    self.nameLabel.font = [UIFont ld_defaultFontOfSize:15];
    self.nameLabel.textColor = [UIColor ld_colorWithHex:0x666666];
    self.sexLabel.font = [UIFont ld_defaultFontOfSize:12];
    self.sexLabel.textColor = [UIColor ld_colorWithHex:0x666666];
    self.ageLabel.font = [UIFont ld_defaultFontOfSize:12];
    self.ageLabel.textColor = [UIColor ld_colorWithHex:0x666666];
    self.addressLabel.font = [UIFont ld_defaultFontOfSize:12];
    self.addressLabel.textColor = [UIColor ld_colorWithHex:0x666666];
    self.idLabel.font = [UIFont ld_defaultFontOfSize:12];
    self.idLabel.textColor = [UIColor ld_colorWithHex:0x666666];
    self.descLabel.font = [UIFont ld_defaultFontOfSize:16];
    self.descLabel.textColor = [UIColor ld_colorWithHex:0xffffff];
    //注释
    self.nameSexAddView.backgroundColor = [UIColor whiteColor];
}

- (void)setContent:(id)model {
    UserInfoModel *item = model;
    if (item == nil) {
        return;
    }
    //注释
    self.headImageView.backgroundColor = [UIColor redColor];
    self.headImageView.image = [UIImage imageNamed:item.imageUrl];
    self.nameLabel.text = item.name;
    self.sexLabel.text = item.sex;
    self.addressLabel.text = item.address;
    self.idLabel.text = item.idnum;
    self.descLabel.text = item.desc;
    self.ageLabel.text = item.age;
}

- (void)onTapped:(id)sender {
    if ([[self viewController] respondsToSelector:@selector(userInfoViewTapped:)]) {
        [[self viewController] performSelector:@selector(userInfoViewTapped:) withObject:sender];
    }
}

#pragma mark -LazyLoad
- (UIImageView *)headImageView {
    if (_headImageView == nil) {
        _headImageView = [[UIImageView alloc] init];
    }
    return _headImageView;
}

- (UILabel *)nameLabel {
    if (_nameLabel == nil) {
        _nameLabel = [[UILabel alloc] init];
    }
    return _nameLabel;
}

- (UILabel *)ageLabel {
    if (_ageLabel == nil) {
        _ageLabel = [[UILabel alloc] init];
    }
    return _ageLabel;
}

- (UILabel *)addressLabel {
    if (_addressLabel == nil) {
        _addressLabel = [[UILabel alloc] init];
    }
    return _addressLabel;
}

- (UILabel *)idLabel {
    if (_idLabel == nil) {
        _idLabel = [[UILabel alloc] init];
    }
    return _idLabel;
}

- (UILabel *)descLabel {
    if (_descLabel == nil) {
        _descLabel = [[UILabel alloc] init];
    }
    return _descLabel;
}

- (UILabel *)sexLabel {
    if (_sexLabel == nil) {
        _sexLabel = [[UILabel alloc] init];
    }
    return _sexLabel;
}

- (UIView *)downView {
    if (_downView == nil) {
        _downView = [[UIView alloc] init];
    }
    return _downView;
}

- (UIView *)nameSexAddView {
    if (_nameSexAddView == nil) {
        _nameSexAddView = [[UIView alloc] init];
    }
    return _nameSexAddView;
}

@end

#pragma mark - 个人信息页自己
@interface COConcreteUserInforViewS()
@property (nonatomic, strong) UIImageView *editeImageView;
@end

@implementation COConcreteUserInforViewS
#pragma mark -init
- (void)addSubviews {
    [super addSubviews];
    [self addSubview:self.editeImageView];
}

- (void)setLayOut {
    [super setLayOut];
    [self.editeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-15);
        make.top.equalTo(self).offset(15);
        make.height.width.equalTo(@30);
    }];
}

- (void)setContent:(id)model {
    [super setContent:model];
}

- (void)setStyle {
    [super setStyle];
    self.editeImageView.backgroundColor = [UIColor redColor];
}

- (void)onTapped:(id)sender {
    if ([[self viewController] respondsToSelector:@selector(userInfoViewTapped:)]) {
        [[self viewController] performSelector:@selector(userInfoViewTapped:) withObject:sender];
    }
}
#pragma mark -lazyLoad
- (UIImageView *)editeImageView {
    if (_editeImageView == nil) {
        _editeImageView = [[UIImageView alloc] init];
    }
    return _editeImageView;
}
@end

#pragma mark - 非自己个人信息常玩游戏页
@interface COUserInfoDetailP()
@property (nonatomic, strong) UIImageView *carouselFigure;
@property (nonatomic, strong) UIView *infoView;
@end

@implementation COUserInfoDetailP

#pragma mark -public interface
- (void)addSubviews {
    [self addSubview:self.carouselFigure];
    [self addSubview:self.infoView];
    [self addSubview:self.headImageView];
    [self.infoView addSubview:self.nameLabel];
    [self.infoView addSubview:self.ageLabel];
    [self.infoView addSubview:self.addressLabel];
    [self.infoView addSubview:self.idLabel];
    [self.infoView addSubview:self.descLabel];
}

- (void)setLayOut {
    [self.carouselFigure mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.left.right.equalTo(self);
        make.height.equalTo(@375);
    }];
    
    [self.infoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.carouselFigure.mas_bottom);
        make.left.right.equalTo(self);
        make.height.equalTo(@114);
    }];
    
    [self.headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(10);
        make.width.height.equalTo(@60);
        make.centerY.equalTo(self.carouselFigure.mas_bottom);
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.infoView).offset(7.5);
        make.height.equalTo(@22.5);
        make.left.equalTo(self.headImageView.mas_right).offset(22.5);
        make.right.lessThanOrEqualTo(self.infoView);
    }];
    
    [self.ageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.infoView).offset(15);
        make.top.equalTo(self.headImageView.mas_bottom).offset(11);
        make.width.equalTo(@50);
        make.height.equalTo(@18);
    }];
    [self.addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.ageLabel.mas_right).offset(10);
        make.top.equalTo(self.ageLabel);
        make.width.equalTo(@55);
        make.height.equalTo(self.ageLabel);
    }];
    [self.idLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.addressLabel.mas_right).offset(12);
        make.top.equalTo(self.ageLabel);
        make.width.equalTo(@92);
        make.height.equalTo(self.ageLabel);
    }];
    
    [self.descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.infoView).offset(16);
        make.bottom.equalTo(self.infoView).offset(-14.5);
        make.right.lessThanOrEqualTo(self.infoView);
        make.height.equalTo(@20);
    }];
}

- (void)setStyle {
    [super setStyle];
    self.nameLabel.font = [UIFont ld_defaultFontOfSize:16];
    self.nameLabel.textColor = [UIColor ld_colorWithHex:0x333333];
    self.descLabel.font = [UIFont ld_defaultFontOfSize:14];
    self.descLabel.textColor = [UIColor ld_colorWithHex:0x999999];
    self.headImageView.backgroundColor = [UIColor blueColor];
    self.carouselFigure.backgroundColor = [UIColor orangeColor];
}

- (void)setContent:(id)model {
    [super setContent:model];
}

#pragma mark -lazyLoad
- (UIImageView *)carouselFigure {
    if (_carouselFigure == nil) {
        _carouselFigure = [[UIImageView alloc] init];
    }
    return _carouselFigure;
}

- (UIView *)infoView {
    if (_infoView == nil) {
        _infoView = [[UIView alloc] init];
    }
    return _infoView;
}

@end

#pragma mark -用户个人信息常玩游戏页
@interface COUserInfoDetailS()
@property (nonatomic, strong) UIButton *editeBtn;
@end

@implementation COUserInfoDetailS

#pragma mark -init
- (void)addSubviews {
    [super addSubviews];
    [self addSubview:self.editeBtn];
}

- (void)setLayOut {
    [super setLayOut];
    [self.editeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-15);
        make.top.equalTo(self).offset(64);
        make.height.width.equalTo(@30);
    }];
}

- (void)setContent:(id)model {
    [super setContent:model];
}

- (void)setStyle {
    [super setStyle];
    self.editeBtn.backgroundColor = [UIColor greenColor];
    [self.editeBtn addTarget:self action:@selector(editeBtnDidTapped:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)editeBtnDidTapped:(id)sender {
    if ([[self viewController] respondsToSelector:@selector(enterEditeViewController:)]) {
        [[self viewController] performSelector:@selector(enterEditeViewController:) withObject:sender];
    }
}
#pragma mark -lazyLoad
- (UIButton *)editeBtn {
    if (_editeBtn == nil) {
        _editeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    }
    return _editeBtn;
}

@end


