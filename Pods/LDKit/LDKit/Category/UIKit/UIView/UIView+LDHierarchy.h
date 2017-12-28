//
//  UIView+LDHierarchy.h
//  LDKitDemo
//
//  Created by lixingdong on 16/8/8.
//  written by Marin Todorov on 26/02/2010.
//  Copyright © 2016年 david. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (LDHierarchy)

- (UIViewController *)ld_detectParentController;

- (void)ld_popViewController;

- (NSUInteger)ld_getSubviewIndex;

- (void)ld_bringToFront;

- (void)ld_sentToBack;

- (void)ld_bringOneLevelUp;

- (void)ld_sendOneLevelDown;

- (BOOL)ld_isInFront;

- (BOOL)ld_isAtBack;

- (void)ld_swapDepthsWithView:(UIView*)swapView;

- (void)ld_removeAllSubviews;

@end
