//
//  UITextField+XKObjcSugar.h
//  XKObjcSugar
//
//  Created by mac on 16/4/2.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextField (XKObjcSugar)

/// 实例化 UITextField
///
/// @param placeHolder     占位文本
///
/// @return UITextField
+ (nonnull instancetype)xk_textFieldWithPlaceHolder:(nonnull NSString *)placeHolder;

@end
