//
//  CLVOfenPlayedBottomView.m
//  Clover
//
//  Created by shen chen on 2017/12/26.
//  Copyright © 2017年 shenchen. All rights reserved.
//

#import "CLVOfenPlayedBottomView.h"
#import <Masonry.h>

#pragma mark - 常玩游戏页底部的抽象View
@implementation CLVOfenPlayedBottomView

- (void) setLayout {}
- (void) setStyle {}
- (void) setContent:(id)model {}
- (void) addSubviews {}

@end

#pragma mark - 常玩游戏页底部的具体朋友View
@interface CLVOfenPlayedBottomViewFri()
@property (nonatomic, strong) UIButton *playBtn;
@end

@implementation CLVOfenPlayedBottomViewFri
- (instancetype)init {
    self = [super init];
    if (self) {
        [self addSubviews];
        [self setLayout];
        [self setStyle];
    }
    return self;
}

- (void)addSubviews {
    [self addSubview:self.playBtn];
}

- (void)setLayout {
    [self.playBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(15);
        make.right.equalTo(self).offset(-15);
        make.centerY.equalTo(self);
        make.height.equalTo(@40);
    }];
    [self.playBtn setTitle:@"聊玩" forState:UIControlStateNormal];
}

- (void)setStyle {
    self.playBtn.backgroundColor = [UIColor ld_colorWithHex:0xEC4D4C];
    self.playBtn.layer.masksToBounds = YES;
    self.playBtn.layer.cornerRadius = 20;
    self.playBtn.layer.borderWidth = 0.5;
}

- (void)setContent:(id)model {
    //[self.playBtn setTitle:@"聊玩" forState:UIControlStateNormal];
}

- (UIButton *)playBtn {
    if (_playBtn == nil) {
        _playBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    }
    return _playBtn;
}
@end

#pragma mark - 常玩游戏页底部的具体路人View
@interface CLVOfenPlayedBottomViewStranger()
@property (nonatomic, strong) UIButton *playBtn;
@property (nonatomic, strong) UIButton *addBtn;
@end

@implementation CLVOfenPlayedBottomViewStranger

- (instancetype)init {
    self = [super init];
    if (self) {
        [self addSubviews];
        [self setLayout];
        [self setStyle];
    }
    return self;
}

- (void)addSubviews {
    [self addSubview:self.playBtn];
    [self addSubview:self.addBtn];
}

- (void)setLayout {
     [@[self.addBtn,self.playBtn] mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:21 leadSpacing:15 tailSpacing:15];
    [@[self.addBtn,self.playBtn] mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.height.equalTo(@40);
    }];
    [self.playBtn setTitle:@"聊玩" forState:UIControlStateNormal];
    [self.addBtn setTitle:@"加为好友" forState:UIControlStateNormal];
}

- (void)setStyle {
    self.playBtn.backgroundColor = [UIColor ld_colorWithHex:0xEC4D4C];
    self.playBtn.layer.masksToBounds = YES;
    self.playBtn.layer.cornerRadius = 20;
    self.playBtn.layer.borderWidth = 0.5;
    
    self.addBtn.backgroundColor = [UIColor ld_colorWithHex:0x6F3CF3];
    self.addBtn.layer.masksToBounds = YES;
    self.addBtn.layer.cornerRadius = 20;
    self.addBtn.layer.borderWidth = 0.5;
}

- (void)setContent:(id)model {
    //[self.playBtn setTitle:@"聊玩" forState:UIControlStateNormal];
}

- (UIButton *)playBtn {
    if (_playBtn == nil) {
        _playBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    }
    return _playBtn;
}

- (UIButton *)addBtn {
    if (_addBtn == nil) {
        _addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    }
    return _addBtn;
}

@end


