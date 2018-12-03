//
//  RHAlertVCTool.m
//  RH_Platform
//
//  Created by RongHang on 2018/11/23.
//  Copyright © 2018年 RongHang. All rights reserved.
//

#import "RHAlertVCTool.h"

@implementation RHAlertVCTool

- (void)showAlertController:(UIViewController *)controller
                      title:(NSString *)title
                    content:(NSString *)content
{
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:title message:content preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *_Nonnull action) {
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(alertAction:didReceiveResultCode:)]) {
            [self.delegate alertAction:action didReceiveResultCode:(ResultStatus_Cancle)];
        }
    }];
    
    UIAlertAction * runAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(alertAction:didReceiveResultCode:)]) {
            [self.delegate alertAction:action didReceiveResultCode:(ResultStatus_OK)];
        }
    }];
    [alert addAction:cancelAction];
    [alert addAction:runAction];
    [controller presentViewController:alert animated:YES completion:nil];
}

@end
