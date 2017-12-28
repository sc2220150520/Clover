//
//  UITableViewCell+LDSeparatorLine.h
//  LDKitDemo
//
//  Created by lixingdong on 16/8/8.
//  written by SongLi on 15/7/28.
//  Copyright © 2016年 david. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableViewCell (LDSeparatorLine)

/**
 *  This view is set to CGRectMake(0, 0, CGRectGetWidth(self.contentView.bounds), 0.5) by default.
 *  The default color is [UIColor lightGrayColor].
 *  @warning DO NOT layout this view manually! Set topSeparatorLineInsets instead!
 */
@property (strong, nonatomic, readonly) UIView *ld_topSeparatorLine;

/**
 *  This view is set to CGRectMake(0, CGRectGetHeight(self.contentView.bounds) - 0.5, CGRectGetWidth(self.contentView.bounds), 0.5) by default.
 *  The default color is [UIColor lightGrayColor].
 *  @warning DO NOT layout this view manually! Set bottomSeparatorLineInsets instead!
 */
@property (strong, nonatomic, readonly) UIView *ld_bottomSeparatorLine;

/**
 *  You can use this property to add space between the current cell’s contents and the left, right and top edges of the table. Positive inset values move the cell content and cell separator inward and away from the table edges. Negative values are treated as if the inset is set to 0.
 *
 *  Values that less than 1.0 in horizontal edges are considered as percentage of CGRectGetWidth(self.contentView.bounds).
 *
 *  Only the left, right and top inset values are respected; the bottom inset values are ignored. The value assigned to this property takes precedence over any default separator insets set on the table view.
 */
@property (assign, nonatomic) UIEdgeInsets ld_topSeparatorLineInsets;

/**
 *  You can use this property to add space between the current cell’s contents and the left, right and bottom edges of the table. Positive inset values move the cell content and cell separator inward and away from the table edges. Negative values are treated as if the inset is set to 0.
 *
 *  Values that less than 1.0 in horizontal edges are considered as percentage of CGRectGetWidth(self.contentView.bounds).
 *
 *  Only the left, right and bottom inset values are respected; the top inset values are ignored. The value assigned to this property takes precedence over any default separator insets set on the table view.
 */
@property (assign, nonatomic) UIEdgeInsets ld_bottomSeparatorLineInsets;

/**
 *  Show top separator line
 */
- (void)ld_showTopSeparatorLine;

/**
 *  Hide top separator line
 */
- (void)ld_hideTopSeparatorLine;

/**
 *  Set top separator line height.
 *  The default height is 0.5
 */
- (void)ld_setTopSeparatorLineHeight:(CGFloat)height;

/**
 *  Set top separator line color.
 *  The default color is [UIColor lightGrayColor]
 */
- (void)ld_setTopSeparatorLineColor:(UIColor *)color;

/**
 *  Show bottom separator line
 */
- (void)ld_showBottomSeparatorLine;

/**
 *  Hide bottom separator line
 */
- (void)ld_hideBottomSeparatorLine;

/**
 *  Set bottom separator line height
 *  The default height is 0.5
 */
- (void)ld_setBottomSeparatorLineHeight:(CGFloat)height;

/**
 *  Set bottom separator line color.
 *  The default color is [UIColor lightGrayColor]
 */
- (void)ld_setBottomSeparatorLineColor:(UIColor *)color;

@end
