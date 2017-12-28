//
//  NSObject+MKBlockAdditions.m
//  UIKitCategoryAdditions
//
//  Created by Mugunth on 25/03/11.
//  Copyright 2011 Steinlogic. All rights reserved.
//

#import "NSObject+MKBlockAdditions.h"
#import <objc/runtime.h>

static char BLOCK_IDENTIFER;

@interface NSObject ()

@property (nonatomic, copy, nullable) VoidBlock block;

@end

@implementation NSObject (MKBlockAdditions)

#pragma mark - Custom Accessors

- (void)setBlock:(VoidBlock)block {
    objc_setAssociatedObject(self, &BLOCK_IDENTIFER, block, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (VoidBlock)block {
    return objc_getAssociatedObject(self, &BLOCK_IDENTIFER);
}

- (void)performBlock:(VoidBlock)aBlock {
    
    self.block = aBlock;
    
    [self performSelector:@selector(callBlock)];
}

- (void)performBlock:(VoidBlock)aBlock afterDelay:(NSTimeInterval)delay {
    
    self.block = aBlock;

    [self performSelector:@selector(callBlock) withObject:nil afterDelay:delay];
}

- (void)callBlock {
    if (self.block) {
        self.block();
        self.block = nil;
    }
}

@end
