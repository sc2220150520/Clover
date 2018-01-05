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
#import "CLVDatePickerView.h"
#import <NSDate+LDAddition.h>

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

#pragma mark lozyLoad

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
    if ([[self viewController] respondsToSelector:@selector(showFloatLayerView:)]) {
        [[self viewController] performSelector:@selector(showFloatLayerView:) withObject:self.myImageView];
    }
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
@interface CLVEditTextTableViewCell() <UITextFieldDelegate>
@property (nonatomic, strong) UITextField *textFiled;
@end

@implementation CLVEditTextTableViewCell

#pragma mark init
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier aboutTheme:(NSString *)str shouldShowBottomLine:(BOOL)shouldShowBottomLine{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier aboutTheme:str shouldShowBottomLine:shouldShowBottomLine];
    if (self) {
        self.characterCount = NSUIntegerMax;
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
        make.top.bottom.equalTo(self.contentView);
        make.right.equalTo(self.contentView).offset(-15);
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

#pragma mark - Public Method

- (void)setText:(NSString *)text {
    self.textFiled.text = text;
}

- (NSString *)getText {
    return self.textFiled.text;
}

- (void)setPlaceholder:(NSString *)placeholder {
    self.textFiled.placeholder = placeholder;
}

- (void)setKeyboardType:(UIKeyboardType)keyboardType {
    self.textFiled.keyboardType = keyboardType;
}

- (void)setTextFieldUserInteractionDisabled {
    self.textFiled.userInteractionEnabled = NO;
    //self.textFiled.textColor = [UIColor ld_colorWithHex:KW_GREY_LIGHT];
}

- (void)setTextFieldTextColor:(UIColor *)color {
    self.textFiled.textColor = color;
}

#pragma mark - Action

- (void)textFieldChanged:(UITextField *)textField {
    if ([self.delegate respondsToSelector:@selector(certificationTextFieldCellTextChanged:)]) {
        [self.delegate editTextFieldCellTextChanged:self];
    }
    NSString *toBeString = textField.text;
//    if (![self isInputRuleAndBlank:toBeString]) {
//        textField.text = [self disable_emoji:toBeString];
//        return;
//    }
    
    NSString *lang = [[textField textInputMode] primaryLanguage]; // 获取当前键盘输入模式
    //简体中文输入,第三方输入法（搜狗）所有模式下都会显示“zh-Hans”
    if([lang isEqualToString:@"zh-Hans"]) {
        UITextRange *selectedRange = [textField markedTextRange];
        //获取高亮部分
        UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
        //没有高亮选择的字，则对已输入的文字进行字数统计和限制
        if(!position) {
            NSString *getStr = [self getSubString:toBeString];
            if(getStr && getStr.length > 0) {
                textField.text = getStr;
            }
        }
    } else{
        NSString *getStr = [self getSubString:toBeString];
        if(getStr && getStr.length > 0) {
            textField.text= getStr;
        }
    }
}


#pragma mark - Private Method

/**
 * 字母、数字、中文正则判断（不包括空格）
 */
- (BOOL)isInputRuleNotBlank:(NSString *)str {
    NSString *pattern = @"^[a-zA-Z\u4E00-\u9FA5\\d]*$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:str];
    
    if (!isMatch) {
        NSString *other = @"➋➌➍➎➏➐➑➒";
        unsigned long len=str.length;
        for(int i=0;i<len;i++)
        {
            unichar a=[str characterAtIndex:i];
            if(!((isalpha(a))
                 ||(isalnum(a))
                 ||((a=='_') || (a == '-'))
                 ||((a >= 0x4e00 && a <= 0x9fa6))
                 ||([other rangeOfString:str].location != NSNotFound)
                 ))
                return NO;
        }
        return YES;
        
    }
    return isMatch;
}
/**
 * 字母、数字、中文正则判断（包括空格）（在系统输入法中文输入时会出现拼音之间有空格，需要忽略，当按return键时会自动用字母替换，按空格输入响应汉字）
 */
- (BOOL)isInputRuleAndBlank:(NSString *)str {
    
    NSString *pattern = @"^[a-zA-Z\u4E00-\u9FA5\\d\\s]*$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:str];
    return isMatch;
}

/**
 *  过滤字符串中的emoji
 */
- (NSString *)disable_emoji:(NSString *)text{
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"[^\\u0020-\\u007E\\u00A0-\\u00BE\\u2E80-\\uA4CF\\uF900-\\uFAFF\\uFE30-\\uFE4F\\uFF00-\\uFFEF\\u0080-\\u009F\\u2000-\\u201f\r\n]"options:NSRegularExpressionCaseInsensitive error:nil];
    NSString *modifiedString = [regex stringByReplacingMatchesInString:text
                                                               options:0
                                                                 range:NSMakeRange(0, [text length])
                                                          withTemplate:@""];
    return modifiedString;
}

