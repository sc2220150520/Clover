//
//  NSString+LDDraw.m
//  LDKitDemo
//
//  Created by lixingdong on 16/8/5.
//  Copyright © 2016年 david. All rights reserved.
//

#import "NSString+LDDraw.h"

@implementation NSString (LDDraw)

- (void)ld_drawInCenterOfRect:(CGRect)rect withFont:(UIFont *)font
{
    CGSize size = [self sizeWithAttributes:@{NSFontAttributeName : font}];
    CGRect targetRect = {0};
    targetRect.size = size;
    targetRect.origin.x = rect.origin.x + (rect.size.width - size.width) / 2.0;
    targetRect.origin.y = rect.origin.y + (rect.size.height - size.height) / 2.0;
    
    [self drawInRect:targetRect withAttributes:@{NSFontAttributeName : font}];
}

- (void)ld_drawInRect:(CGRect)rect withFont:(UIFont *)font lineBreakMode:(NSLineBreakMode)lineBreakMode alignment:(NSTextAlignment)alignment color:(UIColor *)color
{
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.lineBreakMode = lineBreakMode;
    style.alignment = alignment;
    [self drawInRect:rect withAttributes:@{NSFontAttributeName : font,
                                           NSParagraphStyleAttributeName : style,
                                           NSForegroundColorAttributeName : color}];
}

@end
