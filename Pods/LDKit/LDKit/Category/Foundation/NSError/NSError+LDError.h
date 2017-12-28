//
//  NSError+LDError.h
//  Pods
//
//  Created by wuxu on 10/21/2015.
//  Copyright (c) 2015 wuxu. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSError (LDError)

+ (instancetype)ld_errorWithCode:(NSInteger)code description:(NSString *)localizedDesc;

@end

@interface NSError (LDNetError)

+ (instancetype)ld_serviceBusy;
+ (instancetype)ld_parseDataError;
+ (instancetype)ld_networkError;
+ (instancetype)ld_paramsError;

@end

NS_ASSUME_NONNULL_END
