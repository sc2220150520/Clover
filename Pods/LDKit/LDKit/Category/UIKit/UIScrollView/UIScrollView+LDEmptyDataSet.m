//
//  UIScrollView+LDEmptyDataSet.m
//  Pods
//
//  Created by wuxu on 10/21/2015.
//  Copyright (c) 2015 wuxu. All rights reserved.
//

#import "UIScrollView+LDEmptyDataSet.h"
#import <objc/runtime.h>

static NSInteger const ld_mainBgView_tag    = 92011;
static NSInteger const ld_titleLabel_tag    = 92012;
static NSInteger const ld_detailLabel_tag   = 92013;
static NSInteger const ld_indicatorView_tag = 92014;

static char const *const ld_reloadBlockKey       = "ld_reloadBlock";
static char const *const ld_gestureRecognizerKey = "ld_gestureRecognizerKey";

@implementation UIScrollView (LDEmptyDataSet)
@dynamic ld_titleFont;
@dynamic ld_titleColor;
@dynamic ld_detailFont;
@dynamic ld_detailColor;
@dynamic ld_wholeVerticalOffset;
@dynamic ld_wholeInsets;
@dynamic ld_imageToUnderGroupSpacing;
@dynamic ld_titleToUnderGroupSpacing;
@dynamic ld_detailToUnderGroupSpacing;

#pragma mark -

- (void)ld_setEmptyWithTitle:(NSString *)title
{
    [self ld_setEmptyWithView:nil title:title detail:nil reload:nil];
}
- (void)ld_setEmptyWithTitle:(NSString *)title reload:(void (^)(void))reload
{
    [self ld_setEmptyWithView:nil title:title detail:nil reload:reload];
}

- (void)ld_setEmptyWithImage:(UIImage *)image
{
    [self ld_setEmptyWithImage:image title:nil detail:nil reload:nil];
}
- (void)ld_setEmptyWithImage:(UIImage *)image reload:(void (^)(void))reload
{
    [self ld_setEmptyWithImage:image title:nil detail:nil reload:reload];
}

- (void)ld_setEmptyWithView:(UIView *)view
{
    [self ld_setEmptyWithView:view title:nil detail:nil reload:nil];
}
- (void)ld_setEmptyWithView:(UIView *)view reload:(void (^)(void))reload
{
    [self ld_setEmptyWithView:view title:nil detail:nil reload:reload];
}

- (void)ld_setEmptyWithTitle:(NSString *)title detail:(NSString *)detail
{
    [self ld_setEmptyWithView:nil title:title detail:detail reload:nil];
}
- (void)ld_setEmptyWithTitle:(NSString *)title detail:(NSString *)detail reload:(void (^)(void))reload
{
    [self ld_setEmptyWithView:nil title:title detail:detail reload:reload];
}

- (void)ld_setEmptyWithImage:(UIImage *)image title:(NSString *)title
{
    [self ld_setEmptyWithImage:image title:title detail:nil reload:nil];
}
- (void)ld_setEmptyWithImage:(UIImage *)image title:(NSString *)title reload:(void (^)(void))reload
{
    [self ld_setEmptyWithImage:image title:title detail:nil reload:reload];
}

- (void)ld_setEmptyWithImage:(UIImage *)image title:(NSString *)title detail:(NSString *)detail
{
    [self ld_setEmptyWithImage:image title:title detail:detail reload:nil];
}
- (void)ld_setEmptyWithImage:(UIImage *)image title:(NSString *)title detail:(NSString *)detail reload:(void (^)(void))reload
{
    if (image) {
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        imageView.frame = CGRectMake(0, 0, image.size.width, image.size.height);
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.backgroundColor = [UIColor clearColor];
        
        [self ld_setEmptyWithView:imageView title:title detail:detail reload:reload];
    } else {
        [self ld_setEmptyWithView:nil title:title detail:detail reload:reload];
    }
}

- (void)ld_setEmptyWithView:(UIView *)view title:(NSString *)title detail:(NSString *)detail
{
    [self ld_setEmptyWithView:view title:title detail:detail reload:nil];
}
- (void)ld_setEmptyWithView:(UIView *)view title:(NSString *)title detail:(NSString *)detail reload:(void (^)(void))reload
{
    [self ld_setEmptyWithView:view title:title detail:detail button:nil reload:reload];
}

