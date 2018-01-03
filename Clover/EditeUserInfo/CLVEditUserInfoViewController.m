//
//  CLVEditUserInfoViewController.m
//  Clover
//
//  Created by shen chen on 2017/12/28.
//  Copyright © 2017年 shenchen. All rights reserved.
//

#import "CLVEditUserInfoViewController.h"
#import <Masonry.h>
#import "CLVAddPhotoTableViewCell.h"
#import "CLVInfoTableViewCell.h"
#import "KWAreaPickerView.h"

@interface CLVEditUserInfoViewController ()<UITableViewDelegate, UITableViewDataSource,CLVEditTextCellDelegate,UIGestureRecognizerDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *cellNum;
@property (nonatomic, strong) NSMutableArray *phtoCells;
@property (nonatomic, strong) NSMutableArray *infoCells;
@property (nonatomic, assign) CGRect convertCellRect;
//没有pick或keyboard时的正常情况下的tableView偏移量
@property (nonatomic, assign) CGPoint originalContentOffset;
@property (nonatomic, assign) CGFloat pushDistance;
@property (nonatomic, assign) CGFloat beyondTableViewDistance;
@property (nonatomic, assign) BOOL pickerViewShow;
@end

@implementation CLVEditUserInfoViewController

#pragma mark - lifeCircle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.extendedLayoutIncludesOpaqueBars = NO;
    self.navigationController.navigationBar.translucent = NO;
    //设置键盘消失
    [self setUpForDismissKeyboard];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHidden:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(areaPickerViewWillShow:) name:KWAreaPickerViewWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(areaPickerViewWillHidden:) name:KWAreaPickerViewWillHiddenNotification object:nil];
    self.cellNum = [NSMutableArray array];
    self.infoCells = [NSMutableArray array];
    self.phtoCells = [NSMutableArray array];
    [self setupView];
    [self createCell];
}

- (void)setupView
{
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view);
    }];
}

