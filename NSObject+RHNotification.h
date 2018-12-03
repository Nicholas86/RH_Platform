//
//  NSObject+RHNotification.h
//  RH_Platform
//
//  Created by RongHang on 2018/11/20.
//  Copyright © 2018年 RongHang. All rights reserved.
//

#import <Foundation/Foundation.h>

//回调block传值
typedef void(^RHNotificationBlock)(NSNotification *notification);

@interface NSObject (RHNotification)

//Note:self自己可能是观察者,也可能self持有了观察者,在self销毁的时候,取消多有观察
@property (nonatomic, strong) NSMutableDictionary *rhNotificationDic;

//注册通知
- (void)registerNotificationWithName:(const char *)name
                               block:(RHNotificationBlock )block;

//取消通知
- (void)unregisterNotificationWithName:(const char *)name;
- (void)unregisterAllNotification;

//发送通知消息
- (void)postNotificationWithName:(const char *)name
                        userInfo:(id)userInfo;


@end