/**
 *  获得 CharacterCount长度的字符
 */
-(NSString *)getSubString:(NSString*)string
{
    if (string.length > self.characterCount) {
        NSLog(@"超出字数上限");
        return [string substringToIndex:self.characterCount];
    }
    return nil;
}

#pragma mark - UITextFieldDelegate

//- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
//    if ([self isInputRuleNotBlank:string] || [string isEqualToString:@""]) {//当输入符合规则和退格键时允许改变输入框
//        return YES;
//    } else {
//        NSLog(@"超出字数限制");
//        return NO;
//    }
//}

#pragma mark textFiedDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if ([self.delegate respondsToSelector:@selector(editTextFieldCellShouldBeginEditing:)]) {
        [self.delegate editTextFieldCellShouldBeginEditing:self];
    }
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    if ([self.delegate respondsToSelector:@selector(editTextFieldCellShouldEndEditing:)]) {
        [self.delegate editTextFieldCellShouldEndEditing:self];
    }
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

#pragma mark lazyLoad
- (UITextField *)textFiled {
    if (_textFiled == nil) {
        _textFiled = [[UITextField alloc] init];
        _textFiled.backgroundColor = [UIColor clearColor];
        _textFiled.font = [UIFont ld_defaultFontOfSize:15];
        _textFiled.textColor = [UIColor ld_colorWithHex:0x666666];
        _textFiled.clearButtonMode = UITextFieldViewModeWhileEditing;
        _textFiled.returnKeyType = UIReturnKeyDone;
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
        make.right.equalTo(self.contentView).offset(-15);
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

#pragma mark lazyLoad
- (UILabel *)addressLabel {
    if (_addressLabel == nil) {
        _addressLabel = [[UILabel alloc] init];
    }
    return _addressLabel;
}

@end

#pragma mark - 编辑年龄的cell
@interface CLVEditAgeTableViewCell() <CLVDatePickerViewDelegate>

@property (nonatomic, strong) UILabel *ageLabel;
@property (nonatomic, strong) CLVDatePickerView *datePickerView;
@property (nonatomic, copy) NSString *year;
@property (nonatomic, copy) NSString *month;
@property (nonatomic, copy) NSString *day;

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
        make.right.equalTo(self.contentView).offset(-15);
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

- (void)didTapped {
    [self.datePickerView removeFromSuperview];
    self.datePickerView = [[CLVDatePickerView alloc] initWithFrame:[self viewController].view.bounds];
    self.datePickerView.delegate = self;
    [self.datePickerView addToView:[self viewController].view animated:YES];
    [self.datePickerView setDateWithYear:self.year Month:self.month Day:self.day];
}

#pragma mark calcu age
- (NSInteger)ageWithDateOfBirth:(NSDate *)date;
{
    // 出生日期转换 年月日
    NSDateComponents *components1 = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:date];
    NSInteger brithDateYear  = [components1 year];
    NSInteger brithDateDay   = [components1 day];
    NSInteger brithDateMonth = [components1 month];
    
    // 获取系统当前 年月日
    NSDateComponents *components2 = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:[NSDate date]];
    NSInteger currentDateYear  = [components2 year];
    NSInteger currentDateDay   = [components2 day];
    NSInteger currentDateMonth = [components2 month];
    
    // 计算年龄
    NSInteger iAge = currentDateYear - brithDateYear - 1;
    if ((currentDateMonth > brithDateMonth) || (currentDateMonth == brithDateMonth && currentDateDay >= brithDateDay)) {
        iAge++;
    }
    
    return iAge;
}

#pragma mark datePickerViewDelegate
- (void)datePicker:(CLVDatePickerView *)picker didSelectDate:(NSString *)dateStr {
    NSDate *start = [NSDate ld_dateWithString:dateStr dateFormat:@"yyyy-MM-dd"];
    NSInteger age = [self ageWithDateOfBirth:start];
    [self.ageLabel setText:[NSString stringWithFormat:@"%ld",age]];
}

- (void)datePicker:(CLVDatePickerView *)picker cancelWithOriginalDate:(NSString *)dateStr {
    NSDate *start = [NSDate ld_dateWithString:dateStr dateFormat:@"YY-MM-DD"];
    NSInteger age = [self ageWithDateOfBirth:start];
    [self.ageLabel setText:[NSString stringWithFormat:@"%ld",age]];
}

- (void)datePicker:(CLVDatePickerView *)picker confirmWithYear:(NSString *)Year
             Month:(NSString *)Month
               Day:(nullable NSString *)Day {
    self.year = Year;
    self.month = Month;
    self.day = Day;
}

#pragma mark lazyLoad
- (UILabel *)ageLabel {
    if (_ageLabel == nil) {
        _ageLabel = [[UILabel alloc] init];
    }
    return _ageLabel;
}

@end