- (void)createCell {
    CLVAddPhotoTableViewCell *phtoCell = [[CLVAddPhotoTableViewCellDefault alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"phtocell"];
    [self.phtoCells addObject:phtoCell];
    CLVInfoTableViewCell *headimageCell = [[CLVEditImageTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"headImage" aboutTheme:@"头像" shouldShowBottomLine:YES];
    CLVEditTextTableViewCell *nameCell = [[CLVEditTextTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"nameCell" aboutTheme:@"昵称" shouldShowBottomLine:YES];
    nameCell.delegate = self;
    CLVEditButtonTableViewCell *sexCell = [[CLVEditButtonTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"sexCell" aboutTheme:@"性别" shouldShowBottomLine:YES];
    CLVEditAgeTableViewCell *ageCell = [[CLVEditAgeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ageCell" aboutTheme:@"年龄" shouldShowBottomLine:YES];
    CLVEditAddressTableViewCell *addressCell = [[CLVEditAddressTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"addressCell" aboutTheme:@"地址" shouldShowBottomLine:YES];
    CLVEditTextTableViewCell *descCell = [[CLVEditTextTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"descCell" aboutTheme:@"个性签名" shouldShowBottomLine:NO];
    descCell.delegate = self;
    
    [self.infoCells addObject:headimageCell];
    [self.infoCells addObject:nameCell];
    [self.infoCells addObject:sexCell];
    [self.infoCells addObject:ageCell];
    [self.infoCells addObject:addressCell];
    [self.infoCells addObject:descCell];
    
    for (UITableViewCell *it in self.infoCells) {
        it.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    for (UITableViewCell *it in self.phtoCells) {
        it.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    [self.cellNum addObject:[NSNumber numberWithInteger:self.phtoCells.count]];
    [self.cellNum addObject:[NSNumber numberWithInteger:self.infoCells.count]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - 键盘展开，点击非textfield区域，键盘收起

- (void)setUpForDismissKeyboard {
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAnywhereToDismissKeyboard:)];
    singleTap.delegate = self;
    
    [nc addObserverForName:UIKeyboardWillShowNotification
                    object:nil
                     queue:[NSOperationQueue mainQueue]
                usingBlock:^(NSNotification *note){
                    [self.view addGestureRecognizer:singleTap];
                }];
    [nc addObserverForName:UIKeyboardWillHideNotification
                    object:nil
                     queue:[NSOperationQueue mainQueue]
                usingBlock:^(NSNotification *note){
                    [self.view removeGestureRecognizer:singleTap];
                }];

}

- (void)tapAnywhereToDismissKeyboard:(UIGestureRecognizer *)gestureRecognizer {
    //此method会将self.view里所有的subview的first responder都resign掉
    [self.view endEditing:YES];
}

#pragma mark - tableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.cellNum[section] integerValue];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.cellNum.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell * cell = nil;
    switch (indexPath.section) {
        case 0:
            cell = self.phtoCells[indexPath.row];
            
            break;
        case 1:
            cell = self.infoCells[indexPath.row];
            
            break;
        default:
            break;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        CLVInfoTableViewCell *tableViewcell = [tableView cellForRowAtIndexPath:indexPath];
        self.convertCellRect = [self.view convertRect:tableViewcell.frame fromView:tableViewcell.superview];
        [tableViewcell didTapped];
        if (tableViewcell == self.infoCells[3] || tableViewcell == self.infoCells[4]) {
            [self.view endEditing:YES];
        }
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 0;
    }
    return 10;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01f;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor ld_colorWithHex:0xf6f6f6];
    return view;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor ld_colorWithHex:0xf6f6f6];
    return view;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.infoCells enumerateObjectsUsingBlock:^(
                                                 UITableViewCell*obj, NSUInteger idx, BOOL *stop) {
        if (obj.isFirstResponder) [obj resignFirstResponder];
    }];
    [self.view endEditing:YES];
}

#pragma mark - CLVEditTextCellDelegate
- (void)editTextFieldCellTextChanged:(CLVEditTextTableViewCell *)editTextFieldCell
{
    
}
- (void)editTextFieldCellShouldBeginEditing:(CLVEditTextTableViewCell *)editTextFieldCell
{
    self.convertCellRect = [self.view convertRect:editTextFieldCell.frame fromView:editTextFieldCell.superview];
}
- (void)editTextFieldCellShouldEndEditing:(CLVEditTextTableViewCell *)editTextFieldCell
{
    
}

#pragma mark - gestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if([touch.view isDescendantOfView:self.infoCells[4]] || [touch.view isDescendantOfView:self.infoCells[3]]) {
        return NO;
    } else {
        return YES;
    }
}


#pragma mark - Keyboard notification

- (void)keyboardWillShow:(NSNotification *)notification {
    //这样就拿到了键盘的位置大小信息frame，然后根据frame进行高度处理之类的信息
    CGRect keyboardFrame = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    // 所点击cell底部的Y值
    CGFloat textFieldBottomY = CGRectGetMaxY(self.convertCellRect) > CGRectGetMaxY(self.view.bounds) ? CGRectGetMaxY(self.view.bounds) : CGRectGetMaxY(self.convertCellRect);
    
    // 超出tableView底部的距离
    CGFloat beyondTableViewDistance = textFieldBottomY - CGRectGetMaxY(self.tableView.frame) > 0 ? textFieldBottomY - CGRectGetMaxY(self.tableView.frame) : 0;
    
    // 键盘顶部的Y值
    CGFloat keyboardTopY = CGRectGetHeight(self.view.bounds) - CGRectGetHeight(keyboardFrame);
    
    // 由于系统已经帮着移动了beyondTableViewDistance，所以计算原始位置时只需减去从tableView底部到键盘上部的距离
    self.originalContentOffset = CGPointMake(0, self.tableView.contentOffset.y - (self.pushDistance - self.beyondTableViewDistance));
    
    // 如果满足移动的条件则进去,0.1的设置是为了解决float类型数值比较时精确小数问题
    if (textFieldBottomY - keyboardTopY > 0.1) {
        // 计算当前键盘下要移动的距离
        self.pushDistance = textFieldBottomY - keyboardTopY;
        // 通过原始的距离和本次要移动的距离来计算出本次要移动的距离，这里减去beyondTableViewDistance，因为系统会默认的帮你把tableView提上来，self.pushDistance - beyondTableViewDistance，才是tableView底部到键盘上部的距离
        self.tableView.contentOffset = CGPointMake(0, self.originalContentOffset.y + (self.pushDistance - beyondTableViewDistance));
    }
    self.beyondTableViewDistance = beyondTableViewDistance;
}

- (void)keyboardWillHidden:(NSNotification *)notification {
    if (!self.pickerViewShow) {
        self.pushDistance = 0;
        self.beyondTableViewDistance = 0;
        [UIView animateWithDuration:0.25 animations:^{
            self.tableView.contentOffset = self.originalContentOffset;
            self.beyondTableViewDistance = 0;
        }];
    }
}

#pragma mark - KWAreaPickerView Notification

- (void)areaPickerViewWillShow:(NSNotification *)notification {
    CGFloat pickerViewHeight = [[[notification userInfo] objectForKey:KWAreaPickerViewFrameEndHeightInfoKey] floatValue];
    [self pickerViewWillShow:pickerViewHeight];
}

- (void)areaPickerViewWillHidden:(NSNotification *)notification {
    [self pickerViewWillHidden];
}

- (void)pickerViewWillShow:(CGFloat)pickerViewHeight {
    self.pickerViewShow = YES;
    // pickerViewCell的底边Y值
    CGFloat pickerViewCellBottomY = CGRectGetMaxY(self.convertCellRect) + self.pushDistance;
    // 键盘的Y值
    CGFloat pickerViewTopY = CGRectGetHeight(self.view.bounds) - pickerViewHeight;
    
    if (self.pushDistance == 0) {
        self.originalContentOffset = self.tableView.contentOffset;
    }
    // 如果成立，得到picker将要退出的距离
    if (pickerViewTopY < pickerViewCellBottomY) {
        
        CGFloat pickerWillDistance = pickerViewCellBottomY - pickerViewTopY;
        CGFloat finalDistance = self.pushDistance - pickerWillDistance;
        [UIView animateWithDuration:0.25 animations:^{
            self.tableView.contentOffset = CGPointMake(0, self.tableView.contentOffset.y - finalDistance);
        }];
    } else {
        [UIView animateWithDuration:0.25 animations:^{
            self.tableView.contentOffset = self.originalContentOffset;
        }];
    }
}

- (void)pickerViewWillHidden {
    self.pickerViewShow = NO;
    [UIView animateWithDuration:0.25 animations:^{
        self.pushDistance = 0;
        self.tableView.contentOffset = self.originalContentOffset;
    }];
}


#pragma mark - lazyLoad
- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] init];
        [self.view addSubview:_tableView];
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.estimatedRowHeight = 75;
        _tableView.backgroundColor = [UIColor ld_colorWithHex:0xf6f6f6];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}

@end
