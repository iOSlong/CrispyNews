//
//  UIButton+XKObjcSugar.m
//  XKObjcSugar
//
//  Created by mac on 16/4/2.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "UIButton+XKObjcSugar.h"

@implementation UIButton (XKObjcSugar)

+ (instancetype)xk_buttonWithTitle:(NSString *)title fontSize:(CGFloat)fontSize textColor:(UIColor *)textColor {
    NSAttributedString *attributedText = [[NSAttributedString alloc]
                                          initWithString:title
                                          attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:fontSize],
                                                       NSForegroundColorAttributeName: textColor}];
    
    return [self xk_buttonWithAttributedText:attributedText];
}

+ (instancetype)xk_buttonWithAttributedText:(NSAttributedString *)attributedText {
    return [self xk_buttonWithAttributedText:attributedText imageName:nil backImageName:nil highlightSuffix:nil];
}

+ (instancetype)xk_buttonWithImageName:(NSString *)imageName highlightSuffix:(NSString *)highlightSuffix {
    
    return [self xk_buttonWithAttributedText:nil imageName:imageName backImageName:nil highlightSuffix:highlightSuffix];
}

+ (instancetype)xk_buttonWithImageName:(NSString *)imageName backImageName:(NSString *)backImageName highlightSuffix:(NSString *)highlightSuffix {
    
    return [self xk_buttonWithAttributedText:nil imageName:imageName backImageName:backImageName highlightSuffix:highlightSuffix];
}

+ (instancetype)xk_buttonWithTitle:(NSString *)title fontSize:(CGFloat)fontSize textColor:(UIColor *)textColor imageName:(NSString *)imageName backImageName:(NSString *)backImageName highlightSuffix:(NSString *)highlightSuffix {
    
    NSAttributedString *attributedText = [[NSAttributedString alloc]
                                          initWithString:title
                                          attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:fontSize],
                                                       NSForegroundColorAttributeName: textColor}];
    
    return [self xk_buttonWithAttributedText:attributedText imageName:imageName backImageName:backImageName highlightSuffix:highlightSuffix];
}

+ (instancetype)xk_buttonWithAttributedText:(NSAttributedString *)attributedText imageName:(NSString *)imageName backImageName:(NSString *)backImageName highlightSuffix:(NSString *)highlightSuffix {
    
    UIButton *button = [[self alloc] init];
    
    [button setAttributedTitle:attributedText forState:UIControlStateNormal];
    
    if (imageName != nil) {
        [button setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
        
        NSString *highlightedImageName = [imageName stringByAppendingString:highlightSuffix];
        [button setImage:[UIImage imageNamed:highlightedImageName] forState:UIControlStateHighlighted];
    }
    
    if (backImageName != nil) {
        [button setBackgroundImage:[UIImage imageNamed:backImageName] forState:UIControlStateNormal];
        
        NSString *highlightedImageName = [backImageName stringByAppendingString:highlightSuffix];
        [button setBackgroundImage:[UIImage imageNamed:highlightedImageName] forState:UIControlStateHighlighted];
    }
    
    [button sizeToFit];
    
    return button;
}

@end
