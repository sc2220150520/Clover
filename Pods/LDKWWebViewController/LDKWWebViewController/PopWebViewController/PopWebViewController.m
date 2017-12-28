//
//  PopWebViewController.m
//  NeteaseLottery
//
//  Created by wangbo on 11-5-18.
//  Copyright 2011 netease. All rights reserved.
//

#import "PopWebViewController.h"
#import "LDKWWebViewImages.h"
#import "LDKWWebViewUtil.h"
#import "UIBarButtonItem+LDCustom.h"
#import "UINavigationItem+LDAddition.h"
#import "WebViewJsonRPC.h" // JSBridge
#import "LDWebViewProgressView.h"
#import "LDWebViewProgress.h"
#import "UIFont+LDDefault.h"
#import "UIColor+LDAddition.h"
#import "UIViewController+LDAddition.h"
#import "UIImage+KWBundle.h"

//#define JSTest

NSString * const kPopWebViewControllerWillAppear    = @"PopWebViewControllerWillAppear";
NSString * const kPopWebViewControllerWillDisAppear = @"PopWebViewControllerWillDisAppear";
NSString * const kPopWebViewControllerWillClose     = @"kPopWebViewControllerWillClose";

static id <PopWebViewControllerHookProtocol> hook;

@interface PopWebViewController ()<LDWebViewProgressDelegate, UIGestureRecognizerDelegate>

@property (nonatomic, strong) UIWebView *webview;
@property (nonatomic, strong) UIImageView *toolbar;
@property (nonatomic, strong) UIButton *backItem;
@property (nonatomic, strong) UIButton *forwardItem;

@property (nonatomic, strong) UIScreenEdgePanGestureRecognizer *pw_edgePanRecognizer;

@property (nonatomic) NSURL *loginPendingUrl;
@property (nonatomic, strong) NSURL *cachedURL;//缓存过早load的url
@property (nonatomic, strong) UIActivityIndicatorView *indicatorViewInPop;
@property (nonatomic, strong) WebViewJsonRPC *jsBridge;
@property (nonatomic, strong) NSMutableDictionary *businessDict;//存放业务需求数据

//加载webview的进度条控制
@property (nonatomic, strong) LDWebViewProgressView *progressView;
@property (nonatomic, strong) LDWebViewProgress *progressProxy;

@property (nonatomic, copy) NSString *originUrlString;
@property (nonatomic, copy) NSString *currentUrlString;

@end


@implementation PopWebViewController

+ (void)setHook:(id<PopWebViewControllerHookProtocol>)theHook
{
    hook = theHook;
}


#pragma mark - LifeCycle

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    return [self initWithTitle:nil];
}

