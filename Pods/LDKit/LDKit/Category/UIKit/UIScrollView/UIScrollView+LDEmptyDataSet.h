//
//  UIScrollView+LDEmptyDataSet.h
//  Pods
//
//  Created by wuxu on 10/21/2015.
//  Copyright (c) 2015 wuxu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIScrollView (LDEmptyDataSet)

@property (nonatomic, strong) UIColor *ld_titleColor;    //default blackColor
@property (nonatomic, strong) UIFont  *ld_titleFont;     //default [UIFont systemFontOfSize:18]

@property (nonatomic, strong) UIColor *ld_detailColor;   //default blackColor
@property (nonatomic, strong) UIFont  *ld_detailFont;    //default [UIFont systemFontOfSize:14]

@property (nonatomic, assign) CGFloat ld_wholeVerticalOffset;  //default backView in UIScrollView center. -↑  +↓
@property (nonatomic, assign) UIEdgeInsets ld_wholeInsets;     //default zero. Just 'left' and 'right' is effective

@property (nonatomic, assign) CGFloat ld_imageToUnderGroupSpacing; //default 0
@property (nonatomic, assign) CGFloat ld_titleToUnderGroupSpacing; //default 0
@property (nonatomic, assign) CGFloat ld_detailToUnderGroupSpacing;//default 0

#pragma mark - NSString

- (void)ld_setEmptyWithTitle:(NSString *)title;
- (void)ld_setEmptyWithTitle:(NSString *)title reload:(void (^)(void))reload;

- (void)ld_setEmptyWithImage:(UIImage *)image;
- (void)ld_setEmptyWithImage:(UIImage *)image reload:(void (^)(void))reload;

- (void)ld_setEmptyWithView:(UIView *)view;
- (void)ld_setEmptyWithView:(UIView *)view reload:(void (^)(void))reload;

- (void)ld_setEmptyWithTitle:(NSString *)title detail:(NSString *)detail;
- (void)ld_setEmptyWithTitle:(NSString *)title detail:(NSString *)detail reload:(void (^)(void))reload;

- (void)ld_setEmptyWithImage:(UIImage *)image title:(NSString *)title;
- (void)ld_setEmptyWithImage:(UIImage *)image title:(NSString *)title reload:(void (^)(void))reload;

- (void)ld_setEmptyWithImage:(UIImage *)image title:(NSString *)title detail:(NSString *)detail;
- (void)ld_setEmptyWithImage:(UIImage *)image title:(NSString *)title detail:(NSString *)detail reload:(void (^)(void))reload;

- (void)ld_setEmptyWithView:(UIView *)view title:(NSString *)title detail:(NSString *)detail;
- (void)ld_setEmptyWithView:(UIView *)view title:(NSString *)title detail:(NSString *)detail reload:(void (^)(void))reload;

- (void)ld_setEmptyWithButton:(UIButton *)button;
- (void)ld_setEmptyWithTitle:(NSString *)title button:(UIButton *)button;
- (void)ld_setEmptyWithTitle:(NSString *)title detail:(NSString *)detail button:(UIButton *)button;
- (void)ld_setEmptyWithImage:(UIImage *)image button:(UIButton *)button;
- (void)ld_setEmptyWithImage:(UIImage *)image title:(NSString *)title button:(UIButton *)button;
- (void)ld_setEmptyWithImage:(UIImage *)image title:(NSString *)title detail:(NSString *)detail button:(UIButton *)button;
- (void)ld_setEmptyWithView:(UIView *)view title:(NSString *)title detail:(NSString *)detail button:(UIButton *)button;

#pragma mark - NSAttributedString

- (void)ld_setEmptyWithAttributedTitle:(NSAttributedString *)title;
- (void)ld_setEmptyWithAttributedTitle:(NSAttributedString *)title reload:(void (^)(void))reload;

- (void)ld_setEmptyWithAttributedTitle:(NSAttributedString *)title attributedDetail:(NSAttributedString *)detail;
- (void)ld_setEmptyWithAttributedTitle:(NSAttributedString *)title attributedDetail:(NSAttributedString *)detail reload:(void (^)(void))reload;

- (void)ld_setEmptyWithImage:(UIImage *)image attributedTitle:(NSAttributedString *)title;
- (void)ld_setEmptyWithImage:(UIImage *)image attributedTitle:(NSAttributedString *)title reload:(void (^)(void))reload;

- (void)ld_setEmptyWithImage:(UIImage *)image attributedTitle:(NSAttributedString *)title attributedDetail:(NSAttributedString *)detail;
- (void)ld_setEmptyWithImage:(UIImage *)image attributedTitle:(NSAttributedString *)title attributedDetail:(NSAttributedString *)detail reload:(void (^)(void))reload;

- (void)ld_setEmptyWithView:(UIView *)view attributedTitle:(NSAttributedString *)title attributedDetail:(NSAttributedString *)detail;
- (void)ld_setEmptyWithView:(UIView *)view attributedTitle:(NSAttributedString *)title attributedDetail:(NSAttributedString *)detail reload:(void (^)(void))reload;

- (void)ld_setEmptyWithAttributedTitle:(NSAttributedString *)title button:(UIButton *)button;
- (void)ld_setEmptyWithAttributedTitle:(NSAttributedString *)title attributedDetail:(NSAttributedString *)detail button:(UIButton *)button;
- (void)ld_setEmptyWithImage:(UIImage *)image attributedTitle:(NSAttributedString *)title button:(UIButton *)button;
- (void)ld_setEmptyWithImage:(UIImage *)image attributedTitle:(NSAttributedString *)title attributedDetail:(NSAttributedString *)detail button:(UIButton *)button;
- (void)ld_setEmptyWithView:(UIView *)view attributedTitle:(NSAttributedString *)title attributedDetail:(NSAttributedString *)detail button:(UIButton *)button;

#pragma mark - Other

- (BOOL)ld_startReload;

- (void)ld_clearBackground;

@end
