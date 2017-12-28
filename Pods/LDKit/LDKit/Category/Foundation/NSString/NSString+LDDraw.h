//
//  NSString+LDDraw.h
//  LDKitDemo
//
//  Created by lixingdong on 16/8/5.
//  written by xuguoxing on 14-1-21.
//  Copyright © 2016年 david. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSString (LDDraw)

- (void)ld_drawInCenterOfRect:(CGRect)rect withFont:(UIFont *)font;

- (void)ld_drawInRect:(CGRect)rect withFont:(UIFont *)font lineBreakMode:(NSLineBreakMode)lineBreakMode alignment:(NSTextAlignment)alignment color:(UIColor *)color;

@end
