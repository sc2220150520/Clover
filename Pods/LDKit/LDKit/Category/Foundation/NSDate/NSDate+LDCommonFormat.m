//
//  NSDate+LDCommonFormat.m
//  Pods
//
//  Created by bjliulei3 on 2017/6/29.
//
//

#import "NSDate+LDCommonFormat.h"

@implementation NSDate (LDCommonFormat)

+ (NSDate *)dateWithShortFormatString:(NSString *)dateString {
    static NSDateFormatter *formatter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyyMMdd";
    });
    return [formatter dateFromString:dateString];
}

- (NSString *)stringWithShortFormat {
    static NSDateFormatter *formatter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyyMMdd";
    });
    return [formatter stringFromDate:self];
}

+ (NSDate *)dateWithMiddleFormatString:(NSString *)dateString {
    static NSDateFormatter *midFormatter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        midFormatter = [[NSDateFormatter alloc] init];
        midFormatter.dateFormat = @"yyyy-MM-dd";
    });
    return [midFormatter dateFromString:dateString];
}

- (NSString *)stringWithMiddleFormat {
    static NSDateFormatter *midFormatter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        midFormatter = [[NSDateFormatter alloc] init];
        midFormatter.dateFormat = @"yyyy-MM-dd";
    });
    return [midFormatter stringFromDate:self];
}

+ (NSDate *)dateWithLongFormatString:(NSString *)dateString {
    static NSDateFormatter *longFormatter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        longFormatter = [[NSDateFormatter alloc] init];
        longFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    });
    return [longFormatter dateFromString:dateString];
}

- (NSString *)stringWithLongFormat {
    static NSDateFormatter *longFormatter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        longFormatter = [[NSDateFormatter alloc] init];
        longFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    });
    return [longFormatter stringFromDate:self];
}
@end
