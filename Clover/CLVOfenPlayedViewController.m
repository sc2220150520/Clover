//
//  CLVOfenPlayedViewController.m
//  Clover
//
//  Created by shen chen on 2017/12/26.
//  Copyright © 2017年 shenchen. All rights reserved.
//

#import "CLVOfenPlayedViewController.h"
#import "CLVOftenPlayedGameView.h"
#import "COUserInforView.h"
#import "CLVOfenPlayedBottomView.h"
#import <Masonry.h>
#import "UserInfoModel.h"
#import "CLVEditUserInfoViewController.h"

@interface CLVOfenPlayedViewController ()

@property (nonatomic, strong) COUserInforView *userinfoView;
@property (nonatomic, strong) CLVOftenPlayedGameView *oftenPlayedView;
@property (nonatomic, strong) CLVOfenPlayedBottomView *bottomView;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIScrollView *scrollView;

@end

@implementation CLVOfenPlayedViewController

#pragma mark - lifeCircle
- (void)viewDidLoad {
    [super viewDidLoad];
    //注释
    //self.infoType = @"我的";
    self.edgesForExtendedLayout = UIRectEdgeAll;
    self.extendedLayoutIncludesOpaqueBars = NO;
    self.navigationController.navigationBar.translucent = YES;
    [self setupLayout];
    if (@available(iOS 11.0, *)) {
        self.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    self.scrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.scrollView.contentOffset = CGPointZero;
    [self setContent];
}

- (void)setupLayout {
    [self.view addSubview:self.scrollView];
    [self.scrollView addSubview:self.contentView];
    [self.contentView addSubview:self.userinfoView];
    [self.contentView addSubview:self.oftenPlayedView];
    [self.view addSubview:self.bottomView];
    
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view);
    }];
    
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.scrollView);
        make.width.equalTo(self.view);
        make.bottom.equalTo(self.oftenPlayedView);
    }];
    
    
    [self.userinfoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView);
        make.left.right.equalTo(self.contentView);
        make.height.equalTo(@489);
    }];
    
    UIView *fixView = [[UIView alloc] init];
    [self.contentView addSubview:fixView];
    [fixView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.contentView);
        make.height.equalTo(@10);
        make.top.equalTo(self.userinfoView.mas_bottom);
    }];
    fixView.backgroundColor = [UIColor ld_colorWithHex:0xf6f6f6];
    
    [self.oftenPlayedView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.contentView);
        make.top.equalTo(fixView.mas_bottom);
        make.height.equalTo(@172);
    }];
    
    if (self.bottomView) {
        [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.view);
            make.bottom.equalTo(self.view);
            make.height.equalTo(@72);
        }];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)setContent {
     UserInfoModel *user = [[UserInfoModel alloc] initWithname:@"小丸子" image:@" " sex:@"男" address:@"北京朝阳" idnum:@"09032" desc:@"刮风要下雨雷欧" age:@"19"];
    [self.userinfoView setContent:user];
    UIImage *image = [UIImage imageNamed:@"Group 5 Copy 10@2x.png"];
    NSMutableArray * array = [NSMutableArray arrayWithObjects:image, nil];
    [self.oftenPlayedView setContent:array];
}

#pragma mark - 按钮点击
- (void)enterEditeViewController:(id)sender {
    CLVEditUserInfoViewController *editVC = [[CLVEditUserInfoViewController alloc] init];
    [self.navigationController pushViewController:editVC animated:YES];
}

#pragma mark - lzayLoad
- (COUserInforView *)userinfoView {
    if (_userinfoView == nil) {
        if ([self.infoType isEqualToString:@"我的"]) {
            _userinfoView = [[COUserInfoDetailS alloc] init];
        } else {
            _userinfoView = [[COUserInfoDetailP alloc] init];
        }
        return _userinfoView;
    }
    return _userinfoView;
}

- (CLVOftenPlayedGameView *)oftenPlayedView {
    if (_oftenPlayedView == nil) {
        _oftenPlayedView = [[CLVDefaultOftenPlayedGameView alloc] init];
    }
    return _oftenPlayedView;
}

- (CLVOfenPlayedBottomView *)bottomView {
    if (_bottomView == nil) {
        if ([self.infoType isEqualToString:@"好友"]) {
            _bottomView = [[CLVOfenPlayedBottomViewFri alloc] init];
        } else if ([self.infoType isEqualToString:@"路人"]) {
            _bottomView = [[CLVOfenPlayedBottomViewStranger alloc] init];
        }
    }
    return _bottomView;
}

- (UIScrollView *)scrollView {
    if (_scrollView == nil) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.backgroundColor = [UIColor clearColor];
    }
    return _scrollView;
}

- (UIView *)contentView {
    if (_contentView == nil) {
        _contentView = [[UIView alloc] init];
    }
    return _contentView;
}
@end
