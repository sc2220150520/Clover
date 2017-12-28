//
//  PopWebViewController.h
//  NeteaseLottery
//
//  Created by wangbo on 11-5-18.
//  Copyright 2011 netease. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * const kPopWebViewControllerWillAppear;
extern NSString * const kPopWebViewControllerWillDisAppear;
extern NSString * const kPopWebViewControllerWillClose;

@class PopWebViewController;

#pragma mark - PopWebViewControllerHookProtocol

@protocol PopWebViewControllerHookProtocol <NSObject>
@optional

- (BOOL)webController:(PopWebViewController *)controller shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType;

- (void)webControllerDidFinishLoad:(PopWebViewController *)controller;

- (void)webController:(PopWebViewController *)controller didFailLoadWithError:(NSError *)error;

@end


#pragma mark - PopWebViewControllerDelegate

@protocol PopWebViewControllerDelegate <NSObject>
@optional


- (void)controller:(PopWebViewController *)popController willDisappear:(BOOL)flag;

- (void)controller:(PopWebViewController *)popController didDisappear:(BOOL)flag;

@end


#pragma mark - PopWebViewController

@interface PopWebViewController : UIViewController <UIWebViewDelegate, UIActionSheetDelegate>
{
    
}

@property (nonatomic, weak) id <PopWebViewControllerDelegate> delegate;
@property (nonatomic, assign) BOOL hasToolBar;
@property (nonatomic, assign) BOOL clearBarButtonWhenLoadUrl;
@property (nonatomic, readonly, strong) UIWebView *webview;

//外部传入的urlString
@property (nonatomic, readonly, copy) NSString *originUrlString;

//当前的urlString
@property (nonatomic, readonly, copy) NSString *currentUrlString;

@property (nonatomic, copy) void(^customGoBackAction)(void);

@property (nonatomic, copy) void(^customCloseAction)(void);

/**
 *  [全局]设置PopWebViewController在主程序中的Hook，用于调用一些与主程序高耦合的功能
 */
+ (void)setHook:(id<PopWebViewControllerHookProtocol>)theHook;

/**
 *  存放业务需求数据，以便在hook中读取和使用
 */
- (void)setBusinessValue:(id)value forKey:(NSString *)key;

/**
 *  读取业务数据
 */
- (id)businessValueForKey:(NSString *)key;

/**
 *  初始化
 */
- (instancetype)initWithTitle:(NSString *)title;

/**
 *  从mainBundle中读取文件(不带路径)
 */
- (void)loadMainBundleFile:(NSString *)filename;

/**
 *  读取本地文件(带文件路径)
 */
- (void)loadLocalFile:(NSString *)filepath;

/**
 *  读取url
 */
- (void)loadURL:(NSURL *)url;

/**
 *  读取url，urlString为空则无效
 */
- (void)loadURLFromString:(NSString *)urlString;

/**
 *  为自己初始化一个NavigationController并返回
 */
- (UINavigationController *)parentNavController;

/**
 *  运行一段JavaScript代码，返回运行结果
 */
- (NSString *)runJavaScriptString:(NSString *)script;

/**
 *  关闭当前web页
 */
- (void)close;

@end


