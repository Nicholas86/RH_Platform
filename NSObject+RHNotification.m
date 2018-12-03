//
//  NSObject+RHNotification.m
//  RH_Platform
//
//  Created by RongHang on 2018/11/20.
//  Copyright © 2018年 RongHang. All rights reserved.
//

#import "NSObject+RHNotification.h"
#import <objc/runtime.h>
#import <objc/message.h>
#import "RHNotification.h"

// 定义静态常量字符串
#define uxy_staticConstString(__string)  static const char *__string = #__string;

uxy_staticConstString(NSObject_notifications)

@implementation NSObject (RHNotification)

#pragma mark 用runtime动态添加属性
//存放观察者对象的字典
//存放观察者对象的字典
- (id)rhNotificationDic
{
    return objc_getAssociatedObject(self, NSObject_notifications) ?: ({
        NSMutableDictionary *dic = [NSMutableDictionary  dictionaryWithCapacity:10];
        objc_setAssociatedObject(self, NSObject_notifications, dic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        dic;
    });
}


#pragma mark 注册通知

//block:方式
- (void)registerNotificationWithName:(const char *)name
                               block:(RHNotificationBlock )block
{
    [self  notificationWihtName:name block:block];
}


#pragma mark 取消通知
//某一个通知
- (void)unregisterNotificationWithName:(const char *)name
{
    NSString *key = [NSString  stringWithFormat:@"%s", name];
    [self.rhNotificationDic  removeObjectForKey:key];
}

//所有通知
- (void)unregisterAllNotification
{
    [self.rhNotificationDic  removeAllObjects];
}

#pragma mark 初始化通知对象

//block方式:
- (void)notificationWihtName:(const char *)name block:(RHNotificationBlock )block
{
    NSString *str = [NSString stringWithUTF8String:name];
    RHNotification *notification = [[RHNotification alloc] initWithName:str sender:nil block:block];
    
    NSString *key = [NSString stringWithFormat:@"%@", str];
    [self.rhNotificationDic setObject:notification forKey:key];
}


#pragma mark 发送通知消息
- (void)postNotificationWithName:(const char *)name
                        userInfo:(id)userInfo
{
    NSString *str = [NSString  stringWithUTF8String:name];
    [[NSNotificationCenter  defaultCenter] postNotificationName:str object:self userInfo:userInfo];
}

@end
