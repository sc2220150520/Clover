//
//  NSTimer+LDBreakRetainLoop.m
//  LDKitDemo
//
//  Created by lixingdong on 16/8/8.
//  Copyright © 2016年 david. All rights reserved.
//

#import "NSTimer+LDBreakRetainLoop.h"

@implementation NSTimer (LDBreakRetainLoop)

+ (NSTimer *)ld_scheduledTimerWithTimeInterval:(NSTimeInterval)interval repeats:(BOOL)repeats block:(TimerFireBlock)block
{
    return [NSTimer scheduledTimerWithTimeInterval:interval target:self
                                          selector:@selector(ld_fireBlockInvoke:)
                                          userInfo:[block copy] repeats:repeats];
}

+ (NSTimer *)ld_timerWithTimeInterval:(NSTimeInterval)interval repeats:(BOOL)repeats block:(TimerFireBlock)block
{
    return [NSTimer timerWithTimeInterval:interval target:self
                                 selector:@selector(ld_fireBlockInvoke:)
                                 userInfo:[block copy] repeats:repeats];
}

+ (void)ld_fireBlockInvoke:(NSTimer *)timer
{
    void (^block)() = timer.userInfo;
    if (block) {
        block();
    }
}

@end