- (void)ld_setEmptyWithButton:(UIButton *)button
{
    [self ld_setEmptyWithView:nil title:nil detail:nil button:button];
}
- (void)ld_setEmptyWithTitle:(NSString *)title button:(UIButton *)button
{
    [self ld_setEmptyWithView:nil title:title detail:nil button:button];
}
- (void)ld_setEmptyWithTitle:(NSString *)title detail:(NSString *)detail button:(UIButton *)button
{
    [self ld_setEmptyWithView:nil title:title detail:detail button:button];
}
- (void)ld_setEmptyWithImage:(UIImage *)image button:(UIButton *)button
{
    [self ld_setEmptyWithImage:image title:nil detail:nil button:button];
}
- (void)ld_setEmptyWithImage:(UIImage *)image title:(NSString *)title button:(UIButton *)button
{
    [self ld_setEmptyWithImage:image title:title detail:nil button:button];
}
- (void)ld_setEmptyWithImage:(UIImage *)image title:(NSString *)title detail:(NSString *)detail button:(UIButton *)button
{
    if (image) {
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        imageView.frame = CGRectMake(0, 0, image.size.width, image.size.height);
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.backgroundColor = [UIColor clearColor];
        
        [self ld_setEmptyWithView:imageView title:title detail:detail button:button];
    } else {
        [self ld_setEmptyWithView:nil title:title detail:detail button:button];
    }
}
- (void)ld_setEmptyWithView:(UIView *)view title:(NSString *)title detail:(NSString *)detail button:(UIButton *)button
{
    [self ld_setEmptyWithView:view title:title detail:detail button:button reload:nil];
}

#pragma mark -

- (void)ld_setEmptyWithAttributedTitle:(NSAttributedString *)title
{
    [self ld_setEmptyWithView:nil attributedTitle:title attributedDetail:nil reload:nil];
}
- (void)ld_setEmptyWithAttributedTitle:(NSAttributedString *)title reload:(void (^)(void))reload
{
    [self ld_setEmptyWithView:nil attributedTitle:title attributedDetail:nil reload:reload];
}

- (void)ld_setEmptyWithAttributedTitle:(NSAttributedString *)title attributedDetail:(NSAttributedString *)detail
{
    [self ld_setEmptyWithView:nil attributedTitle:title attributedDetail:detail reload:nil];
}
- (void)ld_setEmptyWithAttributedTitle:(NSAttributedString *)title attributedDetail:(NSAttributedString *)detail reload:(void (^)(void))reload
{
    [self ld_setEmptyWithView:nil attributedTitle:title attributedDetail:detail reload:reload];
}

- (void)ld_setEmptyWithImage:(UIImage *)image attributedTitle:(NSAttributedString *)title
{
    [self ld_setEmptyWithImage:image attributedTitle:title attributedDetail:nil reload:nil];
}
- (void)ld_setEmptyWithImage:(UIImage *)image attributedTitle:(NSAttributedString *)title reload:(void (^)(void))reload
{
    [self ld_setEmptyWithImage:image attributedTitle:title attributedDetail:nil reload:reload];
}

- (void)ld_setEmptyWithImage:(UIImage *)image attributedTitle:(NSAttributedString *)title attributedDetail:(NSAttributedString *)detail
{
    [self ld_setEmptyWithImage:image attributedTitle:title attributedDetail:detail reload:nil];
}
- (void)ld_setEmptyWithImage:(UIImage *)image attributedTitle:(NSAttributedString *)title attributedDetail:(NSAttributedString *)detail reload:(void (^)(void))reload
{
    if (image) {
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        imageView.frame = CGRectMake(0, 0, image.size.width, image.size.height);
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.backgroundColor = [UIColor clearColor];
        
        [self ld_setEmptyWithView:imageView attributedTitle:title attributedDetail:detail reload:reload];
    } else {
        [self ld_setEmptyWithView:nil attributedTitle:title attributedDetail:detail reload:reload];
    }
}

