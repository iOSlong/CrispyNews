//
//  UILabel+XKObjcSugar.m
//  XKObjcSugar
//
//  Created by mac on 16/4/2.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "UILabel+XKObjcSugar.h"

@implementation UILabel (XKObjcSugar)

+ (instancetype)xk_labelWithText:(NSString *)text {
    return [self xk_labelWithText:text fontSize:14 textColor:[UIColor darkGrayColor] alignment:NSTextAlignmentLeft];
}

+ (instancetype)xk_labelWithText:(NSString *)text fontSize:(CGFloat)fontSize {
    return [self xk_labelWithText:text fontSize:fontSize textColor:[UIColor darkGrayColor] alignment:NSTextAlignmentLeft];
}

+ (instancetype)xk_labelWithText:(NSString *)text fontSize:(CGFloat)fontSize textColor:(UIColor *)textColor {
    return [self xk_labelWithText:text fontSize:fontSize textColor:textColor alignment:NSTextAlignmentLeft];
}

+ (instancetype)xk_labelWithText:(NSString *)text fontSize:(CGFloat)fontSize textColor:(UIColor *)textColor alignment:(NSTextAlignment)alignment {
    
    UILabel *label = [[self alloc] init];
    
    label.text = text;
    label.font = [UIFont systemFontOfSize:fontSize];
    label.textColor = textColor;
    label.numberOfLines = 0;
    label.textAlignment = alignment;
    
    [label sizeToFit];
    
    return label;
}

@end
