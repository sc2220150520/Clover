//
//  UIView+LDFrame.h
//  LDKitDemo
//
//  Created by lixingdong on 16/8/8.
//  Copyright © 2016年 david. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (LDFrame)

@property(nonatomic, assign, getter=ld_getX, setter=ld_setX:) CGFloat x;
@property(nonatomic, assign, getter=ld_getX, setter=ld_setX:) CGFloat left;
@property(nonatomic, assign, getter=ld_getY, setter=ld_setY:) CGFloat y;
@property(nonatomic, assign, getter=ld_getY, setter=ld_setY:) CGFloat top;
@property(nonatomic, assign, getter=ld_getBottom, setter=ld_setBottom:) CGFloat bottom;
@property(nonatomic, assign, getter=ld_getRight, setter=ld_setRight:) CGFloat right;
@property(nonatomic, assign, getter=ld_getWidth, setter=ld_setWidth:) CGFloat width;
@property(nonatomic, assign, getter=ld_getHeight, setter=ld_setHeight:) CGFloat height;
@property(nonatomic, assign, getter=ld_getCenterX, setter=ld_setCenterX:) CGFloat centerX;
@property(nonatomic, assign, getter=ld_getCenterY, setter=ld_setCenterY:) CGFloat centerY;
@property(nonatomic, assign, getter=ld_getSize, setter=ld_setSize:) CGSize size;
@property(nonatomic, assign, getter=ld_getOrigin, setter=ld_setOrigin:) CGPoint origin;
@property(nonatomic, readonly, getter=ld_getBoundsCenter) CGPoint boundsCenter;

- (void)ld_setX:(CGFloat)x;

- (void)ld_setY:(CGFloat)y;

- (void)ld_setWidth:(CGFloat)width;

- (void)ld_setHeight:(CGFloat)height;

- (void)ld_setOrigin:(CGPoint)origin;

- (void)ld_setSize:(CGSize)size;

- (UIImage *)ld_snapshot;

@end
