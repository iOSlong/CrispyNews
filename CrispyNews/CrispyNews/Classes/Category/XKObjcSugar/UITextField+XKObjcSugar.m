//
//  UITextField+XKObjcSugar.m
//  XKObjcSugar
//
//  Created by mac on 16/4/2.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "UITextField+XKObjcSugar.h"

@implementation UITextField (XKObjcSugar)

+ (instancetype)xk_textFieldWithPlaceHolder:(NSString *)placeHolder {

    UITextField *textField = [[self alloc] init];
    
    textField.borderStyle = UITextBorderStyleRoundedRect;
    textField.placeholder = placeHolder;
    
    return textField;
}

@end
