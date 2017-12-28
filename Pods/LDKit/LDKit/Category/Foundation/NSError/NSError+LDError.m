//
//  NSError+LDError.m
//  Pods
//
//  Created by wuxu on 10/21/2015.
//  Copyright (c) 2015 wuxu. All rights reserved.
//

#import "NSError+LDError.h"

@implementation NSError (LDError)

+ (instancetype)ld_errorWithCode:(NSInteger)code description:(NSString *)localizedDesc
{
    NSDictionary *userInfo;
    if (localizedDesc.length) {
        userInfo = @{NSLocalizedDescriptionKey:localizedDesc};
    }
    return [self errorWithDomain:@"com.lede.error" code:code userInfo:userInfo];
}

@end

@implementation NSError (LDNetError)

+ (instancetype)ld_serviceBusy
{
    return [self ld_errorWithCode:800 description:@"网络请求忙"];
}

+ (instancetype)ld_parseDataError
{
    return [self ld_errorWithCode:801 description:@"数据解析错误"];
}

+ (instancetype)ld_networkError
{
    return [self ld_errorWithCode:802 description:@"网络错误"];
}

+ (instancetype)ld_paramsError
{
    return [self ld_errorWithCode:803 description:@"参数错误"];
}

@end
