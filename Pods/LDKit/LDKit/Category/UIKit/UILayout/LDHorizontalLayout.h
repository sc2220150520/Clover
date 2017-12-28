//
//  LDHorizontalLayout.h
//  LDKitDemo
//
//  Created by lixingdong on 17/3/17.
//  Copyright © 2017年 LDKit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UILayoutDefines.h"

@interface LDLayoutItem : NSObject

@property(nonatomic,strong) UIView *view;
@property(nonatomic) CGFloat spacing;
@property(nonatomic) LDLayoutOptionMask layoutOptionMask;

- (BOOL)isEqual:(id)object;

@end

@interface LDLayoutBase : UIView {
@protected
    UIView *_backgroundView;
    UIImageView *_shadowView;
    NSMutableArray *_layoutItems;
}

@property(nonatomic) NSUInteger contentLayoutOption;
@property(nonatomic) CGSize minimumSize; //size limit when resizeToContent
@property(nonatomic) CGSize maximumSize; //size limit when resizeToContent
@property(nonatomic) UIEdgeInsets contentInsets;
@property(nonatomic) UIEdgeInsets backgroundShadow;

+ (instancetype)layoutWithSubviews:(NSArray *)subviews;

- (void)resizeToContent;

- (CGSize)neededSizeForContent;

@end

@interface LDHorizontalLayout : LDLayoutBase


@end
