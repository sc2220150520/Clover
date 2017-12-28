//
//  UIBarButtonItem+LDCustom.h
//  LDKit
//
//  Created by Anchor on 17/3/10.
//  Copyright © 2017年 LDKit. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (LDCustom)

- (instancetype)initWithTitle:(NSString *)title target:(id)target action:(SEL)action;

- (instancetype)initWithImage:(UIImage *)image target:(id)target action:(SEL)action;

- (instancetype)initWithImage:(UIImage *)image
               highlightImage:(UIImage *)highlightImage
                        title:(NSString *)title
                       target:(id)target
                       action:(SEL)action;

- (BOOL)ld_buttonEnable;

- (void)ld_setButtonEnable:(BOOL)value;

@end
