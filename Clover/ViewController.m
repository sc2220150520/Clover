//
//  ViewController.m
//  Clover
//
//  Created by shen chen on 2017/12/22.
//  Copyright © 2017年 shenchen. All rights reserved.
//

#import "ViewController.h"
#import <Masonry.h>
#import "COSetUpTableViewCell.h"
#import "COSetupModel.h"
#import "UserInfoModel.h"
#import "CLVOfenPlayedViewController.h"

@interface ViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *data;
@end

@implementation ViewController

#pragma mark - init
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"在下一橙";
    self.view.backgroundColor = [UIColor whiteColor];
    self.edgesForExtendedLayout = UIRectEdgeAll;
    self.extendedLayoutIncludesOpaqueBars = NO;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                             forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;
    
    self.data = [NSMutableArray array];
    [self createData];
    [self setupTableView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)setupTableView {
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    UIView *refreshBgView = [[UIView alloc] init];
    refreshBgView.backgroundColor = [UIColor ld_colorWithHex:0xEC4D4C];
    [self.tableView insertSubview:refreshBgView atIndex:0];
    [refreshBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self.view);
        make.top.equalTo(self.tableView).offset(-504);
        make.bottom.equalTo(self.tableView.mas_top);
    }];
}

- (void)createData {
    UserInfoModel *user = [[UserInfoModel alloc] initWithname:@"小丸子" image:@" " sex:@"男" address:@"北京朝阳" idnum:@"09032" desc:@"刮风要下雨雷欧" age:@"19"];
    NSArray *arr = [NSArray arrayWithObjects:user, nil];
    [self.data addObject:arr];
    COSetupModel *qa = [[COSetupModel alloc] initWithimageUrl:@"" text:@"问题反馈" num:@"9"];
    COSetupModel *inVitation = [[COSetupModel alloc] initWithimageUrl:@"" text:@"邀请好友" num:@""];
    COSetupModel *help = [[COSetupModel alloc] initWithimageUrl:@"" text:@"游戏帮助" num:@""];
    COSetupModel *setup = [[COSetupModel alloc] initWithimageUrl:@"" text:@"设置" num:@""];
    NSArray *array = [NSArray arrayWithObjects:qa,inVitation,help,setup, nil];
    [self.data addObject:array];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - tableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section < self.data.count) {
        return ((NSArray *)self.data[section]).count;
    } else {
        return  0;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    COSetUpTableViewCell *cell = nil;
    if (indexPath.section == 0) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"inforCell"];
        if (cell == nil) {
            cell = [[COConcretInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"inforCell" shouldShowBottomLine:NO];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        [cell setContent:self.data[indexPath.section][indexPath.row]];
    } else {
        cell = [tableView dequeueReusableCellWithIdentifier:@"setupCell"];
        if (cell == nil) {
            cell = [[COConcretSetUpCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"setupCell" shouldShowBottomLine:YES];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        [cell setContent:self.data[indexPath.section][indexPath.row]];
        if (indexPath.row == ((NSMutableArray *)self.data[indexPath.section]).count - 1) {
            cell.shouldShowBottomLine = NO;
            [cell setNeedsDisplay];
        }
    }
    return cell;
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

#pragma mark - 个人信息页点击手势响应
- (void)userInfoViewTapped:(id)sender {
    CLVOfenPlayedViewController *oftenVC = [[CLVOfenPlayedViewController alloc] init];
    oftenVC.infoType = @"我的";
    [self.navigationController pushViewController:oftenVC animated:YES];
}
#pragma mark - lazyLoad
- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] init];
        [self.view addSubview:_tableView];
        _tableView.backgroundColor = [UIColor ld_colorWithHex:0xf6f6f6];
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.estimatedRowHeight = 75;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}

@end
