//
//  CLVDatePickerView.h
//  Clover
//
//  Created by shen chen on 2018/1/2.
//  Copyright © 2018年 shenchen. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

extern NSString * const CLVDatePickerViewWillShowNotification;
extern NSString * const CLVDatePickerViewWillHiddenNotification;
extern NSString * const CLVDatePickerViewFrameEndHeightInfoKey;

@class CLVDatePickerView, CLVDateDatabaseService;

@protocol CLVDatePickerViewDelegate <NSObject>
@optional

- (void)datePicker:(CLVDatePickerView *)picker didSelectDate:(NSString *)dateStr;

- (void)datePicker:(CLVDatePickerView *)picker cancelWithOriginalDate:(NSString *)dateStr;

- (void)datePicker:(CLVDatePickerView *)picker confirmWithYear:(NSString *)Year
            Month:(NSString *)Month
            Day:(nullable NSString *)Day;

@end


@interface CLVDatePickerView : UIView

@property (nonatomic, weak, nullable) id <CLVDatePickerViewDelegate> delegate;

- (void)setDateWithYear:(NSString *)Year
                          Month:(NSString *)Month
                          Day:(nullable NSString *)Day;

- (NSString *)currentDateStr;

- (void)addToView:(UIView *)view animated:(BOOL)animated;

- (void)dismissWithAnimated:(BOOL)animated completion:(nullable void (^)(void))completion;

- (void)cancelDisplay;

@end

NS_ASSUME_NONNULL_END
