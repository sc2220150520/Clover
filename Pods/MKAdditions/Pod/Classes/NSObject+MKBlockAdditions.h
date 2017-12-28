//
//  NSObject+MKBlockAdditions.h
//  UIKitCategoryAdditions
//
//  Created by Mugunth on 25/03/11.
//  Copyright 2011 Steinlogic. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MKBlockAdditions.h"

NS_ASSUME_NONNULL_BEGIN
@interface NSObject (MKBlockAdditions)

- (void)performBlock:(VoidBlock)block;
- (void)performBlock:(VoidBlock)block afterDelay:(NSTimeInterval)delay;

@end
NS_ASSUME_NONNULL_END
