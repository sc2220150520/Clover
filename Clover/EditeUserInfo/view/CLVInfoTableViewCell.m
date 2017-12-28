//
//  CLVInfoTableViewCell.m
//  Clover
//
//  Created by shen chen on 2017/12/27.
//  Copyright © 2017年 shenchen. All rights reserved.
//

#import "CLVInfoTableViewCell.h"
#import <Masonry.h>
#import "UIButton+CLVCustom.h"
#import "KWAreaPickerView.h"

#pragma mark - 编辑个人信息页的tableViewCell抽象基类
@interface CLVInfoTableViewCell ()
@property (nonatomic, strong) UILabel *theme;
@property (nonatomic, assign) BOOL shouldShowBottomLine;

@end

@implementation CLVInfoTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier aboutTheme:(NSString *)str shouldShowBottomLine:(BOOL)shouldShowBottomLine{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self addSubviews];
        [self setupLayout];
        [self setupStyle];
        self.theme.text = str;
        self.shouldShowBottomLine = shouldShowBottomLine;
    }
    return self;
}
- (void)addSubviews {}
- (void)setupLayout {}
- (void)setupStyle {
    self.theme.font = [UIFont ld_defaultFontOfSize:14];
    self.theme.textColor = [UIColor ld_colorWithHex:0x333333];
}
- (void)setContent:(id)model {}
- (void)didTapped {}

- (UILabel *)theme {
    if (_theme == nil) {
        _theme = [[UILabel alloc] init];
    }
    return _theme;
}

#pragma mark - 画cell底部分割线
-(void)drawRect:(CGRect)rect{
    if (self.shouldShowBottomLine) {
        CGContextRef context = UIGraphicsGetCurrentContext();
        
        CGContextSetFillColorWithColor(context, [UIColor clearColor].CGColor);
        CGContextFillRect(context, rect);
        
        CGContextSetStrokeColorWithColor(context, [UIColor ld_colorWithHex:0xE8E8E8].CGColor);
        CGContextStrokeRect(context, CGRectMake(15, rect.size.height, rect.size.width - 15, 1.0 / [UIScreen mainScreen].scale));
    }
}

@end

#pragma mark - 编辑头像的cell
@interface CLVEditImageTableViewCell()
@property (nonatomic, strong) UIImageView *myImageView;
@property (nonatomic, strong) UIImageView *arrowImageView;
@end

@implementation CLVEditImageTableViewCell
#pragma mark init
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier aboutTheme:(NSString *)str shouldShowBottomLine:(BOOL)shouldShowBottomLine{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier aboutTheme:str shouldShowBottomLine:shouldShowBottomLine];
    if (self) {
    }
    return self;
}

- (void)addSubviews {
    [self.contentView addSubview:self.theme];
    [self.contentView addSubview:self.myImageView];
    [self.contentView addSubview:self.arrowImageView];
}

- (void)setupLayout {
    [self.theme mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(17.5);
        make.top.equalTo(self.contentView).offset(13.5);
        make.centerY.equalTo(self.contentView);
        make.width.greaterThanOrEqualTo(@20);
        make.height.equalTo(@20);
    }];
    
    [self.arrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-15);
        make.centerY.equalTo(self.contentView);
        make.width.equalTo(@12);
        make.height.equalTo(@8);
    }];
    
    [self.myImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.arrowImageView).offset(-10);
        make.centerY.equalTo(self.contentView);
        make.width.equalTo(@20);
        make.height.equalTo(@20);
    }];
}

- (void)setupStyle {
    [super setupStyle];
    self. myImageView.backgroundColor = [UIColor grayColor];
}

- (void)setContent:(id)model {
    UIImage *imagePic = (UIImage *)model;
    self.myImageView.image = imagePic;
}

- (void)didTapped {
    
}
#pragma mark lozy load
- (UIImageView *)myImageView {
    if (_myImageView == nil) {
        _myImageView = [[UIImageView alloc] init];
    }
    return _myImageView;
}