- (void)ld_setEmptyWithView:(UIView *)view attributedTitle:(NSAttributedString *)title attributedDetail:(NSAttributedString *)detail
{
    [self ld_setEmptyWithView:view attributedTitle:title attributedDetail:detail reload:nil];
}
- (void)ld_setEmptyWithView:(UIView *)view attributedTitle:(NSAttributedString *)title attributedDetail:(NSAttributedString *)detail reload:(void (^)(void))reload
{
    [self ld_setEmptyWithView:view attributedTitle:title attributedDetail:detail button:nil reload:reload];
}

- (void)ld_setEmptyWithAttributedTitle:(NSAttributedString *)title button:(UIButton *)button
{
    [self ld_setEmptyWithView:nil attributedTitle:nil attributedDetail:nil button:button];
}
- (void)ld_setEmptyWithAttributedTitle:(NSAttributedString *)title attributedDetail:(NSAttributedString *)detail button:(UIButton *)button
{
    [self ld_setEmptyWithView:nil attributedTitle:title attributedDetail:nil button:button];
}
- (void)ld_setEmptyWithImage:(UIImage *)image attributedTitle:(NSAttributedString *)title button:(UIButton *)button
{
    [self ld_setEmptyWithView:nil attributedTitle:title attributedDetail:nil button:button];
}
- (void)ld_setEmptyWithImage:(UIImage *)image attributedTitle:(NSAttributedString *)title attributedDetail:(NSAttributedString *)detail button:(UIButton *)button
{
    if (image) {
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        imageView.frame = CGRectMake(0, 0, image.size.width, image.size.height);
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.backgroundColor = [UIColor clearColor];
        
        [self ld_setEmptyWithView:imageView attributedTitle:title attributedDetail:detail button:button];
    } else {
        [self ld_setEmptyWithView:nil attributedTitle:title attributedDetail:detail button:button];
    }
}
- (void)ld_setEmptyWithView:(UIView *)view attributedTitle:(NSAttributedString *)title attributedDetail:(NSAttributedString *)detail button:(UIButton *)button
{
    [self ld_setEmptyWithView:view attributedTitle:title attributedDetail:detail button:button reload:nil];
}

#pragma mark -

- (BOOL)ld_startReload
{
    void(^block)() = objc_getAssociatedObject(self, ld_reloadBlockKey);
    if (block) {
        [self ld_retry:nil];
        return YES;
    }
    return NO;
}

