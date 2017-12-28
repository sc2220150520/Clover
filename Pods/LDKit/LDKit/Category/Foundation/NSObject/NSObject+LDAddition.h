//
//  NSObject+LDAddition.h
//  Pods
//
//  Created by 金秋实 on 29/06/2017.
//
//

#import <Foundation/Foundation.h>

@interface NSObject (LDAddition)

- (NSDate *) ld_cachedDate; //加入缓存的时间

- (void)ld_setCachedDate:(NSDate *)date;
    
@end
