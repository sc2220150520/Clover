//
//  LDMBHintView.m
//  LDKitDemo
//
//  Created by xuejiao fan on 11/7/16.
//  Copyright © 2016 LDKit. All rights reserved.
//

#import "LDMBHintView.h"
#import "LDMBComponentProtocol.h"
#import "UIFont+LDDefault.h"

@interface LDMBHintView () <LDMBComponentProtocol>

@property (nonatomic) UILabel *hintLabel;

@end

@implementation LDMBHintView

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
    [self addSubview:self.hintLabel];
    
    NSDictionary *views = NSDictionaryOfVariableBindings(_hintLabel);
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_hintLabel]|"
                                                                 options:NSLayoutFormatAlignAllCenterY
                                                                 metrics:nil
                                                                   views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_hintLabel]|"
                                                                 options:0
                                                                 metrics:nil
                                                                   views:views]];
}

#pragma mark - lazy init
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
//- (UIEdgeInsets)alignmentRectInsets
//{
//    return UIEdgeInsetsMake(-10, 0, -10, 0);
//}

- (CGSize)intrinsicContentSize
{
    CGSize size;
    size.width += self.hintLabel.intrinsicContentSize.width;
    size.height = self.hintLabel.intrinsicContentSize.height;
    
    if (size.height > 0) {
        size.height += 20.0;
    }
    
    return size;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
}

#pragma mark - public method
- (void)setHintText:(NSString *)hintText
{
    if (_hintText != hintText) {
        _hintText = [hintText copy];
        self.hintLabel.text = hintText;
        [self invalidateIntrinsicContentSize];
    }
}

#pragma mark - LDMBComponentProtocol
- (LDMBComponentMarginPriority)marginPriority
{
    return LDMBComponentMarginPriorityDefaultHigh;
}

- (CGFloat)verticalMargin
{
    return 0;
}

@end
