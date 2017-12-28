//
//  NSUserDefaults+LDAccessors.m
//  LDKit
//
//  Created by liuchuanshuang on 30/10/2017.
//

#import "NSUserDefaults+LDAccessors.h"

@implementation NSUserDefaults (LDAccessors)

- (void)ld_setObject:(id)obj forKey:(NSString*)key
{
    if ([key isKindOfClass:[NSString class]] && key.length != 0 && obj != nil) {
        [self setObject:obj forKey:key];
    } else {
#ifdef DEBUG
        NSAssert(0, @"NSUserDefaults ld_setObject obj or key is nil");
#endif
    }
}
@end
