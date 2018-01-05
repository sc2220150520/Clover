//
//  CLVFloatLayerDataSource.h
//  Clover
//
//  Created by shen chen on 2018/1/4.
//  Copyright © 2018年 shenchen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CLVFloatLayerDataSource : NSObject <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) id dataModel;

- (instancetype)initWithModel:(id)model;
- (void)setUpTableViewDataSource:(UITableView *)tableView;

@end
