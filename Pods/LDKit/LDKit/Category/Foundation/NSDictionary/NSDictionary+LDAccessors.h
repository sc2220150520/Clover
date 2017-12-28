//
//  NSDictionary+LDAccessors.h
//  LDKitDemo
//
//  Created by lixingdong on 16/8/8.
//  written by Allen Hsu on 1/11/14.
//  Copyright © 2016年 david. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (LDAccessors)

- (BOOL)ld_isKindOfClass:(Class)aClass forKey:(NSString *)key;

- (BOOL)ld_isMemberOfClass:(Class)aClass forKey:(NSString *)key;

- (BOOL)ld_isArrayForKey:(NSString *)key;

- (BOOL)ld_isDictionaryForKey:(NSString *)key;

- (BOOL)ld_isStringForKey:(NSString *)key;

- (BOOL)ld_isNumberForKey:(NSString *)key;

- (NSArray *)ld_arrayForKey:(NSString *)key;

- (NSDictionary *)ld_dictionaryForKey:(NSString *)key;

- (NSString *)ld_stringForKey:(NSString *)key;

- (NSNumber *)ld_numberForKey:(NSString *)key;

- (double)ld_doubleForKey:(NSString *)key;

- (float)ld_floatForKey:(NSString *)key;

- (int)ld_intForKey:(NSString *)key;

- (unsigned int)ld_unsignedIntForKey:(NSString *)key;

- (NSInteger)ld_integerForKey:(NSString *)key;

- (NSUInteger)ld_unsignedIntegerForKey:(NSString *)key;

- (long long)ld_longLongForKey:(NSString *)key;

- (unsigned long long)ld_unsignedLongLongForKey:(NSString *)key;

- (BOOL)ld_boolForKey:(NSString *)key;


@end
