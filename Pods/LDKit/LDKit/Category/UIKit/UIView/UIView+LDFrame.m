//
//  UIView+LDFrame.m
//  LDKitDemo
//
//  Created by lixingdong on 16/8/8.
//  Copyright © 2016年 david. All rights reserved.
//

#import "UIView+LDFrame.h"

@implementation UIView (LDFrame)

- (void)ld_setX:(CGFloat)x
{
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}


- (void)ld_setY:(CGFloat)y
{
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

- (void)ld_setWidth:(CGFloat)width
{
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

- (void)ld_setHeight:(CGFloat)height
{
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

- (void)ld_setOrigin:(CGPoint)origin
{
    CGRect frame = self.frame;
    frame.origin = origin;
    [self setFrame:frame];
}

- (void)ld_setSize:(CGSize)size
{
    CGRect frame = self.frame;
    frame.size = size;
    [self setFrame:frame];
}

- (void)ld_setBottom:(CGFloat)bottom
{
    CGRect frame = self.frame;
    frame.origin.y = bottom - frame.size.height;
    self.frame = frame;
}

- (void)ld_setRight:(CGFloat)right
{
    CGRect frame = self.frame;
    frame.origin.x = right - frame.size.width;
    self.frame = frame;
}

- (void)ld_setCenterX:(CGFloat)centerX
{
    self.center = CGPointMake(centerX, self.center.y);
}

- (void)ld_setCenterY:(CGFloat)centerY
{
    self.center = CGPointMake(self.center.x, centerY);
}

- (CGFloat)ld_getX
{
    return self.frame.origin.x;
}

- (CGFloat)ld_getY
{
    return self.frame.origin.y;
}

- (CGFloat)ld_getBottom
{
    return self.frame.origin.y + self.frame.size.height;
}

- (CGFloat)ld_getRight
{
    return self.frame.origin.x + self.frame.size.width;
}

- (CGFloat)ld_getWidth
{
    return self.frame.size.width;
}

- (CGFloat)ld_getHeight
{
    return self.frame.size.height;
}

- (CGPoint)ld_getOrigin
{
    return self.frame.origin;
}

- (CGSize)ld_getSize
{
    return self.frame.size;
}

- (CGFloat)ld_getCenterX
{
    return self.center.x;
}

- (CGFloat)ld_getCenterY
{
    return self.center.y;
}

- (CGPoint)ld_getBoundsCenter
{
    return CGPointMake(self.width / 2, self.height / 2);
}

- (UIImage *)ld_snapshot
{
    CGSize imageSize = self.bounds.size;
    UIGraphicsBeginImageContextWithOptions(imageSize, NO, 0);
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return viewImage;
}

@end
