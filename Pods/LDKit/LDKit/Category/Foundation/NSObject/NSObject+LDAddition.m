//
//  NSObject+LDAddition.m
//  Pods
//
//  Created by 金秋实 on 29/06/2017.
//
//

#import "NSObject+LDAddition.h"
#import <objc/runtime.h>

@implementation NSObject (LDAddition)

- (void)ld_setCachedDate:(NSDate *)date;
{
    objc_setAssociatedObject(self, @selector(ld_cachedDate), date, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSDate *)ld_cachedDate
{
    id object = objc_getAssociatedObject(self, @selector(ld_cachedDate));
    return object;
}
    
@end
