//
//  CLVAddPhotoView.m
//  Clover
//
//  Created by shen chen on 2017/12/28.
//  Copyright © 2017年 shenchen. All rights reserved.
//

#import "CLVAddPhotoView.h"
#import <Masonry.h>

@interface CLVAddPhotoView()

@property (nonatomic, strong) UIImageView *photoView;

@end

@implementation CLVAddPhotoView

- (instancetype)init {
    self = [super init];
    if (self) {
        [self addSubviews];
        [self setupLayout];
        [self setupStyle];
        UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewDidTapped:)];
        [self.photoView addGestureRecognizer:tapGes];
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
}

- (void)addSubviews {
    [self addSubview:self.photoView];
}
- (void)setupLayout {
    [self.photoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
}
- (void)setupStyle {
    self.backgroundColor = [UIColor whiteColor];
}
- (void)setContent:(id)model {
    UIImage *image = model;
    if (image) {
        self.photoView.image = image;
    }
}
- (void)viewDidTapped:(id)sender {
    NSLog(@"点击添加图片");
}

- (UIImageView *)photoView {
    if (_photoView == nil) {
        _photoView = [[UIImageView alloc] init];
    }
    return _photoView;
}

@end

#pragma mark - 默认的具体类
@interface CLVAddPhotoViewDefault()
@end

@implementation CLVAddPhotoViewDefault

- (instancetype)init {
    self = [super init];
    if (self) {
        
    }
    return self;
}

@end

