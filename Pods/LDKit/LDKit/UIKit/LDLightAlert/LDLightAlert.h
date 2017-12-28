//
//  LDLightAlert.h
//  LDKit
//
//  Derived from AlertView in LDCPCommon(Pod)
//  Created by Anchor on 17/3/1.
//  Copyright © 2017年 netease. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LDLightAlert : UIView

+ (void)ld_showMsg:(NSString *)msg duration:(NSTimeInterval)duration;

+ (void)ld_showMsg:(NSString *)msg
          duration:(NSTimeInterval)duration
             point:(CGPoint)point;

+ (void)ld_showMsg:(NSString *)msg
          duration:(NSTimeInterval)duration
            inView:(UIView *)superView;

+ (void)ld_showMsg:(NSString *)msg
          duration:(NSTimeInterval)duration
             point:(CGPoint)point
            inView:(UIView *)superView;

@end