- (instancetype)initWithTitle:(NSString *)title
{
    if (self = [super initWithNibName:nil bundle:nil]) {
        self.hidesBottomBarWhenPushed = YES;
        self.title = title;
        _clearBarButtonWhenLoadUrl = YES;
        _hasToolBar = NO;
        _businessDict = [NSMutableDictionary dictionary];
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];

    [self.navigationItem ld_addLeftBarButtonItem:[self leftArrowButtonWithClose]];

#ifdef JSTest
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"登陆" style:UIBarButtonItemStyleBordered target:self action:@selector(testFunction)];
#endif
    
    self.webview = [[UIWebView alloc] initWithFrame:self.view.bounds];
    self.webview.backgroundColor = [UIColor colorWithRed:0xf4 / 255.0f green:0xf4 / 255.0f blue:0xf4 / 255.0f alpha:1.0f];
    self.webview.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    self.webview.scalesPageToFit = YES;
    [self.view addSubview:self.webview];
    
    self.jsBridge = [[WebViewJsonRPC alloc] init];
    [self.jsBridge connect:self.webview Controller:self];
    
    if (self.hasToolBar) {
        self.webview.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds) - 40);
        self.toolbar = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height - 44, CGRectGetWidth(self.view.bounds), 44)];
        self.toolbar.autoresizingMask = UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleWidth;
        self.toolbar.image = [LDKWWebViewImages ToolBarBackgroundImage];
        self.toolbar.userInteractionEnabled = YES;
        [self.view addSubview:self.toolbar];
        
        [self setToolbarView];
    }
    
    //加载webview的进度条
    _progressProxy = [[LDWebViewProgress alloc] init];
    self.webview.delegate = _progressProxy;
    _progressProxy.webViewProxyDelegate = self;
    _progressProxy.progressDelegate = self;
    
    CGFloat progressBarHeight = 3.f;
    CGRect navigaitonBarBounds = self.navigationController.navigationBar.bounds;
    CGRect barFrame = CGRectMake(0, navigaitonBarBounds.size.height, navigaitonBarBounds.size.width, progressBarHeight);
    _progressView = [[LDWebViewProgressView alloc] initWithFrame:barFrame];
    _progressView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    [_progressView setProgress:0];
    _progressView.progressBarView.backgroundColor = [UIColor colorWithRed:0xFF / 255.0f green:0x99 / 255.0f blue:0x00 / 255.0f alpha:1];//FF9900
    
    if (self.cachedURL) {//载入url缓存
        [self loadURL:self.cachedURL];
    }
    
    if (self.navigationController) {
        [self.view addGestureRecognizer:self.pw_edgePanRecognizer];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kPopWebViewControllerWillAppear object:nil];

    [self.navigationController.navigationBar addSubview:_progressView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleAppDidEnterBackgroundNotification:) name:UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleAppWillEnterForegroundNotification:) name:UIApplicationWillEnterForegroundNotification object:nil];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self onWebViewShow];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    // Remove progress view
    // because UINavigationBar is shared with other ViewControllers
    [_progressView removeFromSuperview];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kPopWebViewControllerWillDisAppear object:nil];
    
    if ([self.delegate respondsToSelector:@selector(controller:willDisappear:)]) {
        [self.delegate controller:self willDisappear:animated];
    }
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];

    [self onWebViewHidden];
    
    if ([self.delegate respondsToSelector:@selector(controller:didDisappear:)]) {
        [self.delegate controller:self didDisappear:animated];
    }
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)dealloc
{
    [self.jsBridge close];
    self.webview.delegate = nil;
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Test Function

- (void)testFunction
{
    [self.jsBridge jsEval:@";KiwiJsApi.account.login();"];
}

#pragma mark - Private Methods

- (void)onWebViewShow
{
    [self.jsBridge triggerEvent:@"onWebViewShow" withDetail:nil];
}

- (void)onWebViewHidden
{
    [self.jsBridge triggerEvent:@"onWebViewHidden" withDetail:nil];
}

- (void)closeButtonPressed:(id)sender
{
    if (self.customCloseAction) {
        self.customCloseAction();
        return;
    }
    
    [self close];
}

- (void)backWebview:(id)sender
{
    if (self.customGoBackAction) {
        self.customGoBackAction();
        return;
    }
    
    if ([self.webview canGoBack]) {
        [self.webview goBack];
    } else {
        [self closeButtonPressed:sender];
    }
}

- (void)setToolbarView
{
    self.backItem = [UIButton buttonWithType:UIButtonTypeCustom];
    self.backItem.frame = CGRectMake(10, 7, 27.5, 29.5);
    self.backItem.autoresizingMask = UIViewAutoresizingFlexibleRightMargin;
    [self.backItem setImage:[LDKWWebViewImages WebPrevImage] forState:UIControlStateNormal];
    [self.backItem setImage:[LDKWWebViewImages WebPrevPressedImage] forState:UIControlStateHighlighted];
    [self.backItem addTarget:self action:@selector(backButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.toolbar addSubview:self.backItem];
    
    self.forwardItem = [UIButton buttonWithType:UIButtonTypeCustom];
    self.forwardItem.frame = CGRectMake(CGRectGetWidth(self.toolbar.bounds) - 10 - 27.5, 7, 27.5, 29.5);
    self.forwardItem.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
    [self.forwardItem setImage:[LDKWWebViewImages WebNextImage] forState:UIControlStateNormal];
    [self.forwardItem setImage:[LDKWWebViewImages WebNextPressedImage] forState:UIControlStateHighlighted];
    [self.forwardItem addTarget:self action:@selector(forwardButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.toolbar addSubview:self.forwardItem];
}

- (UIBarButtonItem *)leftArrowButtonWithClose
{
    UIImage *image = nil;
    NSString *title = @"";
    UIBarButtonItem *leftBarItem = nil;
    
    //这里必须要用含title的方法，否则图标会紧贴在左边
    if ([UINavigationBar appearance].backIndicatorImage) {
        image = [UINavigationBar appearance].backIndicatorImage;
    } else {
        image = [UIImage ldKWWebView_imageNamed:@"LDKWWebViewController.bundle/NavChevronYYLG"];
    }
    leftBarItem = [[UIBarButtonItem alloc] initWithImage:image highlightImage:image title:title
                                                  target:self action:@selector(closeButtonPressed:)];
    
    return leftBarItem;
}

- (UIBarButtonItem *)leftArrowButtonWithBackWeb
{
    UIImage *image = nil;
    NSString *title = @"";
    UIBarButtonItem *leftBarItem = nil;

    image = [UIImage ldKWWebView_imageNamed:@"LDKWWebViewController.bundle/NavChevronYYLG"];
    //这里必须用含title的方法，否则返回图标会紧靠在左边
    leftBarItem = [[UIBarButtonItem alloc] initWithImage:image highlightImage:image title:title
                                                  target:self action:@selector(backWebview:)];

    return leftBarItem;
}

- (UIBarButtonItem *)leftCloseButton
{
    UIButton *leftCloseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    leftCloseBtn.frame = CGRectMake(0.0, 0.0, 40.0, 44.0);
    leftCloseBtn.backgroundColor = [UIColor clearColor];
    leftCloseBtn.titleLabel.font = [UIFont ld_defaultFontOfSize:16.0];
    [leftCloseBtn setTitle:@"关闭" forState:UIControlStateNormal];
    [leftCloseBtn setTitleColor:[UIColor ld_colorWithHex:0x333333]
              forState:UIControlStateNormal];
    [leftCloseBtn addTarget:self action:@selector(closeButtonPressed:)
           forControlEvents:UIControlEventTouchUpInside];

    return [[UIBarButtonItem alloc] initWithCustomView:leftCloseBtn];
}

- (void)createActityIndicatorViewInPop
{
    [self removeActityIndicatorViewInPop];
    _indicatorViewInPop = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    _indicatorViewInPop.center = CGPointMake(CGRectGetWidth(self.view.frame)/2, CGRectGetHeight(self.view.frame)/2);
    _indicatorViewInPop.hidesWhenStopped = YES;
    [self.view addSubview:_indicatorViewInPop];
    [_indicatorViewInPop startAnimating];
}

- (void)removeActityIndicatorViewInPop
{
    if (_indicatorViewInPop) {
        [_indicatorViewInPop stopAnimating];
        [_indicatorViewInPop removeFromSuperview];
        _indicatorViewInPop = nil;
    }
}

- (UIScreenEdgePanGestureRecognizer *)pw_edgePanRecognizer
{
    if (!_pw_edgePanRecognizer) {
        if (self.navigationController) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
            _pw_edgePanRecognizer = [[UIScreenEdgePanGestureRecognizer alloc]
                                     initWithTarget:self.navigationController.interactivePopGestureRecognizer.delegate
                                     action:@selector(handleNavigationTransition:)];
#pragma clang diagnostic pop
            _pw_edgePanRecognizer.delegate = self;
            _pw_edgePanRecognizer.edges = UIRectEdgeLeft;
        }
    }
    return _pw_edgePanRecognizer;
}


#pragma mark - Public Methods

- (void)loadMainBundleFile:(NSString *)filename
{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:filename ofType:nil];
    [self loadLocalFile:filePath];
}

- (void)loadLocalFile:(NSString *)filepath
{
    if (filepath == nil) {
        return;
    }
    [self loadURL:[NSURL fileURLWithPath:filepath]];
}

- (void)loadURLFromString:(NSString *)urlString
{
    if (urlString.length == 0) {
        return;
    }
    [self loadURL:[NSURL URLWithString:urlString]];
}

- (void)loadURL:(NSURL *)url
{
    if (self.isViewLoaded) { //如果view已经被load, 直接打开url, 并清除url缓存. 否则缓存url, 待viewDidLoad最后调用
        [self.webview loadRequest:[NSURLRequest requestWithURL:url]];
        if (self.cachedURL) {
            self.cachedURL = nil;
        }
        self.originUrlString = [url absoluteString];
    } else {
        self.cachedURL = url;
    }
}

- (UINavigationController *)parentNavController
{
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:self];
    return navController;
}

