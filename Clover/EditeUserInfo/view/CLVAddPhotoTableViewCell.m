//
//  CLVAddPhotoTableViewCell.m
//  Clover
//
//  Created by shen chen on 2017/12/28.
//  Copyright © 2017年 shenchen. All rights reserved.
//

#import "CLVAddPhotoTableViewCell.h"
#import "CLVAddPhotoView.h"
#import <Masonry.h>

@implementation CLVAddPhotoTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self addSubviews];
        [self setupLayout];
        [self setupStyle];
    }
    return self;
}

- (void)addSubviews {}
- (void)setupLayout {}
- (void)setupStyle {}
- (void)setContent:(id)model {}

@end

#pragma mark - 编辑我的页资料的照片默认cell
@interface CLVAddPhotoTableViewCellDefault()
@property (nonatomic, strong) NSMutableArray *photoArray;
@end

@implementation CLVAddPhotoTableViewCellDefault

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
    }
    return self;
}

- (void)addSubviews {
    self.photoArray = [NSMutableArray array];
    for (int i = 0; i < 6; i++) {
        CLVAddPhotoView *imagView = [[CLVAddPhotoView alloc] init];
        [self.photoArray addObject:imagView];
        [self.contentView addSubview:imagView];
    }
}
- (void)setupLayout {
    if (self.photoArray.count >= 6) {
        NSArray *array = [NSArray arrayWithObjects:self.photoArray[3],self.photoArray[4],self.photoArray[5], nil];
        [array mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:5 leadSpacing:0 tailSpacing:0];
        [array mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(((UIView *)self.photoArray[0]).mas_bottom).offset(5);
            make.height.equalTo(((UIView *)self.photoArray[3]).mas_width);
            make.bottom.equalTo(self.contentView.mas_bottom);
        }];
        
        [((CLVAddPhotoView *)self.photoArray[1]) mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView).offset(5);
            make.right.equalTo(self.contentView);
            make.width.equalTo(((CLVAddPhotoView *)self.photoArray[3]));
            make.height.equalTo(((CLVAddPhotoView *)self.photoArray[3]));
        }];
        
        [((CLVAddPhotoView *)self.photoArray[2]) mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(((CLVAddPhotoView *)self.photoArray[1]).mas_bottom).offset(5);
            make.right.equalTo(self.contentView);
            make.width.equalTo(((CLVAddPhotoView *)self.photoArray[3]));
            make.height.equalTo(((CLVAddPhotoView *)self.photoArray[3]));
        }];
        
        [((CLVAddPhotoView *)self.photoArray[0]) mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView).offset(5);
            make.bottom.equalTo(((CLVAddPhotoView *)self.photoArray[2]));
            make.right.equalTo(((CLVAddPhotoView *)self.photoArray[1]).mas_left).offset(-5);
            make.left.equalTo(self.contentView);
        }];
        
    } else {
        return;
    }
}
- (void)setupStyle {
    self.contentView.backgroundColor = [UIColor ld_colorWithHex:0xf6f6f6];
}

@end