- (UIImageView *)arrowImageView {
    if (_arrowImageView == nil) {
        _arrowImageView = [[UIImageView alloc] init];
    }
    return _arrowImageView;
}

@end

#pragma mark - 编辑昵称或者个性签名类型的cell
@interface CLVEditTextTableViewCell()<UITextFieldDelegate>
@property (nonatomic, strong) UITextField *textFiled;
@end

@implementation CLVEditTextTableViewCell

#pragma mark init
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier aboutTheme:(NSString *)str shouldShowBottomLine:(BOOL)shouldShowBottomLine{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier aboutTheme:str shouldShowBottomLine:shouldShowBottomLine];
    if (self) {
    }
    return self;
}

- (void)addSubviews {
    [self.contentView addSubview:self.theme];
    [self.contentView addSubview:self.textFiled];
}
- (void)setupLayout {
    [self.theme mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(17.5);
        make.top.equalTo(self.contentView).offset(13.5);
        make.height.equalTo(@20);
        make.bottom.equalTo(self.contentView).offset(-13.5);
    }];
    
    [self.textFiled mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.theme.mas_right).offset(5);
        make.top.right.bottom.equalTo(self.contentView);
        make.width.greaterThanOrEqualTo(@250);
    }];
}
- (void)setupStyle {
    [super setupStyle];
    self.textFiled.textAlignment = NSTextAlignmentRight;
    self.textFiled.font = [UIFont ld_defaultFontOfSize:14];
    self.textFiled.textColor = [UIColor ld_colorWithHex:0x333333];
}

- (void)setContent:(id)model {
    NSString *str = model;
    self.textFiled.text = str;
}

#pragma mark textFiedDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField {}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    
}

#pragma mark lazyLoad
- (UITextField *)textFiled {
    if (_textFiled == nil) {
        _textFiled = [[UITextField alloc] init];
        _textFiled.delegate = self;
    }
    return _textFiled;
}

@end

#pragma mark - 编辑性别的cell
@interface CLVEditButtonTableViewCell()

@property (nonatomic, strong) UIButton *boyBtn;
@property (nonatomic, strong) UIButton *girlBtn;
@property (nonatomic, strong) UIButton *lastChooseBtn;
@property (nonatomic, strong) NSString *sex;

@end

@implementation CLVEditButtonTableViewCell

#pragma mark init
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier aboutTheme:(NSString *)str shouldShowBottomLine:(BOOL)shouldShowBottomLine{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier aboutTheme:str shouldShowBottomLine:shouldShowBottomLine];
    if (self) {
    }
    return self;
}

