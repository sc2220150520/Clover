//
//  UIBarButtonItem+LDCustom.m
//  LDKit
//
//  Created by Anchor on 17/3/10.
//  Copyright © 2017年 LDKit. All rights reserved.
//

#import "UIBarButtonItem+LDCustom.h"

#define IOS7_BARITEM_HIGHLIGHTCOLOR [UIColor colorWithRed:0.80 green:0.34 blue:0.40 alpha:1.0]

@implementation UIBarButtonItem (LDCustom)

- (instancetype)initWithTitle:(NSString *)title target:(id)target action:(SEL)action
{
    return [self initWithTitle:title style:UIBarButtonItemStylePlain target:target action:action];
}

- (instancetype)initWithImage:(UIImage *)image target:(id)target action:(SEL)action
{
    return [self initWithImage:image style:UIBarButtonItemStylePlain target:target action:action];
}

- (instancetype)initWithImage:(UIImage *)image
               highlightImage:(UIImage *)highlightImage
                        title:(NSString *)title
                       target:(id)target
                       action:(SEL)action
{
    if (self = [self init]) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        UIFont *font = [UIFont systemFontOfSize:17];
        NSMutableParagraphStyle *style = [NSMutableParagraphStyle new];
        style.lineBreakMode = NSLineBreakByCharWrapping;
        CGSize titleSize = [title boundingRectWithSize:CGSizeMake(200, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:font,NSParagraphStyleAttributeName:style} context:nil].size;
        
        [button setImage:image forState:UIControlStateNormal];
        if (highlightImage) {
            [button setImage:highlightImage forState:UIControlStateHighlighted];
        }
        button.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
        button.titleLabel.font = font;
        [button setTitle:title forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button setTitleColor:IOS7_BARITEM_HIGHLIGHTCOLOR
                     forState:UIControlStateHighlighted];
        CGFloat add = image.size.width + 20;
        button.frame = CGRectMake(0, 0, titleSize.width + add, 29);
        
        self.customView = button;
        button.enabled = YES;
        [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (BOOL)ld_buttonEnable
{
    UIButton *button = (UIButton *) self.customView;
    return button.enabled;
}

- (void)ld_setButtonEnable:(BOOL)value
{
    UIButton *button = (UIButton *) self.customView;
    button.enabled = value;
}

@end
