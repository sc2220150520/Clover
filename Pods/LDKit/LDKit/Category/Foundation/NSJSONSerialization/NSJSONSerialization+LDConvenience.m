//
//  NSJSONSerialization+LDConvenience.m
//  LDKit
//
//  Created by lixingdong on 16/8/12.
//  Copyright © 2016年 netease. All rights reserved.
//

#import "NSJSONSerialization+LDConvenience.h"

NSString *const LDKitJSONSerializationErrorDomain = @"jsonparse.ldkit.netease";
const NSInteger LDKitJSONParseDataEmptyCode = 9101;

@implementation NSJSONSerialization (LDConvenience)

+ (id)ld_JSONObjectWithData:(NSData *)data error:(NSError **)error
{
    if (!data) {
        if (error) {
            NSError *dataEmptyError =
            [NSError errorWithDomain:LDKitJSONSerializationErrorDomain
                                code:LDKitJSONParseDataEmptyCode
                            userInfo:@{NSLocalizedDescriptionKey : @"LDKit JSON Parse: Data shoudn't be nil."}];
            *error = dataEmptyError;
        }
        return nil;
    }
    
    return [self JSONObjectWithData:data options:NSJSONReadingAllowFragments error:error];
    
}

@end