- (void)addSubviews {
    [self.contentView addSubview:self.theme];
    [self.contentView addSubview:self.boyBtn];
    [self.contentView addSubview:self.girlBtn];
}
- (void)setupLayout {
    [self.theme mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(17.5);
        make.top.equalTo(self.contentView).offset(13.5);
        make.centerY.equalTo(self.contentView);
        make.height.equalTo(@20);
    }];
    
    [self.girlBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-15);
        make.centerY.equalTo(self.contentView);
        make.width.equalTo(@34);
        make.height.equalTo(@20);
    }];
    
    [self.boyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.girlBtn.mas_left).offset(-10);
        make.centerY.equalTo(self.contentView);
        make.width.equalTo(@34);
        make.height.equalTo(@20);
    }];
}
- (void)setupStyle {
    [super setupStyle];
    self.boyBtn.layer.cornerRadius = 14;
    self.girlBtn.layer.cornerRadius = 14;
    [self.boyBtn setTitle:@"男" forState:UIControlStateNormal];
    [self.girlBtn setTitle:@"女" forState:UIControlStateNormal];
    [self.boyBtn addTarget:self action:@selector(sexBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
     [self.boyBtn addTarget:self action:@selector(sexBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setContent:(id)model {
    NSString *str = (NSString *)model;
    if (self.lastChooseBtn) {
        self.lastChooseBtn.selected = NO;
    }
    if ([str isEqualToString:@"男"]) {
        self.boyBtn.selected = YES;
        self.lastChooseBtn = self.boyBtn;
    } else {
        self.girlBtn.selected = YES;
        self.lastChooseBtn = self.girlBtn;
    }
}

#pragma mark buttonTapped
- (void)sexBtnTapped:(id)sender {
    UIButton *it = (UIButton *)sender;
    if (self.lastChooseBtn != it) {
        self.lastChooseBtn.selected = NO;
        it.selected = YES;
        self.lastChooseBtn = it;
    }
}

#pragma mark lazyLoad
- (UIButton *)boyBtn {
    if (_boyBtn == nil) {
        _boyBtn = [UIButton clv_createButtonWithStyle:CLVCustomButtonBBgWTexStyle];
    }
    return _boyBtn;
}

- (UIButton *)girlBtn {
    if (_girlBtn == nil) {
        _girlBtn = [UIButton clv_createButtonWithStyle:CLVCustomButtonRBgWTxtStyle];
    }
    return _girlBtn;
}
@end

#pragma mark - 编辑地址的cell
@interface CLVEditAddressTableViewCell()<KWAreaPickerViewDelegate>
@property (nonatomic, strong) UILabel *addressLabel;
@property (nonatomic, strong) KWAreaPickerView *areaPicker;
@property (nonatomic, copy) NSString *provinceId;
@property (nonatomic, copy) NSString *cityId;
@property (nonatomic, copy) NSString *areaId;
@end

@implementation CLVEditAddressTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier aboutTheme:(NSString *)str shouldShowBottomLine:(BOOL)shouldShowBottomLine{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier aboutTheme:str shouldShowBottomLine:shouldShowBottomLine];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(areaPickerViewWillShow:) name:KWAreaPickerViewWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(areaPickerViewWillHidden:) name:KWAreaPickerViewWillHiddenNotification object:nil];
    }
    return self;
}

- (void)addSubviews {
    [self.contentView addSubview:self.theme];
    [self.contentView addSubview:self.addressLabel];
}
- (void)setupLayout {
    [self.theme mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(17.5);
        make.top.equalTo(self.contentView).offset(13.5);
        make.centerY.equalTo(self.contentView);
        make.height.equalTo(@20);
    }];
    
    [self.addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.theme.mas_right).offset(5);
        make.centerY.equalTo(self.contentView);
        make.height.equalTo(self.contentView);
        make.right.equalTo(self.contentView);
        make.width.greaterThanOrEqualTo(@250);
    }];
}
- (void)setupStyle {
    [super setupStyle];
    self.addressLabel.textAlignment = NSTextAlignmentRight;
    self.addressLabel.font = [UIFont ld_defaultFontOfSize:14];
    self.addressLabel.textColor = [UIColor ld_colorWithHex:0x333333];
    self.addressLabel.text = @"请设置";
}

- (void)setContent:(id)model {
    NSString *str = model;
    self.addressLabel.text = str;
}

- (void)didTapped {
    [self.areaPicker removeFromSuperview];
    self.areaPicker = [[KWAreaPickerView alloc] initWithFrame:[self viewController].view.bounds];
    self.areaPicker.delegate = self;
    [self.areaPicker addToView:[self viewController].view animated:YES];
    [self.areaPicker setAddressWithProvinceId:self.provinceId cityId:self.cityId areaId:self.areaId];
}

#pragma mark - KWAreaPickerView Notification

- (void)areaPickerViewWillShow:(NSNotification *)notification {
    //CGFloat pickerViewHeight = [[[notification userInfo] objectForKey:KWAreaPickerViewFrameEndHeightInfoKey] floatValue];
    //[self pickerViewWillShow:pickerViewHeight];
}

- (void)areaPickerViewWillHidden:(NSNotification *)notification {
    //[self pickerViewWillHidden];
}

#pragma mark - KWAreaPickerViewDelegate

- (void)areaPicker:(KWAreaPickerView *)picker didSelectAddress:(NSString *)addrStr {
    [self.addressLabel setText:addrStr];
}

