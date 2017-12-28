//
//  UITextField+LDSelection.h
//  LDKitDemo
//
//  Created by lixingdong on 16/8/5.
//  written by xuguoxing on 13-6-28.
//  Copyright © 2016年 david. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextField (LDSelection)

- (NSRange)ld_selectedRange;

- (void)ld_setSelectedRange:(NSRange)range;

@end