- (NSString *)runJavaScriptString:(NSString *)script
{
    return [self.webview stringByEvaluatingJavaScriptFromString:script];
}

- (void)setBusinessValue:(id)value forKey:(NSString *)key
{
    [self.businessDict setValue:value forKey:key];
}

- (id)businessValueForKey:(NSString *)key
{
    return self.businessDict[key];
}

- (void)close
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kPopWebViewControllerWillClose object:nil];
    
    if ([self ld_isModalStyle]) {
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - Actions

- (void)backButtonPressed:(id)sender
{
    [self.webview goBack];
}

- (void)forwardButtonPressed:(id)sender
{
    [self.webview goForward];
}

- (void)refreshButtonPressed:(id)sender
{
    [self.webview reload];
}

- (void)openButtonPressed:(id)sender
{
    UIActionSheet *acSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"使用Safari打开" otherButtonTitles:nil];
    [acSheet showInView:self.view];
}

#pragma mark Notification

- (void)handleAppDidEnterBackgroundNotification:(NSNotification *)notification
{
    [self onWebViewHidden];
}

- (void)handleAppWillEnterForegroundNotification:(NSNotification *)notification
{
    [self onWebViewShow];
}

#pragma mark - UIWebViewDelegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSLog(@"openurl:%@", request.URL.absoluteString);
    
    if (hook && [hook respondsToSelector:@selector(webController:shouldStartLoadWithRequest:navigationType:)]) {
        // 交由外部逻辑处理业务，若返回NO则直接返回，若返回YES则继续判断
        if (![hook webController:self shouldStartLoadWithRequest:request navigationType:navigationType]) {
            return NO;
        }
    }
    
    //展示加载中转转提示 圈圈的位置需要调节，在baseViewController或重写一个
    //modify by 张延晋  如果url中去掉#号和当前的url相同，为锚点定位，页面只会在本页内跳转，不会刷新，所以不弹出转框
    NSString *curAbsoluteString = self.webview.request.URL.absoluteString;
    NSString *purAbsoluteString = request.URL.absoluteString;
    NSRange curRange = [curAbsoluteString rangeOfString:@"#"];
    NSRange purRange = [purAbsoluteString rangeOfString:@"#"];
    NSString *curString = [curAbsoluteString substringToIndex:curRange.length ? curRange.location :  curAbsoluteString.length];
    NSString *purString = [purAbsoluteString substringToIndex:purRange.length ? purRange.location :  purAbsoluteString.length];
    
    if (![curString isEqualToString:purString]) {
        [self createActityIndicatorViewInPop];
    }
    
    return YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    self.currentUrlString = [webView.request.URL absoluteString];
    
    if (self.webview.canGoBack) {
        self.backItem.enabled = YES;
    } else {
        self.backItem.enabled = NO;
    }
    
    if (self.webview.canGoForward) {
        self.forwardItem.enabled = YES;
    } else {
        self.forwardItem.enabled = NO;
    }
    
    self.customGoBackAction = nil;
    self.customCloseAction = nil;
    
    //移除加载中转转提示
    [self removeActityIndicatorViewInPop];
    
    if ((self.navigationItem.leftBarButtonItems.count == 2 && ((UIBarButtonItem *)[self.navigationItem.leftBarButtonItems objectAtIndex:0]).width == -18) && self.webview.canGoBack) {
        NSMutableArray *tmpArray = [NSMutableArray array];
        UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        negativeSpacer.width = -18;
        [tmpArray addObject:negativeSpacer];
        [tmpArray addObject:[self leftArrowButtonWithBackWeb]];
        [tmpArray addObject:[self leftCloseButton]];
        [self.navigationItem setLeftBarButtonItems:tmpArray];
    } else if (self.navigationItem.leftBarButtonItems.count == 1 && self.webview.canGoBack) {
        NSMutableArray *tmpArray = [NSMutableArray array];
        [tmpArray addObject:[self leftArrowButtonWithBackWeb]];
        [tmpArray addObject:[self leftCloseButton]];
        [self.navigationItem setLeftBarButtonItems:tmpArray];
    }
    
    [self.jsBridge webReady];
    
    if (self.clearBarButtonWhenLoadUrl) {
        self.navigationItem.rightBarButtonItem = nil;
    }
    
    if (hook && [hook respondsToSelector:@selector(webControllerDidFinishLoad:)]) {
        [hook webControllerDidFinishLoad:self];
    }
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    //移除加载中转转提示
    [self removeActityIndicatorViewInPop];
    
    if (hook && [hook respondsToSelector:@selector(webController:didFailLoadWithError:)]) {
        [hook webController:self didFailLoadWithError:error];
    }
}


#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        [LDKWWebViewUtil openURL:[self.webview.request URL]];
    }
}


#pragma mark - WebViewJsonRPCProtocol

- (BOOL)isDebugMode
{
    return NO;
}

- (WebViewJsonRPCPermission)getPermission
{
    //权限，默认给WebViewJsonRPCPermissionTrustedPay
    //目前的检测app安装接口和openurl接口权限都为0
    return WebViewJsonRPCPermissionTrustedPay;
}


#pragma mark - LDWebViewProgressDelegate

- (void)webViewProgress:(LDWebViewProgress *)webViewProgress updateProgress:(float)progress
{
    [_progressView setProgress:progress animated:YES];
}


#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if (self.customGoBackAction) {
        self.customGoBackAction();
        return NO;
    } else {
        return YES;
    }
}

//UIWebView中可能会加载一些优先级很高的手势 此处需使pw_edgePanRecognizer能同时识别
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    if (gestureRecognizer == self.pw_edgePanRecognizer) {
        return YES;
    } else {
        return YES;
    }
}

@end
