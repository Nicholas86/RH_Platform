//
//  UIImage+RHImage.m
//  RH_Platform
//
//  Created by RongHang on 2018/11/7.
//  Copyright © 2018年 RongHang. All rights reserved.
//

#import "UIImage+RHImage.h"
#import <QuartzCore/QuartzCore.h>
#import <ImageIO/ImageIO.h>

@implementation UIImage (RHImage)

+ (void)forceDecodeImageWithContentOfFile:(NSString *)path block:(void (^)(UIImage *image))block
{
    if (path == nil) {
        NSLog(@"image path is null");
        return;
    }
    
    UIImage *n_decoded_image = [self imageWithFilePath:path];
    [self decodeImage:n_decoded_image block:^(UIImage *image) {
        block(image);
    }];
}

//ImageIO来创建图片，然后在图片的生命周期保留解压后的版本
+ (UIImage *)imageWithFilePath:(NSString *)filePath
{
    //kCGImageSourceShouldCacheImmediately表示是否在加载完后立刻开始解码，默认为NO表示在渲染时才解码
    //kCGImageSourceShouldCache可以设置在图片的生命周期内是保存图片解码后的数据还是原始图片，64位设备默认为YES，32位设备默认为NO
    CFDictionaryRef options = (__bridge CFDictionaryRef)@{(__bridge id)kCGImageSourceShouldCacheImmediately:@(NO), (__bridge id)kCGImageSourceShouldCache:@(NO)};
    NSURL *imageURL = [NSURL fileURLWithPath:filePath];
    CGImageSourceRef source = CGImageSourceCreateWithURL((__bridge CFURLRef)imageURL, NULL);
    CGImageRef imageRef = CGImageSourceCreateImageAtIndex(source, 0, options);//创建一个未解码的CGImage
    CGFloat scale = 1;
    if ([filePath rangeOfString:@"@2x"].location != NSNotFound) {
        scale = 2.0;
    }
    UIImage *image = [UIImage imageWithCGImage:imageRef scale:scale orientation:UIImageOrientationUp];//此时图片还没有解码
    CGImageRelease(imageRef);
    CFRelease(source);
    return image;
}

// 解码图片
+ (void)decodeImage:(UIImage *)image block:(void (^)(UIImage *image))block
{
    //异步子线程图片解码
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        CGImageRef decodedImage = decodeImageWithCGImage(image.CGImage, YES);//强制解码
        
        // 回到主线程刷新UI
        // 使用imageWithCGImage函数加载解码后的位图
        dispatch_async(dispatch_get_main_queue(), ^{
            UIImage *decode_image = [UIImage imageWithCGImage:decodedImage scale:image.scale orientation:UIImageOrientationUp];
            block(decode_image);
            CFRelease(decodedImage);
        });
    });
}

//返回解码后位图数据 Core Graphics offscreen rendering based on CPU
CGImageRef decodeImageWithCGImage(CGImageRef imageRef, BOOL decodeForDisplay)
{
    if (!imageRef) return NULL;
    size_t width = CGImageGetWidth(imageRef);
    size_t height = CGImageGetHeight(imageRef);
    if (width == 0 || height == 0) return NULL;
    
    if (decodeForDisplay) { //decode with redraw (may lose some precision)
        CGImageAlphaInfo alphaInfo = CGImageGetAlphaInfo(imageRef) & kCGBitmapAlphaInfoMask;
        BOOL hasAlpha = NO;
        if (alphaInfo == kCGImageAlphaPremultipliedLast ||
            alphaInfo == kCGImageAlphaPremultipliedFirst ||
            alphaInfo == kCGImageAlphaLast ||
            alphaInfo == kCGImageAlphaFirst) {
            hasAlpha = YES;
        }
        // BGRA8888 (premultiplied) or BGRX8888
        // same as UIGraphicsBeginImageContext() and -[UIView drawRect:]
        //先把图片绘制到 CGBitmapContext 中，然后从 Bitmap 直接创建图片
        CGBitmapInfo bitmapInfo = kCGBitmapByteOrder32Host;
        bitmapInfo |= hasAlpha ? kCGImageAlphaPremultipliedFirst : kCGImageAlphaNoneSkipFirst;
        
        /*
         解码步骤:
         1. 使用CGBitmapContextCreate函数创建一个位图上下文
         2. 使用CGContextDrawImage函数将原始位图绘制到上下文中
         3. 使用CGBitmapContextCreateImage函数创建一张新的解压缩后的位图
         */
        CGContextRef context = CGBitmapContextCreate(NULL, width, height, 8, 0, CGColorSpaceCreateDeviceRGB(), bitmapInfo);
        if (!context) return NULL;
        CGContextDrawImage(context, CGRectMake(0, 0, width, height), imageRef); // decode
        CGImageRef newImage = CGBitmapContextCreateImage(context);
        CFRelease(context);
        return newImage;
    } else {
        CGColorSpaceRef space = CGImageGetColorSpace(imageRef);
        size_t bitsPerComponent = CGImageGetBitsPerComponent(imageRef);
        size_t bitsPerPixel = CGImageGetBitsPerPixel(imageRef);
        size_t bytesPerRow = CGImageGetBytesPerRow(imageRef);
        CGBitmapInfo bitmapInfo = CGImageGetBitmapInfo(imageRef);
        if (bytesPerRow == 0 || width == 0 || height == 0) return NULL;
        
        CGDataProviderRef dataProvider = CGImageGetDataProvider(imageRef);
        if (!dataProvider) return NULL;
        CFDataRef data = CGDataProviderCopyData(dataProvider); // decode
        if (!data) return NULL;
        
        CGDataProviderRef newProvider = CGDataProviderCreateWithCFData(data);
        CFRelease(data);
        if (!newProvider) return NULL;
        
        CGImageRef newImage = CGImageCreate(width, height, bitsPerComponent, bitsPerPixel, bytesPerRow, space, bitmapInfo, newProvider, NULL, false, kCGRenderingIntentDefault);
        CFRelease(newProvider);
        return newImage;
    }
}

NSUInteger cacheCostForImage(UIImage *image) {
    return image.size.height * image.size.width * image.scale * image.scale;
}

@end
