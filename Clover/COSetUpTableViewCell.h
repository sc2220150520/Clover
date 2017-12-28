//
//  COSetUpTableViewCell.h
//  Clover
//
//  Created by shen chen on 2017/12/25.
//  Copyright © 2017年 shenchen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface COSetUpTableViewCell : UITableViewCell
@property (nonatomic, assign) BOOL shouldShowBottomLine;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier shouldShowBottomLine:(BOOL)shouldShowBottomLine;
- (void) addSubViews;
- (void) setUpLayOut;
- (void) setStyle;
- (void) setContent:(id)model;
@end

@interface COConcretSetUpCell:COSetUpTableViewCell

@end;

@interface COConcretInfoCell:COSetUpTableViewCell

@end;
