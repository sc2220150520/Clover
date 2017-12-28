//
//  LDKWWebViewUtil.m
//  LDKWWebViewController
//
//  Created by lixingdong on 2017/10/19.
//

#import "LDKWWebViewUtil.h"

#define kSafariAccessDenyTitle @"请允许浏览器访问"
#define kSafariAccessDenyMessage @"请在手机的 设置>通用>访问限制 中允许Safari访问后重试"

@implementation LDKWWebViewUtil

+ (void)alertWithTitle:(NSString *)title message:(NSString *)message
{
    if (([title length] == 0) && ([message length] == 0)) {
        message = @"网络不给力";
    }
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alertView show];
}

+ (BOOL)openURL:(NSURL *)url
{
    if (![[UIApplication sharedApplication] canOpenURL:url]) {
        [self alertWithTitle:kSafariAccessDenyTitle message:kSafariAccessDenyMessage];
        return NO;
    }
    
    //在iOS6以后,safari被禁用后canOpenURL仍返回YES,需要在这里重新判断下
    BOOL opened = [[UIApplication sharedApplication] openURL:url];
    if (!opened) {
        [self alertWithTitle:kSafariAccessDenyTitle message:kSafariAccessDenyMessage];
        return NO;
    }
    return YES;
}

+ (BOOL)openURLString:(NSString *)urlString
{
    if (urlString.length == 0) {
        return NO;
    }
    NSURL *url = [NSURL URLWithString:urlString];
    return [self openURL:url];
}

@end
