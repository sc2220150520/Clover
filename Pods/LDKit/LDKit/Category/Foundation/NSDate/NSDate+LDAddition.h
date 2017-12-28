//
//  NSDate+LDAddition.h
//  LDKitDemo
//
//  Created by david on 16/8/4.
//  written by huihu long by huihu long on 12-4-6.
//  Copyright © 2016年 david. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (LDAddition)

/**
 *  将string按照给定的日期格式转化成NSDate对象.
 *
 *  @param string 要转化成NSDate的字符串.
 *
 *  @param dateFormat string的日期格式.
 *
 *  @return 若string和格式与dateFormat相符, 返回对应NSDate对象; 若string格式与dateFormat不符, 返回nil.
 */
+ (NSDate *)ld_dateWithString:(NSString *)string dateFormat:(NSString *)dateFormat;

/**
 *  转化成具有给定日期格式的字符串.
 */
- (NSString *)ld_stringWithDateFormat:(NSString *)dateFormat;

/**
 *  判断与给定日期是否是同一天.
 */
- (BOOL)ld_isSameDayWithDate:(NSDate *)date;

/**
 *  获取日期的年、月、日、周信息
 */
- (NSDateComponents *)ld_dateComponents;

/**
 明天（24*3600s之后）
 */
- (NSDate *)tomorrow;

/**
 昨天（24*3600s之前）
 */
- (NSDate *)yesterday;

/**
 当前日期的本地字符串
 */
- (NSString *)localeString;
@end
