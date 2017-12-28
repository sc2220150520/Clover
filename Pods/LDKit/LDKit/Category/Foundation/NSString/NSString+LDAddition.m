//
//  NSString+LDAddition.m
//  LDKitDemo
//
//  Created by lixingdong on 16/8/12.
//  Copyright © 2016年 david. All rights reserved.
//

#import "NSString+LDAddition.h"
#include <arpa/inet.h>
#include <ifaddrs.h>

@implementation NSString (LDAddition)

- (BOOL)ld_isEmpty{
    if(self == nil || self.length == 0){
        return YES;
    }
    return NO;
}

- (BOOL)ld_isAllChinese
{
    NSString *match = @"(^[\u4e00-\u9fa5]+$)";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF matches %@", match];
    return [predicate evaluateWithObject:self];
}

- (BOOL)ld_containsChinese
{
    for(int i=0; i< [self length];i++)
    {
        int a =[self characterAtIndex:i];
        if( a >0x4e00&& a <0x9fff){
            return YES;
        }
    }
    return NO;
}

- (NSString*)ld_thousandsDotString
{
    double doubleValue = [self doubleValue];
    int64_t middleValue = doubleValue * 100;
    int decimals = middleValue % 100;
    
    NSString *decimalsString;
    if (decimals != 0) {
        if (decimals >= 10) {
            decimalsString = [NSString stringWithFormat:@".%d", decimals];
        }else{
            decimalsString = [NSString stringWithFormat:@".0%d", decimals];
        }
    }
    int64_t longValue = [self longLongValue];
    if (longValue > 1000) {
        NSMutableArray *valueArray = [NSMutableArray array];
        while (longValue > 0) {
            NSInteger num = longValue % 1000;
            [valueArray addObject:@(num)];
            longValue = longValue / 1000;
        }
        NSString *text = [NSString stringWithFormat:@"%@", [valueArray lastObject]];
        for (NSInteger i = [valueArray count] - 2; i > -1; i--) {
            NSNumber *number = [valueArray objectAtIndex:i];
            NSString *numberString;
            if ([number integerValue] > 100) {
                numberString = [NSString stringWithFormat:@"%@", number];
            }else if ([number integerValue] > 10){
                numberString = [NSString stringWithFormat:@"0%@", number];
            }else{
                numberString = [NSString stringWithFormat:@"00%@", number];
            }
            text = [text stringByAppendingString:@","];
            text = [text stringByAppendingString:numberString];
        }
        if (decimalsString) {
            text = [text stringByAppendingString:decimalsString];
        }
        return text;
    }else{
        NSString *text = [NSString stringWithFormat:@"%lld", longValue];
        if (decimalsString) {
            text = [text stringByAppendingString:decimalsString];
        }
        return text;
    }
}

- (BOOL)ld_isIPAddress
{
    return [self ld_isIPv4Address] || [self ld_isIPv6Address];
}

- (BOOL)ld_isIPv4Address
{
    if (self.length <= 0) {
        return NO;
    }
    
    const char *ip = [self UTF8String];
    int success = 0;
    struct in_addr addr;
    success = inet_pton(AF_INET, ip, &addr);
    
    return (success == 1);
}

- (BOOL)ld_isIPv6Address
{
    if (self.length <= 0) {
        return NO;
    }
    
    const char *ip = [self UTF8String];
    int success = 0;
    struct in_addr addr;
    success = inet_pton(AF_INET6, ip, &addr);
    
    return (success == 1);
}

@end
