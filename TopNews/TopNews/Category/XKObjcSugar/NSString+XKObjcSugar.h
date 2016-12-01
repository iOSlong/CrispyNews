//
//  NSString+XKObjcSugar.h
//  XKObjcSugar
//
//  Created by mac on 16/4/2.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (XKPath)

/// 拼接了`文档目录`的全路径
@property (nullable, nonatomic, readonly) NSString *xk_documentDirectory;
/// 拼接了`缓存目录`的全路径
@property (nullable, nonatomic, readonly) NSString *xk_cacheDirecotry;
/// 拼接了临时目录的全路径
@property (nullable, nonatomic, readonly) NSString *xk_tmpDirectory;

@end

@interface NSString (XKBase64)

/// BASE 64 编码的字符串内容
@property(nullable, nonatomic, readonly) NSString *xk_base64encode;
/// BASE 64 解码的字符串内容
@property(nullable, nonatomic, readonly) NSString *xk_base64decode;

@end