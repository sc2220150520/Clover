//
//  CLVDatePickerView.m
//  Clover
//
//  Created by shen chen on 2018/1/2.
//  Copyright © 2018年 shenchen. All rights reserved.
//

#import "CLVDatePickerView.h"
#import "CLVDateDatabaseService.h"
#import "UIColor+LDAddition.h"

NSString * const CLVDatePickerViewWillShowNotification = @"CLVDatePickerViewWillShowNotification";
NSString * const CLVDatePickerViewWillHiddenNotification = @"CLVDatePickerViewWillHiddenNotification";
NSString * const CLVDatePickerViewFrameEndHeightInfoKey = @"CLVDatePickerViewFrameEndHeightInfoKey";

@interface CLVDatePickerView () <UIPickerViewDelegate, UIPickerViewDataSource>

@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIPickerView *picker;

@property (nonatomic, strong) NSArray<NSString *> *years;
@property (nonatomic, strong) NSArray<NSString *> *months;
@property (nonatomic, strong) NSArray<NSString *> *days;
@property (nonatomic, strong) NSMutableArray<NSArray *>  *dateInfos;
@property (nonatomic, copy)   NSString * originalDateStr;


@property (nonatomic, assign) NSInteger yearIdx;
@property (nonatomic, assign) NSInteger monthIdx;
@property (nonatomic, assign) NSInteger dayIdx;

@property (nonatomic, strong) CLVDateDatabaseService *service;

@end

static const CGFloat cContentViewHeight = 232.0;
static const NSInteger cPickerViewComponentNum = 3;

@implementation CLVDatePickerView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        _yearIdx = _monthIdx = _dayIdx = 0;
        self.backgroundColor = [UIColor clearColor];
        _contentView = [[UIView alloc] initWithFrame:CGRectMake(0.0, CGRectGetHeight(frame) - cContentViewHeight,
                                                                CGRectGetWidth(frame), cContentViewHeight)];
        _contentView.backgroundColor = [UIColor whiteColor];
        [self addSubview:_contentView];
        
        [self setUpNavBar];
        [self addCancelGesture];
        
        _service = [[CLVDateDatabaseService alloc] init];
        _years = [_service years];
        self.dateInfos[0] = _years;
        if (_years.count > 0) {
            [self setMonthInfoWithYear:_years.firstObject];
        }
        if (_months.count > 0) {
            [self setDayInfoWithYear:_years.firstObject month:_months.firstObject];
        }
        if (_days.count > 0) {
            _dateInfos = [@[_years, _months, _days] mutableCopy];
            [self setUpPickerView];
        }
    }
    return self;
}

#pragma mark - Convenience Setter

- (void)setMonthInfoWithYear:(NSString *)year
{
    self.months   = [self.service monthsWithYears:year];
    self.dateInfos[1] = self.months;
}

- (void)setDayInfoWithYear:(NSString *)year month:(NSString *)month
{
    self.days   = [self.service daysWithYears:year Month:month];
    self.dateInfos[2] = self.days;
}

- (void)setDateWithYear:(NSString *)Year
                  Month:(NSString *)Month
                    Day:(nullable NSString *)Day{
    if (![self.years containsObject:Year]) return;
    
    [self setMonthInfoWithYear:Year];
    if (![self.months containsObject:Month]) {
        [self.picker reloadAllComponents];
        return;
    }
    [self setDateWithYear:Year Month:Month Day:Day];
    
    [self.picker reloadAllComponents];
    self.yearIdx = [self.years indexOfObject:Year];
    self.monthIdx = [self.months indexOfObject:Month];
    if (Day.length > 0) {
        self.dayIdx = [self.days containsObject:Day] ? [self.days indexOfObject:Day] : 0;
    } else {
        self.dayIdx = 0;
    }
    
    [self.picker selectRow:self.yearIdx inComponent:0 animated:YES];
    [self.picker selectRow:self.monthIdx inComponent:1 animated:YES];
    [self.picker selectRow:self.dayIdx inComponent:2 animated:YES];
    self.originalDateStr = [self currentDateStr];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(datePicker:didSelectDate:)]) {
        [self.delegate datePicker:self didSelectDate:[self originalDateStr]];
    }
}

