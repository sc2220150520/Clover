//
//  NSAttributedString+LDAddition.m
//  LDKitDemo
//
//  Created by lixingdong on 16/8/12.
//  Copyright © 2016年 david. All rights reserved.
//

#import "NSAttributedString+LDAddition.h"

@implementation NSAttributedString (LDAddition)

- (BOOL)ld_isEmpty
{
    if(self == nil || self.length == 0) {
        return YES;
    }
    return NO;
}

@end
