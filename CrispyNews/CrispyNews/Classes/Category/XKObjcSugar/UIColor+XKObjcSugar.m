//
//  UIColor+XKObjcSugar.m
//  XKObjcSugar
//
//  Created by mac on 16/4/2.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "UIColor+XKObjcSugar.h"

@implementation UIColor (XKObjcSugar)

#pragma mark - 颜色函数
+ (instancetype)xk_colorWithHex:(u_int32_t)hex {
    u_int8_t red = (hex & 0xFF0000) >> 16;
    u_int8_t green = (hex & 0x00FF00) >> 8;
    u_int8_t blue = hex & 0x0000FF;
    
    return [UIColor xk_colorWithRed:red green:green blue:blue];
}

+ (instancetype)xk_colorWithRed:(u_int8_t)red green:(u_int8_t)green blue:(u_int8_t)blue {
    return [UIColor colorWithRed:red / 255.0 green:green / 255.0 blue:blue / 255.0 alpha:1.0];
}

+ (instancetype)xk_randomColor {
    u_int8_t red = arc4random_uniform(256);
    u_int8_t green = arc4random_uniform(256);
    u_int8_t blue = arc4random_uniform(256);
    
    return [UIColor xk_colorWithRed:red green:green blue:blue];
}

#pragma mark - 颜色值
- (u_int8_t)xk_redValue {
    return (u_int8_t)(CGColorGetComponents(self.CGColor)[0] * 255);
}

- (u_int8_t)xk_greenValue {
    return (u_int8_t)(CGColorGetComponents(self.CGColor)[1] * 255);
}

- (u_int8_t)xk_blueValue {
    return (u_int8_t)(CGColorGetComponents(self.CGColor)[2] * 255);
}

- (CGFloat)xk_alphaValue {
    return CGColorGetComponents(self.CGColor)[3];
}

@end
