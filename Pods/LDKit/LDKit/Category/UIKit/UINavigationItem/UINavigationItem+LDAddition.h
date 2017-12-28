//
//  UINavigationItem+LDAddition.h
//  LDKit
//
//  Created by Anchor on 17/3/9.
//  Copyright © 2017年 LDKit. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UINavigationItem (LDAddition)

- (void)ld_addLeftBarButtonItem:(UIBarButtonItem *)leftBarButtonItem;

- (void)ld_addRightBarButtonItem:(UIBarButtonItem *)rightBarButtonItem;

- (void)ld_addRightBarButtonItems:(NSArray *)rightBarButtonItems;

@end
