//
//  NSTimer+RHTimer.h
//  EasyTrade
//
//  Created by RongHang on 2018/11/7.
//  Copyright © 2018年 Rohon. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSTimer (RHTimer)

+ (NSTimer *)scheduledTimerWithTimeInterval:(NSTimeInterval)seconds block:(void (^)(NSTimer *timer))block repeats:(BOOL)repeats;


+ (NSTimer *)timerWithTimeInterval:(NSTimeInterval)seconds block:(void (^)(NSTimer *timer))block repeats:(BOOL)repeats;

@end
