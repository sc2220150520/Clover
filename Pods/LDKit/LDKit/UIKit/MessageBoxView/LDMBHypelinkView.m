//
//  LDMBHypelinkView.m
//  LDKitDemo
//
//  Created by xuejiao fan on 11/7/16.
//  Copyright © 2016 LDKit. All rights reserved.
//

#import "LDMBHypelinkView.h"
#import "LDMBComponentProtocol.h"
#import "UIFont+LDDefault.h"

@interface LDMBHypelinkView () <LDMBComponentProtocol>

@property (nonatomic, strong) UIButton *hypelinkButton;

@end

@implementation LDMBHypelinkView

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
    [self addSubview:self.hypelinkButton];
    
    NSDictionary *views = NSDictionaryOfVariableBindings(_hypelinkButton);
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[_hypelinkButton]|"
                                                                 options:NSLayoutFormatAlignAllCenterY
                                                                 metrics:nil
                                                                   views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-10-[_hypelinkButton]-10-|"
                                                                 options:0
                                                                 metrics:nil
                                                                   views:views]];
}

#pragma mark - lazy init
- (UIButton *)hypelinkButton
{
    if (!_hypelinkButton) {
        _hypelinkButton = [UIButton new];
        _hypelinkButton.translatesAutoresizingMaskIntoConstraints = NO;
        _hypelinkButton.backgroundColor = [UIColor clearColor];
        [_hypelinkButton setTitleColor:[UIColor colorWithRed:0x00 / 255.0 green:0x76 / 255.0 blue:0xFF / 255.0 alpha:1.0] forState:UIControlStateNormal];
        _hypelinkButton.titleLabel.font = [UIFont ld_defaultFontOfSize:12.0];
        [_hypelinkButton addTarget:self action:@selector(hypelinkClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _hypelinkButton;
}

#pragma mark - private method
//- (UIEdgeInsets)alignmentRectInsets
//{
//    return UIEdgeInsetsMake(-10, 0, -10, 0);
//}

- (CGSize)intrinsicContentSize
{
    CGSize size;
    size.width += self.hypelinkButton.intrinsicContentSize.width + 9;
    size.height = self.hypelinkButton.intrinsicContentSize.height;
    
    if (size.height > 0) {
        size.height += 20.0;
    }
    
    return size;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
}

- (void)hypelinkClicked:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(mbHypelinkClicked:)]) {
        [self.delegate mbHypelinkClicked:self];
    }
}

#pragma mark - public method
- (void)setHypelinkText:(NSString *)hypelinkText
{
    if (_hypelinkText != hypelinkText) {
        _hypelinkText = [hypelinkText copy];
        [self.hypelinkButton setTitle:hypelinkText forState:UIControlStateNormal];
        [self.hypelinkButton setImage:[UIImage imageNamed:@"LDMessageBoxArrow"] forState:UIControlStateNormal];
        
        CGSize titleLabelSize = self.hypelinkButton.titleLabel.intrinsicContentSize;
        CGSize imageViewSize = CGSizeMake(5.0, 7.0);
        CGFloat spacingX = 4.0f;
        [self.hypelinkButton setImageEdgeInsets:UIEdgeInsetsMake(0, titleLabelSize.width + spacingX, 0, - titleLabelSize.width - spacingX)];
        [self.hypelinkButton setTitleEdgeInsets:UIEdgeInsetsMake(0, -imageViewSize.width, 0, imageViewSize.width)];
        
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
