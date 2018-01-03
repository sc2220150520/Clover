//
//  CLVDateDatabaseService.h
//  Clover
//
//  Created by shen chen on 2018/1/2.
//  Copyright © 2018年 shenchen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CLVDateDatabaseService : NSObject

- (NSArray *)years;
- (NSArray *)monthsWithYears:(NSString *)year;
- (NSArray *)daysWithYears:(NSString *)year Month:(NSString *)month;

@end
