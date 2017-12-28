//
//  LDMBButtonView.m
//  LDKitDemo
//
//  Created by Yang Ning on 9/9/16.
//  Copyright © 2016 LDKit. All rights reserved.
//

#import "LDMBButtonView.h"

@interface LDMBButtonView ()

@property (nonatomic, copy) NSString *confirmTitle;
@property (nonatomic, copy) NSString *cancelTitle;
@property (nonatomic) NSMutableArray *buttons;
@property (nonatomic, copy) LDMBButtonClikcedAction clickedActionBlock;

@end

@implementation LDMBButtonView

- (nonnull instancetype)initWithConfirmTitle:(nullable NSString *)confirmTitle
                                 cancelTitle:(nullable NSString *)cancelTitle
                               clickedAction:(LDMBButtonClikcedAction)action
{
    if (self = [super initWithFrame:CGRectZero]) {
        self.translatesAutoresizingMaskIntoConstraints = NO;
        
        self.backgroundColor = [UIColor clearColor];
        _confirmTitle = [confirmTitle copy];
        _cancelTitle = [cancelTitle copy];
        _clickedActionBlock = [action copy];
        [self setup];
    }
    return self;
}

- (void)setup
{
    NSMutableArray *titles = [[NSMutableArray alloc] initWithCapacity:2];

    if (_cancelTitle) {
        [titles addObject:_cancelTitle];
    }
    
    if (_confirmTitle) {
        [titles addObject:_confirmTitle];
    }
    
    UIView *preBtn = nil;
    UIView *preLine = nil;
    for (NSInteger i = 0; i < titles.count; ++i) {
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectZero];
        btn.backgroundColor = [UIColor clearColor];
        btn.translatesAutoresizingMaskIntoConstraints = NO;
        [btn setTitle:titles[i] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor colorWithRed:0x00 / 255.0 green:0x76 / 255.0 blue:0xFF / 255.0 alpha:1.0] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(dismissButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
        [self.buttons addObject:btn];
        
        if (preLine) {
            [self addConstraint:[NSLayoutConstraint constraintWithItem:btn
                                                             attribute:NSLayoutAttributeLeading
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:preLine
                                                             attribute:NSLayoutAttributeTrailing
                                                            multiplier:1.0
                                                              constant:0.0]];
        } else {
            [self addConstraint:[NSLayoutConstraint constraintWithItem:btn
                                                             attribute:NSLayoutAttributeLeading
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:self
                                                             attribute:NSLayoutAttributeLeading
                                                            multiplier:1.0
                                                              constant:0.0]];
        }
        
        [self addConstraint:[NSLayoutConstraint constraintWithItem:btn
                                                         attribute:NSLayoutAttributeTop
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:self
                                                         attribute:NSLayoutAttributeTop
                                                        multiplier:1.0
                                                          constant:0.0]];
        
        [self addConstraint:[NSLayoutConstraint constraintWithItem:btn
                                                         attribute:NSLayoutAttributeBottom
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:self
                                                         attribute:NSLayoutAttributeBottom
                                                        multiplier:1.0
                                                          constant:0.0]];
        
        if (preBtn) {
            [self addConstraint:[NSLayoutConstraint constraintWithItem:btn
                                                             attribute:NSLayoutAttributeWidth
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:preBtn
                                                             attribute:NSLayoutAttributeWidth
                                                            multiplier:1.0
                                                              constant:0.0]];
        }
        
        if (i == titles.count - 1) {
            [self addConstraint:[NSLayoutConstraint constraintWithItem:btn
                                                             attribute:NSLayoutAttributeTrailing
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:self
                                                             attribute:NSLayoutAttributeTrailing
                                                            multiplier:1.0
                                                              constant:0.0]];
        }
        
        preBtn = btn;
        
        if (i < titles.count - 1) {
            UIView *line = [[UIView alloc] initWithFrame:CGRectZero];
            line.backgroundColor = [UIColor blackColor];
            line.translatesAutoresizingMaskIntoConstraints = NO;
            line.backgroundColor = [UIColor colorWithRed:140 / 255.0 green:140 / 255.0 blue:140 / 255.0 alpha:1.0];
            [self addSubview:line];
            
            [self addConstraint:[NSLayoutConstraint constraintWithItem:line
                                                             attribute:NSLayoutAttributeLeading
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:btn
                                                             attribute:NSLayoutAttributeTrailing
                                                            multiplier:1.0
                                                              constant:1.0]];
            
            [self addConstraint:[NSLayoutConstraint constraintWithItem:line
                                                             attribute:NSLayoutAttributeTop
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:self
                                                             attribute:NSLayoutAttributeTop
                                                            multiplier:1.0
                                                              constant:0.0]];
            
            [self addConstraint:[NSLayoutConstraint constraintWithItem:line
                                                             attribute:NSLayoutAttributeBottom
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:self
                                                             attribute:NSLayoutAttributeBottom
                                                            multiplier:1.0
                                                              constant:0.0]];
            
            [self addConstraint:[NSLayoutConstraint constraintWithItem:line
                                                             attribute:NSLayoutAttributeWidth
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:nil
                                                             attribute:NSLayoutAttributeNotAnAttribute
                                                            multiplier:0.0
                                                              constant:1.0 / [UIScreen mainScreen].scale]];
            
            preLine = line;
        }
    }
    UIView *topLine = [[UIView alloc] initWithFrame:CGRectZero];
    topLine.backgroundColor = [UIColor blackColor];
    topLine.translatesAutoresizingMaskIntoConstraints = NO;
    topLine.backgroundColor = [UIColor colorWithRed:140 / 255.0 green:140 / 255.0 blue:140 / 255.0 alpha:1.0];
    [self addSubview:topLine];
    
    NSDictionary *viewsDic = NSDictionaryOfVariableBindings(topLine);
    NSDictionary *metrics = @{@"lineHeight":@(1.0 / [UIScreen mainScreen].scale)};
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[topLine]|" options:0 metrics:nil views:viewsDic]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[topLine(lineHeight)]" options:0 metrics:metrics views:viewsDic]];
    
}

#pragma mark - lazy init
- (NSMutableArray *)buttons
{
    if (!_buttons) {
        _buttons = [[NSMutableArray alloc] initWithCapacity:2];
    }
    return _buttons;
}

#pragma mark - button clicked
- (void)dismissButtonClicked:(id)sender
{
    UIButton *button = (UIButton *)sender;
    NSInteger i = [self.buttons indexOfObject:button];
    if (self.clickedActionBlock) {
        self.clickedActionBlock(i, [button titleForState:UIControlStateNormal]);
    }
}

@end