- (void)ld_clearBackground
{
    UIView *mainBgView = [self viewWithTag:ld_mainBgView_tag];
    if (mainBgView) {
        [mainBgView removeFromSuperview];
    }
    
    UIActivityIndicatorView *activityView = (UIActivityIndicatorView *) [self viewWithTag:ld_indicatorView_tag];
    if (activityView) {
        [activityView stopAnimating];
        [activityView removeFromSuperview];
    }
    
    id block = objc_getAssociatedObject(self, ld_reloadBlockKey);
    if (block) {
        objc_setAssociatedObject(self, ld_reloadBlockKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    block = nil;
    
    UIGestureRecognizer *recognizer = objc_getAssociatedObject(self, ld_gestureRecognizerKey);
    if (recognizer) {
        [self removeGestureRecognizer:recognizer];
        objc_setAssociatedObject(self, ld_gestureRecognizerKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    recognizer = nil;
}

#pragma mark - retry

- (void)ld_retry:(UIGestureRecognizer *)gestureRecognizer
{
    void(^block)() = objc_getAssociatedObject(self, ld_reloadBlockKey);
    if (block) {
        UIView *mainBgView = [self viewWithTag:ld_mainBgView_tag];
        [mainBgView removeFromSuperview];
        UIActivityIndicatorView *activityView = (UIActivityIndicatorView *)[self viewWithTag:ld_indicatorView_tag];
        if (!activityView) {
            activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
            activityView.tag = ld_indicatorView_tag;
        }
        activityView.frame = CGRectMake((CGRectGetWidth(self.frame) - 30) / 2,(CGRectGetHeight(self.frame) - 30) / 2, 30, 30);
        [self addSubview:activityView];
        [activityView startAnimating];
        block();
    }
}

#pragma mark - private root method

- (void)ld_setEmptyWithView:(UIView *)view title:(NSString *)title detail:(NSString *)detail button:(UIButton *)button reload:(void (^)(void))reload
{
    [self ld_clearBackground];
    
    CGFloat height = 0;
    
    if (view) {
        height += CGRectGetHeight(view.frame);
        
        if (title.length > 0 || detail.length > 0 || button) {
            height += [self ld_imageToUnderGroupSpacing];
        }
    }
    
    CGSize titleTextSize;
    if (title.length > 0) {
        NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
        [style setLineBreakMode:NSLineBreakByWordWrapping];
        titleTextSize = [title boundingRectWithSize:CGSizeMake(CGRectGetWidth(self.frame), MAXFLOAT) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes: @{NSFontAttributeName:[self ld_titleFont], NSParagraphStyleAttributeName: style} context:nil].size;

        height += titleTextSize.height;
        
        if (detail.length > 0 || button) {
            height += [self ld_titleToUnderGroupSpacing];
        }
    }
    
    CGSize detailTextSize;
    if (detail.length > 0) {
        NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
        [style setLineBreakMode:NSLineBreakByWordWrapping];
        detailTextSize = [detail boundingRectWithSize:CGSizeMake(CGRectGetWidth(self.frame), MAXFLOAT) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes: @{NSFontAttributeName:[self ld_detailFont], NSParagraphStyleAttributeName: style} context:nil].size;
        
        height += detailTextSize.height;
        
        if (button) {
            height += [self ld_detailToUnderGroupSpacing];
        }
    }
    
    if (button) {
        height += CGRectGetHeight(button.frame);
    }
    
    UIView *mainBgView = [[UIView alloc] initWithFrame:CGRectMake([self ld_wholeInsets].left,
                                                                  (CGRectGetHeight(self.frame) - height)/2 + [self ld_wholeVerticalOffset],
                                                                  CGRectGetWidth(self.frame) - [self ld_wholeInsets].left - [self ld_wholeInsets].right,
                                                                  height)];
    mainBgView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth;
    mainBgView.backgroundColor = [UIColor clearColor];
    mainBgView.tag = ld_mainBgView_tag;
    [self addSubview:mainBgView];
    
    CGFloat y = 0;
    
    if (view) {
        view.frame = CGRectMake((CGRectGetWidth(mainBgView.frame) - CGRectGetWidth(view.frame))/2, y, CGRectGetWidth(view.frame), CGRectGetHeight(view.frame));
        view.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        [mainBgView addSubview:view];
        
        y += CGRectGetMaxY(view.frame);
        y += [self ld_imageToUnderGroupSpacing];
    }
    
    if (title.length > 0) {
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, y, CGRectGetWidth(mainBgView.frame), titleTextSize.height)];
        titleLabel.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth;
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.font = [self ld_titleFont];
        titleLabel.textColor = [self ld_titleColor];
        titleLabel.text = title;
        titleLabel.tag = ld_titleLabel_tag;
        titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        titleLabel.numberOfLines = 0;
        [mainBgView addSubview:titleLabel];
        
        y += CGRectGetMaxY(titleLabel.frame);
        y += [self ld_titleToUnderGroupSpacing];
    }
    
    if (detail.length > 0) {
        UILabel *detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, y, CGRectGetWidth(mainBgView.frame), detailTextSize.height)];
        detailLabel.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth;
        detailLabel.backgroundColor = [UIColor clearColor];
        detailLabel.textAlignment = NSTextAlignmentCenter;
        detailLabel.font = [self ld_detailFont];
        detailLabel.textColor = [self ld_detailColor];
        detailLabel.text = detail;
        detailLabel.tag = ld_detailLabel_tag;
        detailLabel.lineBreakMode = NSLineBreakByWordWrapping;
        detailLabel.numberOfLines = 0;
        [mainBgView addSubview:detailLabel];
        
        y += CGRectGetMaxY(detailLabel.frame);
        y += [self ld_detailToUnderGroupSpacing];
    }
    
    if (button) {
        button.frame = CGRectMake((CGRectGetWidth(mainBgView.frame) - CGRectGetWidth(button.frame))/2, y, CGRectGetWidth(button.frame), CGRectGetHeight(button.frame));
        [mainBgView addSubview:button];
    }
    
    if (reload) {
        objc_setAssociatedObject(self, ld_reloadBlockKey, reload, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ld_retry:)];
        tapRecognizer.cancelsTouchesInView = NO;
        [mainBgView addGestureRecognizer:tapRecognizer];
        objc_setAssociatedObject(self, ld_gestureRecognizerKey, tapRecognizer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
}

- (void)ld_setEmptyWithView:(UIView *)view attributedTitle:(NSAttributedString *)title attributedDetail:(NSAttributedString *)detail button:(UIButton *)button reload:(void (^)(void))reload
{
    [self ld_clearBackground];
    
    CGFloat height = 0;
    
    if (view) {
        height += CGRectGetHeight(view.frame);
        
        if (title.length > 0 || detail.length > 0) {
            height += [self ld_imageToUnderGroupSpacing];
        }
    }
    
    CGRect titleTextRect;
    if (title.length > 0) {
        titleTextRect = [title boundingRectWithSize:CGSizeMake(CGRectGetWidth(self.frame), MAXFLOAT)
                                            options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                            context:nil];
        height += titleTextRect.size.height;
        
        if (detail.length > 0) {
            height += [self ld_titleToUnderGroupSpacing];
        }
    }
    
    CGRect detailTextRect;
    if (detail.length > 0) {
        detailTextRect = [detail boundingRectWithSize:CGSizeMake(CGRectGetWidth(self.frame), MAXFLOAT)
                                              options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                              context:nil];
        height += detailTextRect.size.height;
    }
    
    UIView *mainBgView = [[UIView alloc] initWithFrame:CGRectMake([self ld_wholeInsets].left,
                                                                  (CGRectGetHeight(self.frame) - height)/2 + [self ld_wholeVerticalOffset],
                                                                  CGRectGetWidth(self.frame) - [self ld_wholeInsets].left - [self ld_wholeInsets].right,
                                                                  height)];
    mainBgView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth;
    mainBgView.backgroundColor = [UIColor clearColor];
    mainBgView.tag = ld_mainBgView_tag;
    [self addSubview:mainBgView];
    
    CGFloat y = 0;
    
    if (view) {
        view.frame = CGRectMake((CGRectGetWidth(mainBgView.frame) - CGRectGetWidth(view.frame))/2, y, CGRectGetWidth(view.frame), CGRectGetHeight(view.frame));
        view.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        [mainBgView addSubview:view];
        
        y += CGRectGetMaxY(view.frame);
        y += [self ld_imageToUnderGroupSpacing];
    }
    
    if (title.length > 0) {
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, y, CGRectGetWidth(mainBgView.frame), titleTextRect.size.height)];
        titleLabel.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth;
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.attributedText = title;
        titleLabel.tag = ld_titleLabel_tag;
        titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        titleLabel.numberOfLines = 0;
        [mainBgView addSubview:titleLabel];
        
        y += CGRectGetMaxY(titleLabel.frame);
        y += [self ld_titleToUnderGroupSpacing];
    }
    
    if (detail.length > 0) {
        UILabel *detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, y, CGRectGetWidth(mainBgView.frame), detailTextRect.size.height)];
        detailLabel.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth;
        detailLabel.backgroundColor = [UIColor clearColor];
        detailLabel.textAlignment = NSTextAlignmentCenter;
        detailLabel.attributedText = detail;
        detailLabel.tag = ld_detailLabel_tag;
        detailLabel.lineBreakMode = NSLineBreakByWordWrapping;
        detailLabel.numberOfLines = 0;
        [mainBgView addSubview:detailLabel];
        
        y += CGRectGetMaxY(detailLabel.frame);
        y += [self ld_detailToUnderGroupSpacing];
    }
    
    if (button) {
        button.frame = CGRectMake((CGRectGetWidth(mainBgView.frame) - CGRectGetWidth(button.frame))/2, y, CGRectGetWidth(button.frame), CGRectGetHeight(button.frame));
        [mainBgView addSubview:button];
    }
    
    if (reload) {
        objc_setAssociatedObject(self, ld_reloadBlockKey, reload, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ld_retry:)];
        tapRecognizer.cancelsTouchesInView = NO;
        [mainBgView addGestureRecognizer:tapRecognizer];
        objc_setAssociatedObject(self, ld_gestureRecognizerKey, tapRecognizer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
}

