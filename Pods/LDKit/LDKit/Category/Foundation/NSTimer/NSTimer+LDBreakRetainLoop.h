//
//  NSTimer+LDBreakRetainLoop.h
//  LDKitDemo
//
//  Created by lixingdong on 16/8/8.
//  written by Anchor on 16/5/17.
//  Copyright © 2016年 david. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^TimerFireBlock)();

@interface NSTimer (LDBreakRetainLoop)

+ (NSTimer *)ld_scheduledTimerWithTimeInterval:(NSTimeInterval)interval repeats:(BOOL)repeats block:(TimerFireBlock)block;

+ (NSTimer *)ld_timerWithTimeInterval:(NSTimeInterval)interval repeats:(BOOL)repeats block:(TimerFireBlock)block;

@end
