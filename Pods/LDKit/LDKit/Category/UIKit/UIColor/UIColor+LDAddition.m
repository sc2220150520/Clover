//
//  UIColor+LDAddition.m
//  LDKitDemo
//
//  Created by lixingdong on 16/8/5.
//  Copyright © 2016年 david. All rights reserved.
//

#import "UIColor+LDAddition.h"

@implementation UIColor (LDAddition)

+ (UIColor *)ld_colorWithHexString:(NSString *)colorString
{
    return [UIColor ld_colorWithHexString:colorString alpha:1.0f];
}

+ (UIColor *)ld_colorWithHexString:(NSString *)colorString alpha:(CGFloat)alpha
{
    NSString *cString = [[colorString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) {
        return [UIColor clearColor];
    }
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"])
        cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];
    if ([cString length] != 6)
        return [UIColor clearColor];
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    
    //r
    NSString *rString = [cString substringWithRange:range];
    
    //g
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    //b
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f) green:((float) g / 255.0f) blue:((float) b / 255.0f) alpha:alpha];
}

+ (UIColor*)ld_colorWithHex:(NSInteger)hexValue alpha:(CGFloat)alphaValue
{
    return [UIColor colorWithRed:((float)((hexValue & 0xFF0000) >> 16))/255.0
                           green:((float)((hexValue & 0xFF00) >> 8))/255.0
                            blue:((float)(hexValue & 0xFF))/255.0 alpha:alphaValue];
}

+ (UIColor*)ld_colorWithHex:(NSInteger)hexValue
{
    return [UIColor ld_colorWithHex:hexValue alpha:1.0];
}


// Report model
- (CGColorSpaceModel)ld_colorSpaceModel
{
    return CGColorSpaceGetModel(CGColorGetColorSpace(self.CGColor));
}

// Supports either RGB or W
- (BOOL)ld_canProvideRGBComponents
{
    switch (self.ld_colorSpaceModel) {
        case kCGColorSpaceModelRGB:
        case kCGColorSpaceModelMonochrome:
            return YES;
        default:
            return NO;
    }
}

- (CGFloat)ld_luminance
{
    NSAssert(self.ld_canProvideRGBComponents, @"Must be a RGB color to use -luminance");
    
    CGFloat r, g, b;
    if (![self getRed: &r green: &g blue: &b alpha:NULL])
        return 0.0f;
    
    // http://en.wikipedia.org/wiki/Luma_(video)
    // Y = 0.2126 R + 0.7152 G + 0.0722 B
    return r * 0.2126f + g * 0.7152f + b * 0.0722f;
}

// Andrew Wooster https://github.com/wooster
- (UIColor *)ld_colorByInterpolatingToColor:(UIColor *)color byFraction:(CGFloat)fraction
{
    NSAssert(self.ld_canProvideRGBComponents, @"Self must be a RGB color to use arithmatic operations");
    NSAssert(color.ld_canProvideRGBComponents, @"Color must be a RGB color to use arithmatic operations");
    
    CGFloat r, g, b, a;
    if (![self getRed:&r green:&g blue:&b alpha:&a]) return nil;
    
    CGFloat r2,g2,b2,a2;
    if (![color getRed:&r2 green:&g2 blue:&b2 alpha:&a2]) return nil;
    
    CGFloat red = r + (fraction * (r2 - r));
    CGFloat green = g + (fraction * (g2 - g));
    CGFloat blue = b + (fraction * (b2 - b));
    CGFloat alpha = a + (fraction * (a2 - a));
    
    UIColor *new = [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
    return new;
}

// Pick a color that is likely to contrast well with this color
- (UIColor *)ld_contrastingColor
{
    return (self.ld_luminance > 0.5f) ? [UIColor colorWithRed:0 green:0 blue:0 alpha:1] : [UIColor colorWithRed:1 green:1 blue:1 alpha:1];
}

- (UIColor *)ld_intermediateColorWithEndColor:(UIColor *)endColor ratio:(CGFloat)ratio
{
    if (self == nil || endColor == nil) {
        return nil;
    }
    if (ratio < 0) {
        return self;
    } else if (ratio > 1.0) {
        return endColor;
    }
    
    CGFloat startRed, startGreen, startBlue, startAlpha;
    CGFloat endRed, endGreen, endBlue, endAlpha;
    [self getRed:&startRed green:&startGreen blue:&startBlue alpha:&startAlpha];
    [endColor getRed:&endRed green:&endGreen blue:&endBlue alpha:&endAlpha];
    CGFloat intermidiateRed, intermidiateGreen, intermidiateBlue, intermidiateAlpha;
    intermidiateRed = startRed + (endRed - startRed) * ratio;
    intermidiateGreen = startGreen + (endGreen - startGreen) * ratio;
    intermidiateBlue = startBlue + (endBlue - startBlue) * ratio;
    intermidiateAlpha = startAlpha + (endAlpha - startAlpha) * ratio;
    return [UIColor colorWithRed:intermidiateRed green:intermidiateGreen blue:intermidiateBlue alpha:intermidiateAlpha];
}


@end
