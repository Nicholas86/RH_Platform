//
//  RHAlertVCDelegate.h
//  RH_Platform
//
//  Created by RongHang on 2018/11/23.
//  Copyright © 2018年 RongHang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

// 交易模块枚举
typedef NS_ENUM(NSInteger, ResultStatus) {
    ResultStatus_Cancle = 0, //取消
    ResultStatus_OK = 1, // 成功
};

@protocol RHAlertVCDelegate <NSObject>
- (void)alertAction:(UIAlertAction *)alertAction didReceiveResultCode:(ResultStatus )resultCode;
@end
