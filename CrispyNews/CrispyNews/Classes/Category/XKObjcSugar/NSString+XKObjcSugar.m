//
//  NSString+XKObjcSugar.m
//  XKObjcSugar
//
//  Created by mac on 16/4/2.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "NSString+XKObjcSugar.h"

@implementation NSString (XKPath)

- (NSString *)xk_documentDirectory {
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject stringByAppendingPathComponent:self];
}

- (NSString *)xk_cacheDirecotry {
    return [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).firstObject stringByAppendingPathComponent:self];
}

- (NSString *)xk_tmpDirectory {
    return [NSTemporaryDirectory() stringByAppendingPathComponent:self];
}

@end

@implementation NSString (XKBase64)

- (NSString *)xk_base64encode {
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    
    return [data base64EncodedStringWithOptions:0];
}

- (NSString *)xk_base64decode {
    NSData *data = [[NSData alloc] initWithBase64EncodedString:self options:0];
    
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}

@end
