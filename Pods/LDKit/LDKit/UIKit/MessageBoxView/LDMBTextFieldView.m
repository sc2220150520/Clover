//
//  LDMBTextFieldView.m
//  LDKitDemo
//
//  Created by Yang Ning on 9/9/16.
//  Copyright © 2016 LDKit. All rights reserved.
//

#import "LDMBTextFieldView.h"
#import "LDMBComponentProtocol.h"
#import "UIFont+LDDefault.h"

@interface LDMBTextFieldView () <UITextFieldDelegate, LDMBComponentProtocol>

@property (nonatomic, strong) UITextField *textField;

@end

@implementation LDMBTextFieldView

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
    [self addSubview:self.textField];
    
    NSDictionary *views = NSDictionaryOfVariableBindings(_textField);
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_textField]|"
                                                                 options:NSLayoutFormatAlignAllCenterY
                                                                 metrics:nil
                                                                   views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_textField(34)]|"
                                                                 options:0
                                                                 metrics:nil
                                                                   views:views]];
}

#pragma mark - lazy init property
- (UITextField *)textField
{
    if (!_textField) {
        _textField = [[UITextField alloc] initWithFrame:CGRectZero];
        _textField.delegate = self;
        _textField.translatesAutoresizingMaskIntoConstraints = NO;
        _textField.backgroundColor = [UIColor clearColor];
        _textField.layer.cornerRadius = 5.0;
        _textField.layer.borderWidth = 1.0;
        _textField.layer.borderColor = [UIColor colorWithRed:140 / 255.0 green:140 / 255.0 blue:140 / 255.0 alpha:1.0].CGColor;
        _textField.layer.masksToBounds = YES;
        _textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _textField.leftViewMode = UITextFieldViewModeAlways;
        
        CGRect textFieldFrame = self.textField.frame;
        textFieldFrame.size.width = 7.0f;
        UIView *leftView = [[UIView alloc]initWithFrame:textFieldFrame];
        _textField.leftView = leftView;
    }
    return _textField;
}

#pragma mark - public method
- (void)setPlaceHolderText:(NSString *)placeHolderText
{
    if (_placeHolderText != placeHolderText) {
        self.textField.attributedPlaceholder =
        [[NSAttributedString alloc]
         initWithString:placeHolderText
         attributes:@{NSFontAttributeName:[UIFont ld_defaultFontOfSize:14.0],
                      NSBaselineOffsetAttributeName:@(-1.3)}];
    }
}

- (NSString *)text
{
    if (self.textField) {
        return self.textField.text;
    } else {
        return @"";
    }
}

#pragma mark - LDMBComponentProtocol
- (LDMBComponentMarginPriority)marginPriority
{
    return LDMBComponentMarginPriorityDefaultLow;
}

- (CGFloat)verticalMargin
{
    return 20;
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

@end
