//
//  KWAreaPickerView.h
//  Kiwifruit
//
//  Created by netease on 2017/9/19.
//  Copyright © 2017年 Kiwifruit. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

extern NSString * const KWAreaPickerViewWillShowNotification;
extern NSString * const KWAreaPickerViewWillHiddenNotification;
extern NSString * const KWAreaPickerViewFrameEndHeightInfoKey;

@class KWAreaPickerView, KWAddressDatabaseService;
@protocol KWAreaPickerViewDelegate <NSObject>
@optional

- (void)areaPicker:(KWAreaPickerView *)picker didSelectAddress:(NSString *)addrStr;

- (void)areaPicker:(KWAreaPickerView *)picker cancelWithOriginalAddress:(NSString *)addrStr;

- (void)areaPicker:(KWAreaPickerView *)picker confirmWithProvinceId:(NSString *)provinceId
            cityId:(NSString *)cityId
            areaId:(nullable NSString *)areaId;

@end

@interface KWAreaPickerView : UIView

@property (nonatomic, weak, nullable) id <KWAreaPickerViewDelegate> delegate;

- (void)setAddressWithProvinceId:(NSString *)provinceId
                          cityId:(NSString *)cityId
                          areaId:(nullable NSString *)areaId;

- (NSString *)currentAddrStr;

- (void)addToView:(UIView *)view animated:(BOOL)animated;

- (void)dismissWithAnimated:(BOOL)animated completion:(nullable void (^)(void))completion;

- (void)cancelDisplay;

@end

NS_ASSUME_NONNULL_END
