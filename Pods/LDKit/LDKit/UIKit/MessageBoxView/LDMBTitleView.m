//
//  LDMBTitleView.m
//  LDKitDemo
//
//  Created by Yang Ning on 9/8/16.
//  Copyright © 2016 david. All rights reserved.
//

#import "LDMBTitleView.h"
#import "LDMBComponentProtocol.h"
#import "UIFont+LDDefault.h"

@interface LDMBTitleImageView : UIImageView

@end

@implementation LDMBTitleImageView

- (UIEdgeInsets)alignmentRectInsets
{
    return UIEdgeInsetsMake(0.0, 0.0, -10.0, 0.0);
}

@end

@interface LDMBTitleView () <LDMBComponentProtocol>

@property (nonatomic, strong) LDMBTitleImageView *imageView;
@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation LDMBTitleView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.translatesAutoresizingMaskIntoConstraints = NO;
        [self setup];
    }
    return self;
}

- (void)setup
{
    [self addSubview:self.imageView];
    [self addSubview:self.titleLabel];
    
    NSDictionary *views = NSDictionaryOfVariableBindings(_imageView, _titleLabel);
    
    [self addConstraints:[NSLayoutConstraint
                          constraintsWithVisualFormat:@"V:|[_imageView][_titleLabel]|"
                          options:NSLayoutFormatAlignAllCenterX
                          metrics:nil
                          views:views]];
    
    [self addConstraints:[NSLayoutConstraint
                          constraintsWithVisualFormat:@"H:|[_imageView]|"
                          options:0
                          metrics:nil
                          views:views]];
    
    [self addConstraints:[NSLayoutConstraint
                          constraintsWithVisualFormat:@"H:|[_titleLabel]|"
                          options:0
                          metrics:nil
                          views:views]];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.titleLabel.preferredMaxLayoutWidth = self.bounds.size.width;
    [super layoutSubviews];
}

#pragma mark - public method
- (void)setTitle:(NSString *)title
{
    _title = title;
    self.titleLabel.text = title;
}

- (void)setImage:(UIImage *)image
{
    _image = image;
    self.imageView.image = image;
}

#pragma mark - lazy init
- (LDMBTitleImageView *)imageView
{
    if (!_imageView) {
        _imageView = [[LDMBTitleImageView alloc] init];
        _imageView.translatesAutoresizingMaskIntoConstraints = NO;
        _imageView.contentMode = UIViewContentModeCenter;
    }
    return _imageView;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.font = [UIFont ld_defaultFontOfSize:17.0];
        _titleLabel.textColor = [UIColor colorWithRed:0x15 / 255.0 green:0x17 / 255.0 blue:0x1B / 255.0 alpha:1.0];
        _titleLabel.numberOfLines = 3;
    }
    return _titleLabel;
}

//- (CGSize)intrinsicContentSize
//{
//    CGSize size = self.imageView.intrinsicContentSize;
//    size.height += self.titleLabel.intrinsicContentSize.height;
//    size.width = MAX(size.height, self.titleLabel.intrinsicContentSize.height);
//    return size;
//}

#pragma mark - LDMBComponentProtocol
- (CGFloat)verticalMargin
{
    return 0.0;
}

- (LDMBComponentMarginPriority)marginPriority
{
    return LDMBComponentMarginPriorityDefaultLow;
}

@end