- (void)areaPicker:(KWAreaPickerView *)picker cancelWithOriginalAddress:(NSString *)addrStr {
    [self.addressLabel setText:addrStr];
}

- (void)areaPicker:(KWAreaPickerView *)picker confirmWithProvinceId:(NSString *)provinceId
            cityId:(NSString *)cityId
            areaId:(nullable NSString *)areaId {
    self.provinceId = provinceId;
    self.cityId = cityId;
    self.areaId = areaId;
}

//- (void)pickerViewWillShow:(CGFloat)pickerViewHeight {
//    self.pickerViewShow = YES;
//    // pickerViewCell的底边Y值
//    CGFloat pickerViewCellBottomY = CGRectGetMaxY(self.convertCellRect) + self.pushDistance;
//    // 键盘的Y值
//    CGFloat pickerViewTopY = CGRectGetHeight(self.view.bounds) - pickerViewHeight;
//
//    if (self.pushDistance == 0) {
//        self.originalContentOffset = self.tableView.contentOffset;
//    }
//    // 如果成立，得到picker将要退出的距离
//    if (pickerViewTopY < pickerViewCellBottomY) {
//
//        CGFloat pickerWillDistance = pickerViewCellBottomY - pickerViewTopY;
//        CGFloat finalDistance = self.pushDistance - pickerWillDistance;
//        [UIView animateWithDuration:0.25 animations:^{
//            self.tableView.contentOffset = CGPointMake(0, self.tableView.contentOffset.y - finalDistance);
//        }];
//    } else {
//        [UIView animateWithDuration:0.25 animations:^{
//            self.tableView.contentOffset = self.originalContentOffset;
//        }];
//    }
//}

//- (void)pickerViewWillHidden {
//    self.pickerViewShow = NO;
//    [UIView animateWithDuration:0.25 animations:^{
//        self.pushDistance = 0;
//        self.tableView.contentOffset = self.originalContentOffset;
//    }];
//}

#pragma mark lazyLoad
- (UILabel *)addressLabel {
    if (_addressLabel == nil) {
        _addressLabel = [[UILabel alloc] init];
    }
    return _addressLabel;
}

#pragma mark - 获得所在控制器
- (UIViewController *)viewController {
    for (UIView *next = self.superview; next; next = next.superview) {
        UIResponder *nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)nextResponder;
        }
    }
    return nil;
}

@end

#pragma mark - 编辑年龄的cell
@interface CLVEditAgeTableViewCell()

@property (nonatomic, strong) UILabel *ageLabel;

@end

@implementation CLVEditAgeTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier aboutTheme:(NSString *)str shouldShowBottomLine:(BOOL)shouldShowBottomLine{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier aboutTheme:str shouldShowBottomLine:shouldShowBottomLine];
    if (self) {
        
    }
    return self;
}

- (void)addSubviews {
    [self.contentView addSubview:self.theme];
    [self.contentView addSubview:self.ageLabel];
}
- (void)setupLayout {
    [self.theme mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(17.5);
        make.centerY.equalTo(self.contentView);
        make.top.equalTo(self.contentView).offset(13.5);
        make.height.equalTo(@20);
    }];
    
    [self.ageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.theme.mas_right).offset(5);
        make.centerY.equalTo(self.contentView);
        make.height.equalTo(self.contentView);
        make.right.equalTo(self.contentView);
        make.width.greaterThanOrEqualTo(@250);
    }];
}
- (void)setupStyle {
    [super setupStyle];
    self.ageLabel.textAlignment = NSTextAlignmentRight;
    self.ageLabel.font = [UIFont ld_defaultFontOfSize:14];
    self.ageLabel.textColor = [UIColor ld_colorWithHex:0x333333];
    self.ageLabel.text = @"请选择";
}

- (void)setContent:(id)model {
    NSString *str = model;
    self.ageLabel.text = str;
}


#pragma mark lazyLoad
- (UILabel *)ageLabel {
    if (_ageLabel == nil) {
        _ageLabel = [[UILabel alloc] init];
    }
    return _ageLabel;
}

@end
