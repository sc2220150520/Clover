//
//  CLVOftenPlayedGameView.m
//  Clover
//
//  Created by shen chen on 2017/12/26.
//  Copyright © 2017年 shenchen. All rights reserved.
//

#import "CLVOftenPlayedGameView.h"
#import <Masonry.h>

#pragma mark - 常玩游戏View抽象类
@interface CLVOftenPlayedGameView()

@property (nonatomic, strong) UILabel *oftenGameLabel;
@property (nonatomic, strong) NSMutableArray *gameimageArr;

@end

@implementation CLVOftenPlayedGameView

- (void) setLayout {}
- (void) setStyle {}
- (void) setContent:(id)model {}
- (void) addSubviews {}

#pragma mark -lazyLoad
- (NSMutableArray *)gameimageArr {
    if (_gameimageArr == nil) {
        _gameimageArr = [NSMutableArray array];
    }
    return _gameimageArr;
}
- (UILabel *)oftenGameLabel {
    if (_oftenGameLabel == nil) {
        _oftenGameLabel = [[UILabel alloc] init];
    }
    return _oftenGameLabel;
}

@end

#pragma mark - 常玩游戏View默认的具体类
@interface CLVDefaultOftenPlayedGameView()
@end

@implementation CLVDefaultOftenPlayedGameView

#pragma mark -init
- (instancetype)init {
    self = [super init];
    if (self) {
        for (int i = 0; i < 5; i++) {
            UIImageView *viewtemp = [[UIImageView alloc] init];
            [self.gameimageArr addObject:viewtemp];
        }
        [self addSubviews];
        [self setLayout];
        [self setStyle];
    }
    return self;
}

- (void)addSubviews {
    [self addSubview:self.oftenGameLabel];
    for (UIImageView * it in self.gameimageArr) {
        [self addSubview:it];
    }
}

- (void)setLayout {
    [self.oftenGameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(12.5);
        make.left.equalTo(self).offset(15);
        make.width.equalTo(@100);
        make.height.equalTo(@16.5);
    }];
    
    if (self.gameimageArr.count > 0) {
        [self.gameimageArr mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:15 leadSpacing:13 tailSpacing:13];
    }
   
    [self.gameimageArr mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.oftenGameLabel.mas_bottom).offset(9);
        make.height.equalTo(((UIView *)self.gameimageArr[0]).mas_width);
    }];
}

- (void)setStyle {
    self.backgroundColor = [UIColor whiteColor];
    self.oftenGameLabel.font = [UIFont ld_defaultFontOfSize:12];
    self.oftenGameLabel.textColor = [UIColor ld_colorWithHex:0x333333];
}

- (void)setContent:(id)model {
    self.oftenGameLabel.text = @"常玩游戏";
    NSMutableArray *item = (NSMutableArray *)model;
    if (item == nil) {
        return;
    }
    for (int i = 0; i < item.count; i++) {
        if (i < self.gameimageArr.count) {
            ((UIImageView *)(self.gameimageArr[i])).image = item[i];
        }
    }
}

@end
