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

@interface CLVEditUserInfoViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *cellNum;
@property (nonatomic, strong) NSMutableArray *phtoCells;
@property (nonatomic, strong) NSMutableArray *infoCells;
@end

@implementation CLVEditUserInfoViewController

#pragma mark - lifeCircle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.extendedLayoutIncludesOpaqueBars = NO;
    self.navigationController.navigationBar.translucent = NO;
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
    CLVEditButtonTableViewCell *sexCell = [[CLVEditButtonTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"sexCell" aboutTheme:@"性别" shouldShowBottomLine:YES];
    CLVEditAgeTableViewCell *ageCell = [[CLVEditAgeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ageCell" aboutTheme:@"年龄" shouldShowBottomLine:YES];
    CLVEditAddressTableViewCell *addressCell = [[CLVEditAddressTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"addressCell" aboutTheme:@"地址" shouldShowBottomLine:YES];
    CLVEditTextTableViewCell *descCell = [[CLVEditTextTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"descCell" aboutTheme:@"个性签名" shouldShowBottomLine:NO];
    
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
        [tableViewcell didTapped];
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
