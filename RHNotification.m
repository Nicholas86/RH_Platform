//
//  RHNotification.m
//  RH_Platform
//
//  Created by RongHang on 2018/11/20.
//  Copyright © 2018年 RongHang. All rights reserved.
//

#import "RHNotification.h"

@interface RHNotification()
@property (nonatomic, copy) NSString *name; //注册的通知 名称
@property (nonatomic, weak) id sender;
@property (nonatomic, copy) RHNotificationBlock block;//消息回调,外部实现
@end

@implementation RHNotification
//初始化api:block回调
- (instancetype)initWithName:(NSString *)name
                      sender:(id)sender
                       block:(RHNotificationBlock)block
{
    self = [super init];
    if (self)
    {
        _name   = name;
        _sender = sender;
        _block  = block;
        [[NSNotificationCenter defaultCenter]  addObserver:self
                                                  selector:@selector(handleNotification:)                                                            name:name                                                            object:sender];
    }
    
    return self;
}



#pragma mark 处理通知
- (void)handleNotification:(NSNotification *)notification
{
    //1.block传值
    if (_block){
        _block(notification);
        return;
    }
}

- (void)dealloc
{
    [[NSNotificationCenter  defaultCenter] removeObserver:self name:_name object:nil];
}


@end
