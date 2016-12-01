//
//  UIScreen+XKObjcSugar.h
//  XKObjcSugar
//
//  Created by mac on 16/4/2.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIScreen (XKObjcSugar)

/// 屏幕宽度
+ (CGFloat)xk_screenWidth;
/// 屏幕高度
+ (CGFloat)xk_screenHeight;
/// 分辨率
+ (CGFloat)xk_scale;

@end
