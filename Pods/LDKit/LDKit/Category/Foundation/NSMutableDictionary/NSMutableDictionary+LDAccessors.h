//
//  NSMutableDictionary+LDAccessors.h
//  LDKitDemo
//
//  Created by lixingdong on 16/8/12.
//  written by junmin liu on 10-10-6.
//  Copyright © 2016年 david. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableDictionary (LDAccessors)

-(void)ld_setValidObject:(id)anObject forKey:(id)aKey;

-(void)ld_setInteger:(NSInteger)value forKey:(id)key;

-(void)ld_setDouble:(double)value forKey:(id)key;

- (void)ld_safeSetObject:(id)anObject forKey:(id<NSCopying>)aKey;

@end
