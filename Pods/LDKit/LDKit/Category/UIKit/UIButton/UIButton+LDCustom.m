//
//  UIButton+LDCustom.m
//  LDKitDemo
//
//  Created by ITxiansheng on 2016/11/11.
//  Copyright © 2016年 LDKit. All rights reserved.
//

#import "UIButton+LDCustom.h"
#import "UIImage+LDAlpha.h"
#import "UIColor+LDAddition.h"
@implementation UIButton (LDCustom)

+ (instancetype )ld_createButtonWithStyle:(LDCustomButtonStyle )ldCustomButtonStyle {
    return [UIButton ld_createButtonWithStype:ldCustomButtonStyle cornerRadius:4.0];
}

+ (instancetype)ld_createButtonWithStype:(LDCustomButtonStyle )ldCustomButtonStyle cornerRadius:(CGFloat)cornerRaidus {
    UIButton *customBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    CGFloat borderWidth = 1.0 / [UIScreen mainScreen].scale;
    switch (ldCustomButtonStyle) {
        case LDCustomButtonDefaultStyle:
            break;
        case LDCustomButtonRBgWTxtStyle:
            [customBtn setBackgroundColor:[UIColor ld_colorWithHex:0xfa4545]  cornerRadius:cornerRaidus borderColor:[UIColor ld_colorWithHex:0xfa4545] borderWidth:borderWidth forState:UIControlStateNormal];
            [customBtn setTitleColor:[UIColor ld_colorWithHex:0xffffff] forState:UIControlStateNormal];
            
            [customBtn setBackgroundColor:[UIColor ld_colorWithHex:0xc63737]  cornerRadius:cornerRaidus borderColor:[UIColor ld_colorWithHex:0xc63737] borderWidth:borderWidth forState:UIControlStateSelected];
            [customBtn setTitleColor:[UIColor ld_colorWithHex:0xd55d5d] forState:UIControlStateSelected];
            
            [customBtn setBackgroundColor:[UIColor ld_colorWithHex:0xc63737]  cornerRadius:cornerRaidus borderColor:[UIColor ld_colorWithHex:0xc63737] borderWidth:borderWidth forState:UIControlStateHighlighted];
            [customBtn setTitleColor:[UIColor ld_colorWithHex:0xd55d5d] forState:UIControlStateHighlighted];
            
            [customBtn setBackgroundColor:[UIColor ld_colorWithHex:0xfa4545] cornerRadius:cornerRaidus borderColor:[UIColor ld_colorWithHex:0xfa4545] borderWidth:borderWidth forState:UIControlStateDisabled];
            [customBtn setTitleColor:[UIColor ld_colorWithHex:0xff9797] forState:UIControlStateDisabled];
            
            break;
            
        case LDCustomButtonWBgRTxtStyle:
            [customBtn setBackgroundColor:[UIColor ld_colorWithHex:0xffffff] cornerRadius:cornerRaidus borderColor:[UIColor ld_colorWithHex:0xfa4545] borderWidth:borderWidth forState:UIControlStateNormal];
            [customBtn setTitleColor:[UIColor ld_colorWithHex:0xfa4545] forState:UIControlStateNormal];
            
            [customBtn setBackgroundColor:[UIColor ld_colorWithHex:0xfa4545]  cornerRadius:cornerRaidus borderColor:[UIColor ld_colorWithHex:0xfa4545] borderWidth:borderWidth forState:UIControlStateSelected];
            [customBtn setTitleColor:[UIColor ld_colorWithHex:0xffffff] forState:UIControlStateSelected];
            
            [customBtn setBackgroundColor:[UIColor ld_colorWithHex:0xfa4545]  cornerRadius:cornerRaidus borderColor:[UIColor ld_colorWithHex:0xfa4545] borderWidth:borderWidth forState:UIControlStateHighlighted];
            [customBtn setTitleColor:[UIColor ld_colorWithHex:0xffffff] forState:UIControlStateHighlighted];
            
            [customBtn setBackgroundColor:[UIColor ld_colorWithHex:0xfa4545]  cornerRadius:cornerRaidus borderColor:[UIColor ld_colorWithHex:0xfa4545] borderWidth:borderWidth forState:UIControlStateDisabled];
            [customBtn setTitleColor:[UIColor ld_colorWithHex:0xff9797] forState:UIControlStateDisabled];
            break;
            
        case LDCustomButtonCBgRTxtStyle:
            [customBtn setBackgroundColor:[UIColor clearColor] cornerRadius:cornerRaidus borderColor:[UIColor ld_colorWithHex:0xfa4545] borderWidth:borderWidth forState:UIControlStateNormal];
            [customBtn setTitleColor:[UIColor ld_colorWithHex:0xfa4545] forState:UIControlStateNormal];
            
            [customBtn setBackgroundColor:[UIColor ld_colorWithHex:0xfa4545]  cornerRadius:cornerRaidus borderColor:[UIColor ld_colorWithHex:0xfa4545] borderWidth:borderWidth forState:UIControlStateSelected];
            [customBtn setTitleColor:[UIColor ld_colorWithHex:0xffffff] forState:UIControlStateSelected];
            
            [customBtn setBackgroundColor:[UIColor ld_colorWithHex:0xfa4545]  cornerRadius:cornerRaidus borderColor:[UIColor ld_colorWithHex:0xfa4545] borderWidth:borderWidth forState:UIControlStateHighlighted];
            [customBtn setTitleColor:[UIColor ld_colorWithHex:0xffffff] forState:UIControlStateHighlighted];
            
            [customBtn setBackgroundColor:[UIColor ld_colorWithHex:0xfa4545]  cornerRadius:cornerRaidus borderColor:[UIColor ld_colorWithHex:0xfa4545] borderWidth:borderWidth forState:UIControlStateDisabled];
            [customBtn setTitleColor:[UIColor ld_colorWithHex:0xff9797] forState:UIControlStateDisabled];
            break;
            
        default:
            break;
    }
    return customBtn;
}


- (void )setBackgroundColor:(UIColor *)backgroundColor  cornerRadius:(CGFloat)cornerRadius borderColor:(UIColor *)borderColor borderWidth:(CGFloat)borderWidth forState:(UIControlState)state {
    
    UIImage *backgroundImg = [UIImage ld_imageWithBackgroundColor:backgroundColor  toSize:CGSizeMake(2*cornerRadius+1, 2*cornerRadius+1) cornerRadius:cornerRadius borderColor:borderColor borderWidth:borderWidth];
    UIImage * stretchedImage = [backgroundImg resizableImageWithCapInsets:UIEdgeInsetsMake(cornerRadius, cornerRadius, cornerRadius, cornerRadius) resizingMode:UIImageResizingModeStretch];
    [self setBackgroundImage:stretchedImage forState:state];

}
@end
