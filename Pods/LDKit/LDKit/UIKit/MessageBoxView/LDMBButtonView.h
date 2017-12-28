//
//  LDMBButtonView.h
//  LDKitDemo
//
//  Created by Yang Ning on 9/9/16.
//  Copyright © 2016 LDKit. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^LDMBButtonClikcedAction)(NSInteger index, NSString *dismissButtonTitle);

@interface LDMBButtonView : UIView

- (nonnull instancetype)initWithConfirmTitle:(nullable NSString *)confirmTitle
                                 cancelTitle:(nullable NSString *)cancelTitle
                               clickedAction:(LDMBButtonClikcedAction)action NS_DESIGNATED_INITIALIZER;

- (instancetype)initWithFrame:(CGRect)frame NS_UNAVAILABLE;
- (instancetype)initWithCoder:(NSCoder *)aDecoder NS_UNAVAILABLE;

@end
NS_ASSUME_NONNULL_END
