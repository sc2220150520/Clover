//
//  UIImage+KWBundle.m
//  LDKWWebViewController
//
//  Created by lixingdong on 2017/10/19.
//

#import "UIImage+KWBundle.h"
#import "PopWebViewController.h"

@implementation UIImage (KWBundle)

+ (nullable UIImage *)ldKWWebView_imageNamed:(NSString *)name
{
    if ([UIImage respondsToSelector:@selector(imageNamed:inBundle:compatibleWithTraitCollection:)]) {
        static NSBundle *bundle;
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            bundle = [NSBundle bundleForClass:[PopWebViewController class]];
        });
        
        return [UIImage imageNamed:name inBundle:bundle compatibleWithTraitCollection:nil];
    } else {
        return [UIImage imageNamed:name];
    }
}

@end
