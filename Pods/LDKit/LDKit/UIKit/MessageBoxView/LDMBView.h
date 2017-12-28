//
//  LDMBView.h
//  LDKitDemo
//
//  Created by Yang Ning on 9/8/16.
//  Copyright © 2016 LDKit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LDMBNormalView.h"
#import "UIView+LDCPPopupLayoutSubViewAnimated.h"

@class LDMBView;
typedef void(^LDMBDissmissBlock)(LDMBView * _Nonnull mbView, NSUInteger index,  NSString * _Nonnull dismissButtonTitle, BOOL showCheck, BOOL checkEnable, BOOL showTextField, NSString * _Nullable text);

NS_ASSUME_NONNULL_BEGIN
@interface LDMBView : UIView

- (nonnull instancetype)initWithNormalView:(nonnull LDMBNormalView *)normalView
                              confirmTitle:(nullable NSString *)confirmTitle
                               cancelTitle:(nullable NSString *)cancelTitle
                                 onDismiss:(nullable LDMBDissmissBlock)dismissBlock NS_DESIGNATED_INITIALIZER;

- (instancetype)initWithFrame:(CGRect)frame NS_UNAVAILABLE;
- (instancetype)initWithCoder:(NSCoder *)aDecoder NS_UNAVAILABLE;

- (void)show;

- (void)animateShowWithBeginPosition:(LDCPAnimationVerticalPositionType)beginPosition
                  andDismissPosition:(LDCPAnimationVerticalPositionType)dismissPosition;

@end
NS_ASSUME_NONNULL_END