- (NSString *)currentDateStr {
    NSMutableArray<NSString *> *dateInfo = [NSMutableArray array];
    if (self.yearIdx < self.years.count) {
        [dateInfo addObject:self.years[self.yearIdx]];
    }
    if (self.monthIdx     < self.months.count) {
        [dateInfo addObject:self.months[self.monthIdx]];
    }
    if (self.dayIdx     < self.days.count) {
        [dateInfo addObject:self.days[self.dayIdx]];
    }
    return [dateInfo componentsJoinedByString:@""];
}

- (void)addToView:(UIView *)view animated:(BOOL)animated {
    if (self.superview) return;
    NSDictionary *userInfo = @{CLVDatePickerViewFrameEndHeightInfoKey : @(cContentViewHeight)};
    [[NSNotificationCenter defaultCenter] postNotificationName:CLVDatePickerViewWillShowNotification object:nil userInfo:userInfo];
    if (animated) {
        [view addSubview:self];
        //        self.userInteractionEnabled = NO;
        CGPoint newCenter = CGPointZero, oriCenter = _contentView.center;
        newCenter.x = _contentView.center.x;
        newCenter.y = _contentView.center.y + cContentViewHeight;
        _contentView.center = newCenter;
        [UIView animateWithDuration:0.25 animations:^{
            _contentView.center = oriCenter;
            self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
        } completion:^(BOOL finished) {
            if (finished) {
                _contentView.center = oriCenter;
                //                self.userInteractionEnabled = YES;
            }
        }];
    } else {
        [view addSubview:self];
    }
    
    [self.picker selectRow:self.yearIdx inComponent:0 animated:YES];
    [self.picker selectRow:self.monthIdx inComponent:1 animated:YES];
    [self.picker selectRow:self.dayIdx inComponent:2 animated:YES];
    if (self.delegate && [self.delegate respondsToSelector:@selector(datePicker:didSelectDate:)]) {
        [self.delegate datePicker:self didSelectDate:[self currentDateStr]];
    }
}

- (void)dismissWithAnimated:(BOOL)animated completion:(nullable void (^)(void))completion {
    if (!self.superview) return;
    [[NSNotificationCenter defaultCenter] postNotificationName:CLVDatePickerViewWillHiddenNotification object:nil];
    if (animated) {
        CGPoint newCenter = CGPointZero, oriCenter = _contentView.center;
        newCenter.x = _contentView.center.x;
        newCenter.y = _contentView.center.y + cContentViewHeight;
        [UIView animateWithDuration:0.25 animations:^{
            _contentView.center = newCenter;
            self.backgroundColor = [UIColor clearColor];
        } completion:^(BOOL finished) {
            if (finished) {
                _contentView.center = oriCenter;
                [self removeFromSuperview];
                if (completion) completion();
            }
        }];
    } else {
        [self removeFromSuperview];
    }
}

- (void)cancelDisplay {
    [self cancelDateBtn:nil];
}

#pragma mark - Actions

- (void)confirmDateBtn:(id)sender
{
    [self dismissWithAnimated:YES completion:^{
        if (self.delegate &&
            [self.delegate respondsToSelector:@selector(datePicker:confirmWithYear:Month:Day:)]) {
            [self.delegate datePicker:self confirmWithYear:self.years[self.yearIdx] Month:self.months[self.monthIdx] Day:self.days[self.dayIdx]];
        }
    }];
}

- (void)cancelDateBtn:(id)sender
{
    [self dismissWithAnimated:YES completion:^{
        if (self.delegate &&
            [self.delegate respondsToSelector:@selector(datePicker:cancelWithOriginalDate:)]) {
            [self.delegate datePicker:self cancelWithOriginalDate:self.originalDateStr];
        }
    }];
}

