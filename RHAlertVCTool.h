//
//  RHAlertVCTool.h
//  RH_Platform
//
//  Created by RongHang on 2018/11/23.
//  Copyright © 2018年 RongHang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RHAlertVCDelegate.h"

@interface RHAlertVCTool : NSObject

@property (nonatomic, assign) id<RHAlertVCDelegate> delegate;

- (void)showAlertController:(UIViewController *)controller
                      title:(NSString *)title
                    content:(NSString *)content;

@end
