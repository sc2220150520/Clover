//
//  KWAreaPickerView.m
//  Kiwifruit
//
//  Created by netease on 2017/9/19.
//  Copyright © 2017年 Kiwifruit. All rights reserved.
//

#import "KWAreaPickerView.h"
#import "KWAddressDatabaseService.h"

//#import "UIFont+Common.h"
#import "UIColor+LDAddition.h"

NSString * const KWAreaPickerViewWillShowNotification = @"KWAreaPickerViewWillShowNotification";
NSString * const KWAreaPickerViewWillHiddenNotification = @"KWAreaPickerViewWillHiddenNotification";
NSString * const KWAreaPickerViewFrameEndHeightInfoKey = @"KWAreaPickerViewFrameEndHeightInfoKey";

@interface KWAreaPickerView () <UIPickerViewDelegate, UIPickerViewDataSource>

@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIPickerView *picker;

@property (nonatomic, strong) NSArray<NSString *> *provinceNames;
@property (nonatomic, strong) NSArray<NSString *> *provinceIds;
@property (nonatomic, strong) NSArray<NSString *> *cityNames;
@property (nonatomic, strong) NSArray<NSString *> *cityIds;
@property (nonatomic, strong) NSArray<NSString *> *areaNames;
@property (nonatomic, strong) NSArray<NSString *> *areaIds;
@property (nonatomic, strong) NSMutableArray<NSArray *>  *addrNameInfos;
@property (nonatomic, copy)   NSString * originalAddrStr;


@property (nonatomic, assign) NSInteger provinceIdx;
@property (nonatomic, assign) NSInteger cityIdx;
@property (nonatomic, assign) NSInteger areaIdx;

@property (nonatomic, strong) KWAddressDatabaseService *service;

@end

static const CGFloat kContentViewHeight = 232.0;
static const NSInteger kPickerViewComponentNum = 3;

@implementation KWAreaPickerView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        _provinceIdx = _cityIdx = _areaIdx = 0;
        self.backgroundColor = [UIColor clearColor];
        _contentView = [[UIView alloc] initWithFrame:CGRectMake(0.0, CGRectGetHeight(frame) - kContentViewHeight,
                                                                CGRectGetWidth(frame), kContentViewHeight)];
        _contentView.backgroundColor = [UIColor whiteColor];
        [self addSubview:_contentView];
        
        [self setUpNavBar];
        [self addCancelGesture];
        
        _service = [[KWAddressDatabaseService alloc] init];
        _provinceIds = [_service provinceIDs];
        _provinceNames = [_service provinceNames];
        if (_provinceIds.count > 0) {
            [self setCityInfoWithProvinceId:_provinceIds.firstObject];
        }
        if (_cityIds.count > 0) {
            [self setAreaInfoWithCityId:_cityIds.firstObject];
        }
        if (_areaIds.count > 0) {
            _addrNameInfos = [@[_provinceNames, _cityNames, _areaNames] mutableCopy];
            [self setUpPickerView];
        }
    }
    return self;
}


#pragma mark - Public

- (void)setAddressWithProvinceId:(NSString *)provinceId
                          cityId:(NSString *)cityId
                          areaId:(nullable NSString *)areaId
{
    if (![self.provinceIds containsObject:provinceId]) return;
    
    [self setCityInfoWithProvinceId:provinceId];
    if (![self.cityIds containsObject:cityId]) {
        [self.picker reloadAllComponents];
        return;
    }
    [self setAreaInfoWithCityId:cityId];
    
    [self.picker reloadAllComponents];
    self.provinceIdx = [self.provinceIds indexOfObject:provinceId];
    self.cityIdx = [self.cityIds indexOfObject:cityId];
    if (areaId.length > 0) {
        self.areaIdx = [self.areaIds containsObject:areaId] ? [self.areaIds indexOfObject:areaId] : 0;
    } else {
        self.areaIdx = 0;
    }
    
    [self.picker selectRow:self.provinceIdx inComponent:0 animated:YES];
    [self.picker selectRow:self.cityIdx inComponent:1 animated:YES];
    [self.picker selectRow:self.areaIdx inComponent:2 animated:YES];
    self.originalAddrStr = [self currentAddrStr];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(areaPicker:didSelectAddress:)]) {
        [self.delegate areaPicker:self didSelectAddress:self.originalAddrStr];
    }
}

- (NSString *)currentAddrStr
{
    NSMutableArray<NSString *> *addrInfo = [NSMutableArray array];
    if (self.provinceIdx < self.provinceNames.count) {
        [addrInfo addObject:self.provinceNames[self.provinceIdx]];
    }
    if (self.cityIdx     < self.cityNames.count) {
        [addrInfo addObject:self.cityNames[self.cityIdx]];
    }
    if (self.areaIdx     < self.areaNames.count) {
        [addrInfo addObject:self.areaNames[self.areaIdx]];
    }
    return [addrInfo componentsJoinedByString:@""];
}