#pragma mark - UIPickerViewDelegate

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row
          forComponent:(NSInteger)component reusingView:(nullable UIView *)view {
    UILabel *label = (UILabel *)view;
    if (!label) {
        label = [UILabel new];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont ld_defaultFontOfSize:16.0];
    }
    
    if (component < cPickerViewComponentNum && self.dateInfos[component].count > row) {
        label.text = self.dateInfos[component][row];
    } else {
        label.text = nil;
    }
    return label;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (!(component < cPickerViewComponentNum && self.dateInfos[component].count > row)) return;
    if (component == 0) {
        NSString *year = self.years[row];
        [self setMonthInfoWithYear:year];
        [self setDayInfoWithYear:year month:self.years.firstObject];
        self.yearIdx = row;
        self.monthIdx = self.dayIdx = 0;
    } else if (component == 1) {
        NSString *monthId = self.months[row];
        [self setDayInfoWithYear:self.years[self.yearIdx] month:monthId];
        self.monthIdx = row;
        self.dayIdx = 0;
    } else if (component == 2) {
        self.dayIdx = row;
    }
    for (NSInteger i = component+1; i < cPickerViewComponentNum; i++) {
        [self.picker reloadComponent:i];
        [self.picker selectRow:0 inComponent:i animated:YES];
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(datePicker:didSelectDate:)]) {
        [self.delegate datePicker:self didSelectDate:[self currentDateStr]];
    }
}


#pragma mark - UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return cPickerViewComponentNum;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return component < cPickerViewComponentNum ? self.dateInfos[component].count : 0;
}


#pragma mark - Interface Build

- (void)setUpNavBar
{
    CGFloat width = CGRectGetWidth(self.frame);
    UIView *navBar = [UIView new];
    navBar.frame = CGRectMake(0.0, 0.0, width, 37.0);
    navBar.backgroundColor = [UIColor ld_colorWithHex:0xd8d8d8];
    
    UIButton *confirmBtn = [self navButtonWithTitle:@"确定" target:self
                                             action:@selector(confirmDateBtn:)];
    confirmBtn.frame = CGRectMake(width - 60.0, 0.0, 60.0, 37.0);
    UIButton *cancelBtn = [self navButtonWithTitle:@"取消" target:self
                                            action:@selector(cancelDateBtn:)];
    cancelBtn.frame = CGRectMake(0.0, 0.0, 60.0, 37.0);
    [navBar addSubview:confirmBtn];
    [navBar addSubview:cancelBtn];
    [_contentView addSubview:navBar];
}

- (UIButton *)navButtonWithTitle:(NSString *)title target:(id)target action:(SEL)action
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.titleLabel.font = [UIFont ld_defaultFontOfSize:14.0];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[UIColor ld_colorWithHex:0x333333] forState:UIControlStateNormal];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return button;
}

- (void)setUpPickerView
{
    _picker = [UIPickerView new];
    _picker.delegate = self;
    _picker.dataSource = self;
    _picker.showsSelectionIndicator = YES;
    _picker.backgroundColor = [UIColor whiteColor];
    _picker.frame = CGRectMake(0.0, 37.0, CGRectGetWidth(self.frame), cContentViewHeight - 37.0);
    [_contentView addSubview:_picker];
}

- (void)addCancelGesture
{
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]
                                          initWithTarget:self action:@selector(handleTapGesture:)];
    [self addGestureRecognizer:tapGesture];
}

- (void)handleTapGesture:(UITapGestureRecognizer *)tapGesture
{
    CGPoint point = [tapGesture locationInView:self];
    CGRect upperFrame = CGRectMake(0, 0, CGRectGetWidth(self.bounds),
                                   CGRectGetHeight(self.bounds) - cContentViewHeight);
    if (CGRectContainsPoint(upperFrame, point)) {
        [self cancelDateBtn:nil];
    }
}

@end
