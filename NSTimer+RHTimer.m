//
//  NSTimer+RHTimer.m
//  EasyTrade
//
//  Created by RongHang on 2018/11/7.
//  Copyright © 2018年 Rohon. All rights reserved.
//

#import "NSTimer+RHTimer.h"

@implementation NSTimer (RHTimer)

+ (void)_rh_ExecBlock:(NSTimer *)timer {
    if ([timer userInfo]) {
        void (^block)(NSTimer *timer) = (void (^)(NSTimer *timer))[timer userInfo];
        block(timer);
    }
}

+ (NSTimer *)scheduledTimerWithTimeInterval:(NSTimeInterval)seconds block:(void (^)(NSTimer *timer))block repeats:(BOOL)repeats {
    return [NSTimer scheduledTimerWithTimeInterval:seconds target:self selector:@selector(_rh_ExecBlock:) userInfo:[block copy] repeats:repeats];
}

+ (NSTimer *)timerWithTimeInterval:(NSTimeInterval)seconds block:(void (^)(NSTimer *timer))block repeats:(BOOL)repeats {
    return [NSTimer timerWithTimeInterval:seconds target:self selector:@selector(_rh_ExecBlock:) userInfo:[block copy] repeats:repeats];
}
@end
