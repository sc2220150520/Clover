//
//  NSDate+LDAddition.m
//  LDKitDemo
//
//  Created by david on 16/8/4.
//  Copyright © 2016年 david. All rights reserved.
//

#import "NSDate+LDAddition.h"

@implementation NSDate (LDAddition)

+ (NSDate *)ld_dateWithString:(NSString *)string dateFormat:(NSString *)dateFormat
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:dateFormat];
    return [dateFormatter dateFromString:string];
}

- (BOOL)ld_isSameDayWithDate:(NSDate *)date
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *dateComponents = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:date];
    NSDateComponents *selfComponents = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:self];
    return (dateComponents.year == selfComponents.year) && (dateComponents.month == selfComponents.month) && (dateComponents.day == selfComponents.day);
}

- (NSString *)ld_stringWithDateFormat:(NSString *)dateFormat
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:dateFormat];
    return [dateFormatter stringFromDate:self];
}

- (NSDateComponents *)ld_dateComponents
{
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *comps = [gregorian components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday fromDate:self];
    return comps;
}

- (NSDate *)tomorrow
{
    return [[NSDate alloc] initWithTimeInterval:24 * 3600 sinceDate:self];
}

- (NSDate *)yesterday
{
    return [[NSDate alloc] initWithTimeInterval: - 24 * 3600 sinceDate:self];
}

- (NSString *)localeString
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    
    NSLocale *locale = [NSLocale currentLocale];
    [dateFormatter setLocale:locale];
    
    return [dateFormatter stringFromDate:self];
}
@end
