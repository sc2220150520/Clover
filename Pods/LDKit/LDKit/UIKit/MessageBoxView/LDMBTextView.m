//
//  LDMBTextView.m
//  LDKitDemo
//
//  Created by Yang Ning on 9/8/16.
//  Copyright © 2016 LDKit. All rights reserved.
//

#import "LDMBTextView.h"
#import "LDMBComponentProtocol.h"
#import "UIFont+LDDefault.h"

@interface LDMBTextView () <UITextViewDelegate, LDMBComponentProtocol>

@end

@implementation LDMBTextView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.translatesAutoresizingMaskIntoConstraints = NO;
        self.backgroundColor = [UIColor clearColor];
        self.textAlignment = NSTextAlignmentCenter;
        self.font = [UIFont ld_defaultFontOfSize:14.0];
        self.textColor = [UIColor colorWithRed:0x15 / 255.0 green:0x17 / 255.0 blue:0x1B / 255. alpha:1.0];
        self.textContainerInset = UIEdgeInsetsMake(0, 0, 0, 0);
        self.editable = YES;
        self.delegate = self;
        [self setContentCompressionResistancePriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisVertical];
    }
    return self;
}

- (void)setText:(NSString *)text
{
    [super setText:text];
    [self invalidateIntrinsicContentSize];
}

- (void)setPreferredMaxLayoutWidth:(CGFloat)preferredMaxLayoutWidth
{
    if (_preferredMaxLayoutWidth != preferredMaxLayoutWidth) {
        _preferredMaxLayoutWidth = preferredMaxLayoutWidth;
        [self invalidateIntrinsicContentSize];
    }
}

- (CGSize)intrinsicContentSize
{
    CGFloat preferredMaxLayoutWidth = self.preferredMaxLayoutWidth > 0 ? : 230;
//    return CGSizeMake(preferredMaxLayoutWidth, self.contentSize.height > 0 ? self.contentSize.height + 10 : self.contentSize.height);
    return CGSizeMake(preferredMaxLayoutWidth, self.contentSize.height > 0 ? self.contentSize.height : self.contentSize.height);

}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (!CGSizeEqualToSize(self.bounds.size, [self intrinsicContentSize])) {
        [self invalidateIntrinsicContentSize];
    }
}

#pragma mark - UITextViewDelegate
-(BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    return NO;
}

#pragma mark - LDMBComponentProtocol
- (CGFloat)verticalMargin
{
    return 10.0;
}

- (LDMBComponentMarginPriority)marginPriority
{
    return LDMBComponentMarginPriorityDefaultLow;
}

@end
