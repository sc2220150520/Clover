//
//  NSMutableSet+LDEqualSet.h
//  LDKitDemo
//
//  Created by lixingdong on 16/8/5.
//  written by xuguoxing on 13-8-28.
//  Copyright © 2016年 david. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableSet (LDEqualSet)

- (void)ld_addEqualObject:(id)object;

- (void)ld_removeEqualObject:(id)object;

- (BOOL)ld_containsEqualObject:(id)anObject;

- (void)ld_unionEqualSet:(NSSet *)otherSet;

- (void)ld_minusEqualSet:(NSSet *)otherSet;

- (void)ld_intersectEqualSet:(NSSet *)otherSet;

@end
