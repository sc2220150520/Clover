//
//  CLVDateDatabaseService.m
//  Clover
//
//  Created by shen chen on 2018/1/2.
//  Copyright © 2018年 shenchen. All rights reserved.
//

#import "CLVDateDatabaseService.h"
#import <NSDate+LDAddition.h>
#if __has_include(<sqlite3.h>)
#import <sqlite3.h>
#else
#error "Please import libsqlite3.tbd"
#endif

#define STARTYEAR 1919

@implementation CLVDateDatabaseService

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (NSArray *)years {
    NSMutableArray *retval = [NSMutableArray new];
    NSDate *now = [NSDate date];
    NSDateComponents *componts = [now ld_dateComponents];
    NSInteger endyear = [componts year];
    for (int year = STARTYEAR; year <= endyear; year++) {
        
        NSString *str = [NSString stringWithFormat:@"%d", year];
        
        [retval addObject:str];
    }
    return [retval copy];
}
- (NSArray *)monthsWithYears:(NSString *)year {
    NSMutableArray *monthArray = [NSMutableArray array];
    NSDate *now = [NSDate date];
    NSDateComponents *componts = [now ld_dateComponents];
    NSInteger currentYear = [componts year];
    if ([year integerValue] < currentYear) {
        for (int month = 1; month <= 12; month++) {
            NSString *str = [NSString stringWithFormat:@"%02d", month];
            [monthArray addObject:str];
        }
    } else if ([year integerValue] == currentYear) {
        for (int month = 1; month <= [componts month]; month++) {
            NSString *str = [NSString stringWithFormat:@"%02d", month];
            [monthArray addObject:str];
        }
    }
    return [monthArray copy];
}
- (NSArray *)daysWithYears:(NSString *)year Month:(NSString *)month {
    NSMutableArray *dayArray = [NSMutableArray array];
    NSInteger endDay = 31;
    switch ([month integerValue]) {
        case 1:
        case 3:
        case 5:
        case 7:
        case 8:
        case 10:
        case 12:
            endDay = 31;
            break;
        case 4:
        case 6:
        case 9:
        case 11:
            endDay = 30;
        default:
            endDay = 28;
            break;
    }
    NSInteger yeari = [year integerValue];
    if((yeari % 4 == 0 && yeari % 100 != 0) || yeari % 400 == 0) {
        if ([month integerValue] == 2) {
            endDay = 29;
        }
    }
    NSDate *now = [NSDate date];
    NSDateComponents *componts = [now ld_dateComponents];
    NSInteger currentYear = [componts year];
    NSInteger currentMonth = [componts month];
    if (currentYear == yeari && currentMonth == [month integerValue]) {
        endDay = [componts day];
    }
    for (int day = 1; day <= endDay; day++) {
        NSString *str = [NSString stringWithFormat:@"%02d", day];
        [dayArray addObject:str];
    }
    return [dayArray copy];
}

@end
