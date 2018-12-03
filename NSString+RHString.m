//
//  NSString+RHString.m
//  RH_Platform
//
//  Created by RongHang on 2018/11/16.
//  Copyright © 2018年 RongHang. All rights reserved.
//
#import <CommonCrypto/CommonDigest.h>

#import "NSString+RHString.h"

@implementation NSString (RHString)
+ (NSString *)md5HashWithString:(NSString *)str
{
    const char *cStr = [str UTF8String];
    unsigned char result[16];
    CC_MD5( cStr, (CC_LONG)strlen(cStr), result );
    NSString *md5Result = [NSString stringWithFormat:
                           @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
                           result[0], result[1], result[2], result[3],
                           result[4], result[5], result[6], result[7],
                           result[8], result[9], result[10], result[11],
                           result[12], result[13], result[14], result[15]
                           ];
    return md5Result;
}
@end
