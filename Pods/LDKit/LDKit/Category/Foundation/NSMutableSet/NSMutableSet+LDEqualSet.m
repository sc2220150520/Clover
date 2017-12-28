//
//  NSMutableSet+LDEqualSet.m
//  LDKitDemo
//
//  Created by lixingdong on 16/8/5.
//  Copyright © 2016年 david. All rights reserved.
//

#import "NSMutableSet+LDEqualSet.h"

@implementation NSMutableSet (LDEqualSet)

- (void)ld_addEqualObject:(id)object
{
    id member = [self member:object];
    if (!member) {
        [self addObject:object];
    }
}

- (void)ld_removeEqualObject:(id)object
{
    id member = [self member:object];
    if (member) {
        [self removeObject:member];
    }
}

- (BOOL)ld_containsEqualObject:(id)anObject
{
    return ([self member:anObject] != nil);
}

- (void)ld_unionEqualSet:(NSSet *)otherSet
{
    for (id object in otherSet) {
        [self ld_addEqualObject:object];
    }
}

- (void)ld_minusEqualSet:(NSSet *)otherSet
{
    for (id object in otherSet) {
        [self ld_removeEqualObject:object];
    }
}

- (void)ld_intersectEqualSet:(NSSet *)otherSet
{
    NSMutableSet *deleteSet = [NSMutableSet set];
    for (id object in self) {
        if (![otherSet member:object]) {
            [deleteSet addObject:object];
        }
    }
    [self minusSet:deleteSet];
}

@end
