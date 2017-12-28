//
//  UIButton+LDAddition.m
//  LDKitDemo
//
//  Created by lixingdong on 16/8/5.
//  Copyright © 2016年 david. All rights reserved.
//

#import "UIButton+LDAddition.h"
#import <objc/runtime.h>

static const NSString *KEY_HIT_TEST_EDGE_INSETS = @"LDHitTestEdgeInsets";

@implementation UIButton (LDAddition)

@dynamic ld_hitTestEdgeInsets;

- (void)setLd_hitTestEdgeInsets:(UIEdgeInsets)ld_hitTestEdgeInsets
{
    NSValue *value = [NSValue value:&ld_hitTestEdgeInsets withObjCType:@encode(UIEdgeInsets)];
    objc_setAssociatedObject(self, &KEY_HIT_TEST_EDGE_INSETS, value, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIEdgeInsets)ld_hitTestEdgeInsets
{
    NSValue *value = objc_getAssociatedObject(self, &KEY_HIT_TEST_EDGE_INSETS);
    if(value) {
        UIEdgeInsets edgeInsets;
        [value getValue:&edgeInsets];
        
        return edgeInsets;
    } else {
        return UIEdgeInsetsZero;
    }
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    if(UIEdgeInsetsEqualToEdgeInsets(self.ld_hitTestEdgeInsets, UIEdgeInsetsZero) || !self.enabled || self.hidden) {
        return [super pointInside:point withEvent:event];
    }
    
    CGRect relativeFrame = self.bounds;
    CGRect hitFrame = UIEdgeInsetsInsetRect(relativeFrame, self.ld_hitTestEdgeInsets);
    
    return CGRectContainsPoint(hitFrame, point);
}

- (void)ld_setImageViewRight
{
    CGSize titleLabelSize = self.titleLabel.frame.size;
    if ([[UIDevice currentDevice].systemVersion doubleValue] >= 8.0) {
        titleLabelSize = self.titleLabel.intrinsicContentSize;
    }
    CGSize imageViewSize = self.imageView.frame.size;
    [self setImageEdgeInsets:UIEdgeInsetsMake(0, titleLabelSize.width, 0, -titleLabelSize.width)];
    [self setTitleEdgeInsets:UIEdgeInsetsMake(0, -imageViewSize.width, 0, imageViewSize.width)];
}

- (void)ld_setAllStateTitle:(NSString *)title
{
    [self setTitle:title forState:UIControlStateNormal];
    [self setTitle:title forState:UIControlStateHighlighted];
    [self setTitle:title forState:UIControlStateSelected];
    [self setTitle:title forState:UIControlStateDisabled];
}

- (void)ld_setAllStateImage:(UIImage *)image
{
    [self setImage:image forState:UIControlStateNormal];
    [self setImage:image forState:UIControlStateHighlighted];
    [self setImage:image forState:UIControlStateSelected];
    [self setImage:image forState:UIControlStateDisabled];
}

+ (UIButton *)ld_buttonWithImage:(UIImage *)image
                          target:(id)target
                          action:(SEL)selector
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setImage:image forState:UIControlStateNormal];
    [btn addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    
    CGSize imageSize = image.size;
    if (imageSize.width < 44) {
        imageSize.width = 44;
    }
    if (imageSize.height < 44) {
        imageSize.height = 44;
    }
    
    CGRect frame = btn.frame;
    frame.size = imageSize;
    btn.frame = frame;
    
    return btn;
}


@end
