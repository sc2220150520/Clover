//
//  LDKWWebViewUtil.h
//  LDKWWebViewController
//
//  Created by lixingdong on 2017/10/19.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define  CONNECTION_TIMEOUT_SECS  30

#define isRetina ( ([[UIScreen mainScreen] scale] == 2) ? YES : NO)

#define IS_IPHONE_5 ([[UIScreen mainScreen] bounds].size.height ==568.0f)

#define IS_IOS7   ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)

#define IS_IOS8   ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)

@interface LDKWWebViewUtil : NSObject

+ (void)alertWithTitle:(NSString *)title message:(NSString *)message;

+ (BOOL)openURL:(NSURL *)url;

+ (BOOL)openURLString:(NSString *)urlString;

@end
