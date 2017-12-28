//
//  LDMBCheckboxView.m
//  LDKitDemo
//
//  Created by Yang Ning on 9/8/16.
//  Copyright © 2016 LDKit. All rights reserved.
//

#import "LDMBCheckboxView.h"
#import "LDMBComponentProtocol.h"
#import "UIFont+LDDefault.h"

@interface LDMBCheckboxView () <LDMBComponentProtocol>

@property (nonatomic) UIImageView *imageView;
@property (nonatomic) UILabel *hintLabel;

@end

@implementation LDMBCheckboxView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        self.translatesAutoresizingMaskIntoConstraints = NO;
        [self setup];
    }
    return self;
}

- (void)setup
{
    [self addSubview:self.imageView];
    [self addSubview:self.hintLabel];
    
    CGSize imageSize = self.imageView.image.size;
    NSDictionary *metric = @{@"imageWidth" :@ (imageSize.width),
                             @"imageHeight" : @(imageSize.height)};
    NSDictionary *views = NSDictionaryOfVariableBindings(_imageView, _hintLabel);
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_imageView(imageWidth)]-5-[_hintLabel]|"
                                                                 options:NSLayoutFormatAlignAllCenterY
                                                                 metrics:metric
                                                                   views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_imageView(imageHeight)]"
                                                                 options:0
                                                                 metrics:metric
                                                                   views:views]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.imageView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0.0]];
}

#pragma mark - lazy init
- (UIImageView *)imageView
{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HYGCheckBoxUnSel"] highlightedImage:[UIImage imageNamed:@"HYGCheckBoxsel"]];
        _imageView.translatesAutoresizingMaskIntoConstraints = NO;
        _imageView.contentMode = UIViewContentModeCenter;
        _imageView.userInteractionEnabled = YES;
        _imageView.highlighted = NO;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(checkboxTapped:)];
        [_imageView addGestureRecognizer:tap];
    }
    return _imageView;
}

- (UILabel *)hintLabel
{
    if (!_hintLabel) {
        _hintLabel = [[UILabel alloc] init];
        _hintLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _hintLabel.textColor =  [UIColor colorWithRed:0x8E / 255.0 green:0x8E / 255.0 blue:0x8E / 255.0 alpha:1.0];
        _hintLabel.font = [UIFont ld_defaultFontOfSize:12.0];
        _hintLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _hintLabel;
}

#pragma mark - private method
- (void)checkboxTapped:(UIGestureRecognizer *)gesture
{
    self.imageView.highlighted = !self.imageView.highlighted;
}

- (CGSize)intrinsicContentSize
{
    CGSize size = self.imageView.intrinsicContentSize;
    size.width += (self.hintLabel.intrinsicContentSize.width + 5);
    size.height = self.hintLabel.intrinsicContentSize.height;
    
    if (size.height > 0) {
        size.height += 30.0;
    }
    
    return size;
}

//- (UIEdgeInsets)alignmentRectInsets
//{
//    return UIEdgeInsetsMake(-15.0, 0.0, -15.0, 0.0);
//}

#pragma mark - public
- (void)setHintText:(NSString *)hintText
{
    if (_hintText != hintText) {
        _hintText = [hintText copy];
        self.hintLabel.text = _hintText;
        [self invalidateIntrinsicContentSize];
    }
}

- (void)setCheckEnable:(BOOL)checkEnable
{
    self.imageView.highlighted = checkEnable;
}

- (BOOL)checkEnable
{
    return self.imageView.highlighted;
}

#pragma mark - LDMBComponentProtocol
- (CGFloat)verticalMargin
{
    return 0.0;
}

- (LDMBComponentMarginPriority)marginPriority
{
    return LDMBComponentMarginPriorityRequired;
}

@end
