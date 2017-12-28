//
//  NSMutableArray+LDAddition.m
//  LDKitDemo
//
//  Created by lixingdong on 16/8/5.
//  Copyright © 2016年 david. All rights reserved.
//

#import "NSMutableArray+LDAddition.h"

NSInteger ld_sort(id object1, id object2, void *context)
{
    NSString *string1 = (NSString *) object1;
    NSString *string2 = (NSString *) object2;
    return [string1 compare:string2];
}

NSInteger ld_revertSort(id object1, id object2, void *context)
{
    NSString *string1 = (NSString *) object1;
    NSString *string2 = (NSString *) object2;
    return [string2 compare:string1];
}

@implementation NSMutableArray (LDAddition)

- (void)ld_safeAddObject:(id)anObject
{
    if (anObject != nil) {
        [self addObject:anObject];
    }
}

- (void)ld_mergeStringArray:(NSArray *)array
{
    if (self.count > 0) {
        id object = [self objectAtIndex:0];
        if (![object isKindOfClass:[NSString class]]) {
            return;
        }
    }
    if (array.count <= 0) {
        return;
    }
    id object = [array objectAtIndex:0];
    if (![object isKindOfClass:[NSString class]]) {
        return;
    }
    for (NSString *outString in array) {
        BOOL find = NO;
        for (NSString *inString in self) {
            if ([outString isEqualToString:inString]) {
                find = YES;
                break;
            }
        }
        if (find == NO) {
            [self addObject:outString];
        }
        
    }
}

- (void)ld_sortString
{
    if (self.count > 0) {
        id object = [self objectAtIndex:0];
        if (![object isKindOfClass:[NSString class]]) {
            return;
        }
    }
    [self sortUsingFunction:ld_sort context:nil];
}

- (void)ld_revertSortString
{
    if (self.count > 0) {
        id object = [self objectAtIndex:0];
        if (![object isKindOfClass:[NSString class]]) {
            return;
        }
    }
    [self sortUsingFunction:ld_revertSort context:nil];
}


@end