- (void)addToView:(UIView *)view animated:(BOOL)animated
{
    if (self.superview) return;
    NSDictionary *userInfo = @{KWAreaPickerViewFrameEndHeightInfoKey : @(kContentViewHeight)};
    [[NSNotificationCenter defaultCenter] postNotificationName:KWAreaPickerViewWillShowNotification object:nil userInfo:userInfo];
    if (animated) {
        [view addSubview:self];
//        self.userInteractionEnabled = NO;
        CGPoint newCenter = CGPointZero, oriCenter = _contentView.center;
        newCenter.x = _contentView.center.x;
        newCenter.y = _contentView.center.y + kContentViewHeight;
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
    
    [self.picker selectRow:self.provinceIdx inComponent:0 animated:YES];
    [self.picker selectRow:self.cityIdx inComponent:1 animated:YES];
    [self.picker selectRow:self.areaIdx inComponent:2 animated:YES];
    if (self.delegate && [self.delegate respondsToSelector:@selector(areaPicker:didSelectAddress:)]) {
        [self.delegate areaPicker:self didSelectAddress:[self currentAddrStr]];
    }
}

- (void)cancelDisplay
{
    [self cancelAddrBtn:nil];
}

- (void)dismissWithAnimated:(BOOL)animated completion:(void (^)(void))completion
{
    if (!self.superview) return;
    [[NSNotificationCenter defaultCenter] postNotificationName:KWAreaPickerViewWillHiddenNotification object:nil];
    if (animated) {
        CGPoint newCenter = CGPointZero, oriCenter = _contentView.center;
        newCenter.x = _contentView.center.x;
        newCenter.y = _contentView.center.y + kContentViewHeight;
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


#pragma mark - Actions

- (void)confirmAddrBtn:(id)sender
{
    [self dismissWithAnimated:YES completion:^{
        if (self.delegate &&
            [self.delegate respondsToSelector:@selector(areaPicker:confirmWithProvinceId:cityId:areaId:)]) {
            [self.delegate areaPicker:self confirmWithProvinceId:self.provinceIds[self.provinceIdx]
                               cityId:self.cityIds[self.cityIdx] areaId:self.areaIds[self.areaIdx]];
        }
    }];
}

- (void)cancelAddrBtn:(id)sender
{
    [self dismissWithAnimated:YES completion:^{
        if (self.delegate &&
            [self.delegate respondsToSelector:@selector(areaPicker:cancelWithOriginalAddress:)]) {
            [self.delegate areaPicker:self cancelWithOriginalAddress:self.originalAddrStr];
        }
    }];
}


#pragma mark - Convenience Setter

- (void)setCityInfoWithProvinceId:(NSString *)provinceId
{
    self.cityIds   = [self.service cityIDsWithProvinceID:provinceId];
    self.cityNames = [self.service cityNamesWithProvinceID:provinceId];
    self.addrNameInfos[1] = self.cityNames;
}

- (void)setAreaInfoWithCityId:(NSString *)cityId
{
    self.areaIds   = [self.service areaIDsWithCityID:cityId];
    self.areaNames = [self.service areaNamesWithCityID:cityId];
    self.addrNameInfos[2] = self.areaNames;
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
    
    if (component < kPickerViewComponentNum && self.addrNameInfos[component].count > row) {
        label.text = self.addrNameInfos[component][row];
    } else {
        label.text = nil;
    }
    return label;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (!(component < kPickerViewComponentNum && self.addrNameInfos[component].count > row)) return;
    if (component == 0) {
        NSString *provinceId = self.provinceIds[row];
        [self setCityInfoWithProvinceId:provinceId];
        [self setAreaInfoWithCityId:self.cityIds.firstObject];
        self.provinceIdx = row;
        self.cityIdx = self.areaIdx = 0;
    } else if (component == 1) {
        NSString *cityId = self.cityIds[row];
        [self setAreaInfoWithCityId:cityId];
        self.cityIdx = row;
        self.areaIdx = 0;
    } else if (component == 2) {
        self.areaIdx = row;
    }
    for (NSInteger i = component+1; i < kPickerViewComponentNum; i++) {
        [self.picker reloadComponent:i];
        [self.picker selectRow:0 inComponent:i animated:YES];
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(areaPicker:didSelectAddress:)]) {
        [self.delegate areaPicker:self didSelectAddress:[self currentAddrStr]];
    }
}


#pragma mark - UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return kPickerViewComponentNum;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return component < kPickerViewComponentNum ? self.addrNameInfos[component].count : 0;
}


#pragma mark - Interface Build

- (void)setUpNavBar
{
    CGFloat width = CGRectGetWidth(self.frame);
    UIView *navBar = [UIView new];
    navBar.frame = CGRectMake(0.0, 0.0, width, 37.0);
    navBar.backgroundColor = [UIColor ld_colorWithHex:0xd8d8d8];
    
    UIButton *confirmBtn = [self navButtonWithTitle:@"确定" target:self
                                             action:@selector(confirmAddrBtn:)];
    confirmBtn.frame = CGRectMake(width - 60.0, 0.0, 60.0, 37.0);
    UIButton *cancelBtn = [self navButtonWithTitle:@"取消" target:self
                                            action:@selector(cancelAddrBtn:)];
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
    _picker.frame = CGRectMake(0.0, 37.0, CGRectGetWidth(self.frame), kContentViewHeight - 37.0);
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
                                   CGRectGetHeight(self.bounds) - kContentViewHeight);
    if (CGRectContainsPoint(upperFrame, point)) {
        [self cancelAddrBtn:nil];
    }
}

@end
