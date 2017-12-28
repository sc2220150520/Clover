//
//  NSString+LDAddition.h
//  LDKitDemo
//
//  Created by lixingdong on 16/8/12.
//  written by ITxiansheng on 16/8/6.
//  Copyright © 2016年 david. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (LDAddition)

- (BOOL)ld_isEmpty;

- (BOOL)ld_isAllChinese;

- (BOOL)ld_containsChinese;

/**
 将一个数字字符串转化成以逗号分隔千位的字符串
 
 @return 以逗号分隔千位的字符串
 @note 如果小数为0则去掉；如果不为0，则保留两位；
 */
- (NSString*)ld_thousandsDotString;

/*
 * 是否是IP地址
 */
- (BOOL)ld_isIPAddress;

/*
 * 是否是IPv4地址
 */
- (BOOL)ld_isIPv4Address;

/*
 * 是否是IPv6地址
 */
- (BOOL)ld_isIPv6Address;

@end
