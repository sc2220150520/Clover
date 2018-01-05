//
//  CLVFloatLayerDataSource.m
//  Clover
//
//  Created by shen chen on 2018/1/4.
//  Copyright © 2018年 shenchen. All rights reserved.
//

#import "CLVFloatLayerDataSource.h"
#import "CLVFLoatViewConstans.h"
#import "CLVFloatLayerTableCell.h"
#import "CLVFloatLayerView.h"

@implementation CLVFloatLayerDataSource

#pragma mark - init

- (instancetype)initWithModel:(id)model {
    self = [super init];
    if (self) {
        self.dataModel = model;
        //self.couponArray = [NSMutableArray array];
    }
    return self;
}

- (void)setUpTableViewDataSource:(UITableView *)tableView {
    tableView.dataSource = self;
    tableView.delegate = self;
}

#pragma mark - tableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if ([self.dataModel isKindOfClass:[NSMutableArray class]]) {
        return ((NSMutableArray *)self.dataModel).count;
    } else {
        return  0;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CLVFloatLayerTableCell *cell = nil;
    cell = [tableView dequeueReusableCellWithIdentifier:choosePhotoCell];
    if (cell == nil) {
        cell = [[CLVFloatLayerTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:choosePhotoCell];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    CLVActionType action = [((NSMutableArray *)self.dataModel)[indexPath.section] integerValue];
    switch (action) {
        case CLVTakePhoto:
        {
            [cell setContent:@"照相"];
            WeakSelf
            [cell setupAction:^{
                StrongSelf
                if ([[strongSelf viewControllerWithView:cell] respondsToSelector:@selector(takePhoto:)]) {
                    [[strongSelf viewControllerWithView:cell] performSelector:@selector(takePhoto:) withObject:nil];
                }
            }];
            break;
        }
        case CLVChoosePhoto:
        {
            [cell setContent:@"从相册选择照片"];
            WeakSelf
            [cell setupAction:^{
                StrongSelf
                if ([[strongSelf viewControllerWithView:cell] respondsToSelector:@selector(choosePhoto:)]) {
                    [[strongSelf viewControllerWithView:cell] performSelector:@selector(choosePhoto:) withObject:nil];
                }
            }];
            break;
        }
        case CLVSavePhoto:
            [cell setContent:@"保存"];
            break;
        case CLVDelete:
            [cell setContent:@"删除"];
            break;
        case CLVCancel:
        {
            [cell setContent:@"取消"];
            WeakSelf
            [cell setupAction:^(){
                StrongSelf
                [((CLVFloatLayerView *)[strongSelf floatLayerviewWithView:tableView]) hide];
            }];
            break;
        }
        default:
            
            break;
    }
    return cell;
}


#pragma mark - tableViewDelegate

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor ld_colorWithHex:0xf6f6f6];
    return view;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor ld_colorWithHex:0xf6f6f6];
    return view;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == ((NSMutableArray *)self.dataModel).count - 1) {
        return tableViewFooterHeigh;
    }
    return 0.01;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return tableViewHeadHeigh;
    }
    return cellGapHeigh;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    CLVFloatLayerTableCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [cell didTappedWithInfo:nil];
}

#pragma mark - 获得最顶层浮层View
- (CLVFloatLayerView *)floatLayerviewWithView:(UIView *)view {
    for (UIView *next = view.superview; next; next = next.superview) {
        //UIResponder *nextResponder = [next nextResponder];
        if ([next isKindOfClass:[CLVFloatLayerView class]]) {
            return (CLVFloatLayerView *)next;
        }
    }
    return nil;
}

- (UIViewController *)viewControllerWithView:(UIView *)view {
    for (UIView *next = view.superview; next; next = next.superview) {
        UIResponder *nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)nextResponder;
        }
    }
    return nil;
}
@end
