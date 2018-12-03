//
//  RHNotification.h
//  RH_Platform
//
//  Created by RongHang on 2018/11/20.
//  Copyright © 2018年 RongHang. All rights reserved.
//

#import <Foundation/Foundation.h>
//回调block传值
typedef void(^RHNotificationBlock)(NSNotification *notification);

@interface RHNotification : NSObject
//初始化api:block回调
- (instancetype)initWithName:(NSString *)name
                      sender:(id)sender
                       block:(RHNotificationBlock)block;
@end
