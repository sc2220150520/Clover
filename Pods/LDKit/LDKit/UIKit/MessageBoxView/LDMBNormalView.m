//
//  LDMBNormalView.m
//  LDKitDemo
//
//  Created by Yang Ning on 9/9/16.
//  Copyright © 2016 LDKit. All rights reserved.
//

#import "LDMBNormalView.h"
#import "LDMBTitleView.h"
#import "LDMBTextView.h"
#import "LDMBTextFieldView.h"
#import "LDMBCheckboxView.h"
#import "LDMBHintView.h"
#import "LDMBHypelinkView.h"
#import "LDMBConstraintMaker.h"

@implementation LDMBNormalViewConstructor


@end

@interface LDMBNormalView () <LDMBContainerProtocal, LDMBHypelinkViewDelegate>

@property (nonatomic) LDMBTitleView *titleView;
@property (nonatomic) LDMBTextView *detailView;
@property (nullable, nonatomic, strong) LDMBCheckboxView *checkboxView;
@property (nullable, nonatomic, strong) LDMBTextFieldView *textField;

@end

@implementation LDMBNormalView

- (instancetype)initWithConstructor:(void(^)(LDMBNormalViewConstructor *attribute))block
{
    if (self = [super initWithFrame:CGRectZero]) {
        self.translatesAutoresizingMaskIntoConstraints = NO;
        _constructor = [[LDMBNormalViewConstructor alloc] init];
        if (block) {
            block(_constructor);
        }
        [self setup];
    }
    return self;
}

- (void)setup
{
    NSMutableArray *components = [[NSMutableArray alloc] init];
    
    if (self.constructor.title) {
        self.titleView = [[LDMBTitleView alloc] init];
        self.titleView.image = self.constructor.image;
        self.titleView.title = self.constructor.title;
        [self addSubview:self.titleView];
        [components addObject:self.titleView];
    }
    
    if (self.constructor.content) {
        self.detailView = [[LDMBTextView alloc] init];
        self.detailView.text = self.constructor.content;
        [self addSubview:self.detailView];
        [components addObject:self.detailView];
    }
    
    if (self.constructor.showTextField) {
        //展示输入框
        _textField = [[LDMBTextFieldView alloc] init];
//        textfield.delegate = self;
        _textField.placeHolderText = self.constructor.textFieldPlaceHolder;
        [self addSubview:_textField];
        [components addObject:_textField];
    }
    
    if (self.constructor.showCheck && self.constructor.hintText.length > 0) {
        //勾选框和提示view
        self.checkboxView = [[LDMBCheckboxView alloc] init];
        self.checkboxView.hintText = self.constructor.hintText;
        self.checkboxView.checkEnable = self.constructor.checkEnable;
        [self addSubview:self.checkboxView];
        [components addObject:self.checkboxView];
    } else if (self.constructor.showHypelink && self.constructor.linkText.length > 0) {
        //超链接view
        LDMBHypelinkView *hypelink = [[LDMBHypelinkView alloc] init];
        hypelink.delegate = self;
        hypelink.hypelinkText = self.constructor.linkText;
        [self addSubview:hypelink];
        [components addObject:hypelink];
    } else if (!self.constructor.showCheck && !self.constructor.showHypelink && self.constructor.hintText.length > 0) {
        //普通的提示view
        LDMBHintView *hintView = [[LDMBHintView alloc] init];
        hintView.hintText = self.constructor.hintText;
        [self addSubview:hintView];
        [components addObject:hintView];
    }
    
    [LDMBConstraintMaker setupConstrainsWithContainer:self components:components];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
}

#pragma mark - public method
- (BOOL)checkBoxEnable
{
    if (self.constructor.showCheck) {
        return self.checkboxView.checkEnable;
    } else {
        return NO;
    }
}

- (NSString *)textFieldText
{
    if (self.constructor.showTextField) {
        return self.textField.text;
    } else {
        return nil;
    }
}

- (UIView *)weakTextField
{
    if (self.textField && self.textField.superview) {
        __weak typeof(LDMBTextFieldView *) weakTextField = self.textField;
        return weakTextField;
    } else {
        return nil;
    }
}

#pragma mark - LDMBContainerProtocal
- (CGFloat)verticalMargin
{
    return 20.0;
}

- (CGFloat)horizontalMargin
{
    return 20.0;
}

- (LDMBComponentMarginPriority)marginPriority
{
    return LDMBComponentMarginPriorityDefaultLow;
}

#pragma mark - LDMBHypelinkViewDelegate
- (void)mbHypelinkClicked:(LDMBHypelinkView *)hypelinkView
{
    if (self.constructor.linkBlock) {
        self.constructor.linkBlock();
    }
}

@end
