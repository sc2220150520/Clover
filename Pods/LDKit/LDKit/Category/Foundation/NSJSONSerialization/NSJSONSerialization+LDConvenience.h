//
//  NSJSONSerialization+LDConvenience.h
//  LDKit
//
//  Created by lixingdong on 16/8/12.
//  Copyright © 2016年 netease. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

extern NSString *const LDKitJSONParseErrorDomain;
extern const NSInteger LDKitJSONParseDataEmptyCode; //此处暂用const表示 以后若Code增加可改用enum

@interface NSJSONSerialization (LDConvenience)

+ (nullable id)ld_JSONObjectWithData:(NSData *)data error:(NSError **)error;

@end

NS_ASSUME_NONNULL_END
