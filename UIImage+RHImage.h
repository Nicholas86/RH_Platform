//
//  UIImage+RHImage.h
//  RH_Platform
//
//  Created by RongHang on 2018/11/7.
//  Copyright © 2018年 RongHang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (RHImage)
/*
 强制解码图片
 path: 图片路径, 通过NSBundle获取
*/
+ (void)forceDecodeImageWithContentOfFile:(NSString *)path block:(void (^)(UIImage *image))block;

@end
