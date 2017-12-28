//
//  UIButton+CLVCustom.m
//  Clover
//
//  Created by shen chen on 2017/12/27.
//  Copyright © 2017年 shenchen. All rights reserved.
//

#import "UIButton+CLVCustom.h"
#import "UIImage+LDAlpha.h"
#import "UIColor+LDAddition.h"

@implementation UIButton (CLVCustom)

+ (instancetype)clv_createButtonWithStyle:(CLVCustomButtonStyle )clvCustomButtonStyle
{
    return [UIButton clv_createButtonWithStype:clvCustomButtonStyle cornerRadius:2.0];
}

+ (instancetype)clv_createButtonWithStype:(CLVCustomButtonStyle )clvCustomButtonStyle cornerRadius:(CGFloat)cornerRaidus
{
    UIButton *customBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    CGFloat borderWidth = 1.0 / [UIScreen mainScreen].scale;
    switch (clvCustomButtonStyle) {
        case CLVCustomButtonDefaultStyle:
            break;
        case CLVCustomButtonRBgWTxtStyle:
            [customBtn setBackgroundColor:[UIColor ld_colorWithHex:0xF75147]  cornerRadius:cornerRaidus borderColor:[UIColor ld_colorWithHex:0xF75147] borderWidth:borderWidth forState:UIControlStateNormal];
            [customBtn setTitleColor:[UIColor ld_colorWithHex:0xFFFFFF] forState:UIControlStateNormal];
            
            [customBtn setBackgroundColor:[UIColor ld_colorWithHex:0xDA392F]  cornerRadius:cornerRaidus borderColor:[UIColor ld_colorWithHex:0xDA392F] borderWidth:borderWidth forState:UIControlStateSelected];
            [customBtn setTitleColor:[UIColor ld_colorWithHex:0xEF877E] forState:UIControlStateSelected];
            
            [customBtn setBackgroundColor:[UIColor ld_colorWithHex:0xDA392F]  cornerRadius:cornerRaidus borderColor:[UIColor ld_colorWithHex:0xDA392F] borderWidth:borderWidth forState:UIControlStateHighlighted];
            [customBtn setTitleColor:[UIColor ld_colorWithHex:0xEF877E] forState:UIControlStateHighlighted];
            
            [customBtn setBackgroundColor:[UIColor ld_colorWithHex:0xCDCDCD] cornerRadius:cornerRaidus borderColor:[UIColor ld_colorWithHex:0xCDCDCD] borderWidth:borderWidth forState:UIControlStateDisabled];
            [customBtn setTitleColor:[UIColor ld_colorWithHex:0xffffff] forState:UIControlStateDisabled];
            
            break;
            
        case CLVCustomButtonBBgWTexStyle:
            [customBtn setBackgroundColor:[UIColor whiteColor]  cornerRadius:cornerRaidus borderColor:[UIColor whiteColor] borderWidth:borderWidth forState:UIControlStateNormal];
            [customBtn setTitleColor:[UIColor ld_colorWithHex:0xbebebe] forState:UIControlStateNormal];
            
            [customBtn setBackgroundColor:[UIColor blueColor]  cornerRadius:cornerRaidus borderColor:[UIColor blueColor] borderWidth:borderWidth forState:UIControlStateSelected];
            [customBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
            
            [customBtn setBackgroundColor:[UIColor blueColor]  cornerRadius:cornerRaidus borderColor:[UIColor blueColor] borderWidth:borderWidth forState:UIControlStateHighlighted];
            [customBtn setTitleColor:[UIColor ld_colorWithHex:0xffffff] forState:UIControlStateHighlighted];
            
            [customBtn setBackgroundColor:[UIColor ld_colorWithHex:0xCDCDCD] cornerRadius:cornerRaidus borderColor:[UIColor ld_colorWithHex:0xCDCDCD] borderWidth:borderWidth forState:UIControlStateDisabled];
            [customBtn setTitleColor:[UIColor ld_colorWithHex:0xffffff] forState:UIControlStateDisabled];
            
            break;
            
        default:
            break;
    }
    return customBtn;
}

- (void )setBackgroundColor:(UIColor *)backgroundColor  cornerRadius:(CGFloat)cornerRadius borderColor:(UIColor *)borderColor borderWidth:(CGFloat)borderWidth forState:(UIControlState)state
{
    UIImage *backgroundImg = [UIImage ld_imageWithBackgroundColor:backgroundColor  toSize:CGSizeMake(2*cornerRadius+1, 2*cornerRadius+1) cornerRadius:cornerRadius borderColor:borderColor borderWidth:borderWidth];
    UIImage * stretchedImage = [backgroundImg resizableImageWithCapInsets:UIEdgeInsetsMake(cornerRadius, cornerRadius, cornerRadius, cornerRadius) resizingMode:UIImageResizingModeStretch];
    [self setBackgroundImage:stretchedImage forState:state];
}

@end
