//
//  UIFont+LDDefault.m
//  LDKit
//
//  Created by Anchor on 2017/6/8.
//  Take heart, young one. The Earth mother is near.
//

#import "UIFont+LDDefault.h"

static NSString *kDefaultFontName = nil;
static NSString *kReserveFontName = nil;
static NSString *const kDefaultFontNameKey = @"defaultFontName.lede.com";
static NSString *const kReserveFontNameKey = @"reserveFontName.lede.com";

@implementation UIFont (LDDefault)

+ (void)ld_setDefaultFont:(NSString *)fontName reserveFont:(NSString *)reserveFontName
{
    if (fontName.length > 0) {
        kDefaultFontName = fontName;
        [[NSUserDefaults standardUserDefaults] setObject:fontName forKey:kDefaultFontNameKey];
    } else {
        kDefaultFontName = nil;
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:kDefaultFontNameKey];
    }
    
    if (reserveFontName.length > 0) {
        kReserveFontName = reserveFontName;
        [[NSUserDefaults standardUserDefaults] setObject:reserveFontName forKey:kReserveFontNameKey];
    } else {
        kReserveFontName = nil;
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:kReserveFontNameKey];
    }
}

+ (UIFont *)ld_defaultFontOfSize:(CGFloat)size
{
    // fontWithName:nil size:size时返回font非空
    UIFont *font = [UIFont fontWithName:[UIFont ld_defaultFontName] size:size];
    if (font) {
        return font;
    } else {
        NSString *reserveName = [UIFont ld_reserveFontName];
        if (reserveName) {
            font = [UIFont fontWithName:reserveName size:size];
            if (font) return font;
        }
        return [UIFont systemFontOfSize:size];
    }
}

+ (NSString *)ld_defaultFontName
{
    if (kDefaultFontName) {
        return kDefaultFontName;
    } else {
        NSString *defaultName = [[NSUserDefaults standardUserDefaults] objectForKey:kDefaultFontNameKey];
        kDefaultFontName = defaultName ? : [UIFont systemFontOfSize:10.0].fontName;
        return kDefaultFontName;
    }
}

+ (nullable NSString *)ld_reserveFontName
{
    if (kReserveFontName) {
        return kReserveFontName;
    } else {
        NSString *reserveName = [[NSUserDefaults standardUserDefaults] objectForKey:kReserveFontNameKey];
        kReserveFontName = reserveName ? : nil;
        return kReserveFontName;
    }
}

@end
