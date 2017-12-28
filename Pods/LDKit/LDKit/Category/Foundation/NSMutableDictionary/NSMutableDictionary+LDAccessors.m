//
//  NSMutableDictionary+LDAccessors.m
//  LDKitDemo
//
//  Created by lixingdong on 16/8/12.
//  Copyright © 2016年 david. All rights reserved.
//

#import "NSMutableDictionary+LDAccessors.h"

@implementation NSMutableDictionary (LDAccessors)

- (void)ld_setInteger:(NSInteger)value forKey:(id)key
{
    [self setValue:[NSNumber numberWithInteger:value]
            forKey:key];
}

- (void)ld_setValidObject:(id)anObject forKey:(id)aKey
{
    if (anObject) {
        [self setObject:anObject forKey:aKey];
    } else {
#ifdef DEBUG
        NSAssert(0, @"ld_setValidObject object is nil");
#endif
    }
}

- (void)ld_setDouble:(double)value forKey:(id)key
{
    [self setValue:[NSNumber numberWithDouble:value]
            forKey:key];
}

- (void)ld_safeSetObject:(id)anObject forKey:(id<NSCopying>)aKey
{
    if (anObject != nil && aKey != nil) {
        [self setObject:anObject forKey:aKey];
    } else {
#ifdef DEBUG
        NSAssert(0, @"ld_safeSetObject object or key is nil");
#endif
    }
}

@end
