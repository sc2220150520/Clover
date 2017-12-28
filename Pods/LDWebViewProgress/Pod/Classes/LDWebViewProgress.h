//
//  LDWebViewProgress.h
//
//  Created by Satoshi Aasano on 4/20/13.
//  Copyright (c) 2013 Satoshi Asano. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#undef ld_weak
#if __has_feature(objc_arc_weak)
#define ld_weak weak
#else
#define ld_weak unsafe_unretained
#endif

extern const float LDInitialProgressValue;
extern const float LDInteractiveProgressValue;
extern const float LDFinalProgressValue;

typedef void (^LDWebViewProgressBlock)(float progress);
@protocol LDWebViewProgressDelegate;
@interface LDWebViewProgress : NSObject<UIWebViewDelegate>
@property (nonatomic, ld_weak) id<LDWebViewProgressDelegate>progressDelegate;
@property (nonatomic, ld_weak) id<UIWebViewDelegate>webViewProxyDelegate;
@property (nonatomic, copy) LDWebViewProgressBlock progressBlock;
@property (nonatomic, readonly) float progress; // 0.0..1.0

- (void)reset;
@end

@protocol LDWebViewProgressDelegate <NSObject>
- (void)webViewProgress:(LDWebViewProgress *)webViewProgress updateProgress:(float)progress;
@end