#pragma mark - Property Getter & Setter

- (UIColor *)ld_titleColor
{
    UIColor *color = objc_getAssociatedObject(self, @selector(ld_titleColor));
    
    if (color) {
        return objc_getAssociatedObject(self, @selector(ld_titleColor));
    } else {
        return [UIColor blackColor];
    }
}
- (void)setld_titleColor:(UIColor *)ld_titleColor
{
    objc_setAssociatedObject(self, @selector(ld_titleColor), ld_titleColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIFont *)ld_titleFont
{
    UIFont *font = objc_getAssociatedObject(self, @selector(ld_titleFont));
    
    if (font) {
        return objc_getAssociatedObject(self, @selector(ld_titleFont));
    } else {
        return [UIFont systemFontOfSize:18];
    }
}
- (void)setld_titleFont:(UIFont *)ld_titleFont
{
    objc_setAssociatedObject(self, @selector(ld_titleFont), ld_titleFont, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIColor *)ld_detailColor
{
    UIColor *color = objc_getAssociatedObject(self, @selector(ld_detailColor));
    
    if (color) {
        return objc_getAssociatedObject(self, @selector(ld_detailColor));
    } else {
        return [UIColor blackColor];
    }
}
- (void)setld_detailColor:(UIColor *)ld_detailColor
{
    objc_setAssociatedObject(self, @selector(ld_detailColor), ld_detailColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIFont *)ld_detailFont
{
    UIFont *font = objc_getAssociatedObject(self, @selector(ld_detailFont));
    
    if (font) {
        return objc_getAssociatedObject(self, @selector(ld_detailFont));
    } else {
        return [UIFont systemFontOfSize:14];
    }
}
- (void)setld_detailFont:(UIFont *)ld_detailFont
{
    objc_setAssociatedObject(self, @selector(ld_detailFont), ld_detailFont, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CGFloat)ld_wholeVerticalOffset
{
    NSNumber *number = objc_getAssociatedObject(self, @selector(ld_wholeVerticalOffset)) ;
    if (number) {
        return [number floatValue];
    } else {
        return 0.0f;
    }
}
- (void)setld_wholeVerticalOffset:(CGFloat)ld_wholeVerticalOffset
{
    objc_setAssociatedObject(self, @selector(ld_wholeVerticalOffset), @(ld_wholeVerticalOffset), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIEdgeInsets)ld_wholeInsets
{
    NSValue *valueObj = objc_getAssociatedObject(self, @selector(ld_wholeInsets));
    return [valueObj UIEdgeInsetsValue];
}
- (void)setld_wholeInsets:(UIEdgeInsets)ld_wholeInsets
{
    NSValue *valueObj = [NSValue valueWithUIEdgeInsets:ld_wholeInsets];
    objc_setAssociatedObject(self, @selector(ld_wholeInsets), valueObj, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CGFloat)ld_imageToUnderGroupSpacing
{
    NSNumber *number = objc_getAssociatedObject(self, @selector(ld_imageToUnderGroupSpacing)) ;
    if (number) {
        return [number floatValue];
    } else {
        return 0.0f;
    }
}
- (void)setld_imageToUnderGroupSpacing:(CGFloat)ld_imageToUnderGroupSpacing
{
    objc_setAssociatedObject(self, @selector(ld_imageToUnderGroupSpacing), @(ld_imageToUnderGroupSpacing), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CGFloat)ld_titleToUnderGroupSpacing
{
    NSNumber *number = objc_getAssociatedObject(self, @selector(ld_titleToUnderGroupSpacing)) ;
    if (number) {
        return [number floatValue];
    } else {
        return 0.0f;
    }
}
- (void)setld_titleToUnderGroupSpacing:(CGFloat)ld_titleToUnderGroupSpacing
{
    objc_setAssociatedObject(self, @selector(ld_titleToUnderGroupSpacing), @(ld_titleToUnderGroupSpacing), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CGFloat)ld_detailToUnderGroupSpacing
{
    NSNumber *number = objc_getAssociatedObject(self, @selector(ld_detailToUnderGroupSpacing)) ;
    if (number) {
        return [number floatValue];
    } else {
        return 0.0f;
    }
}
- (void)setld_detailToUnderGroupSpacing:(CGFloat)ld_detailToUnderGroupSpacing
{
    objc_setAssociatedObject(self, @selector(ld_detailToUnderGroupSpacing), @(ld_detailToUnderGroupSpacing), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
