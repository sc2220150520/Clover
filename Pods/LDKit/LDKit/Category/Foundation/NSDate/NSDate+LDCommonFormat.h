//
//  NSDate+LDCommonFormat.h
//  Pods
//
//  Created by bjliulei3 on 2017/6/29.
//
//

#import <Foundation/Foundation.h>

@interface NSDate (LDCommonFormat)

/**
 根据 yyyyMMdd 格式字符串生成 NSDate
 */
+ (NSDate *)dateWithShortFormatString:(NSString *)dateString;
/**
 生成 yyyyMMdd 格式字符串
 */
- (NSString *)stringWithShortFormat;
/**
 根据 yyyy-MM-dd 格式字符串生成 NSDate
 */
+ (NSDate *)dateWithMiddleFormatString:(NSString *)dateString;
/**
 生成 yyyy-MM-dd 格式字符串
 */
- (NSString *)stringWithMiddleFormat;
/**
 根据 yyyy-MM-dd HH:mm:ss 格式字符串生成 NSDate
 */
+ (NSDate *)dateWithLongFormatString:(NSString *)dateString;
/**
 生成 yyyy-MM-dd HH:mm:ss 格式字符串
 */
- (NSString *)stringWithLongFormat;

@end
