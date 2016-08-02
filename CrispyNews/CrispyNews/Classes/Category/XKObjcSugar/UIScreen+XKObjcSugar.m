//
//  UIScreen+XKObjcSugar.m
//  XKObjcSugar
//
//  Created by mac on 16/4/2.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "UIScreen+XKObjcSugar.h"

@implementation UIScreen (XKObjcSugar)

+ (CGFloat)xk_screenWidth {
    return [UIScreen mainScreen].bounds.size.width;
}

+ (CGFloat)xk_screenHeight {
    return [UIScreen mainScreen].bounds.size.height;
}

+ (CGFloat)xk_scale {
    return [UIScreen mainScreen].scale;
}

@end
