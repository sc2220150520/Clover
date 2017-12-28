//
//  NSMutableArray+LDAddition.h
//  LDKitDemo
//
//  Created by lixingdong on 16/8/5.
//  written by yangning on 15-2-11.
//  written by xuguoxing on 12-5-17.
//  Copyright © 2016年 david. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableArray (LDAddition)

- (void)ld_safeAddObject:(id)anObject;

- (void)ld_mergeStringArray:(NSArray *)array;

- (void)ld_sortString;

- (void)ld_revertSortString;

@end
