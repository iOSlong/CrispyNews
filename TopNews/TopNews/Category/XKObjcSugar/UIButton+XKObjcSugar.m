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

+ (instancetype)xk_buttonWithFrame:(CGRect)frame image:(NSString *)image target:(nonnull id)target action:(nonnull SEL)action{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
//    btn.backgroundColor = [UIColor yellowColor];
    UIImage *img    = [UIImage imageNamed:image];
    CGFloat imgw    = CGImageGetWidth(img.CGImage);
    CGFloat imgh    = CGImageGetHeight(img.CGImage);
    CGFloat fit_w   = 7 * kRATIO;
    CGFloat fit_h   = fit_w * imgh/imgw;
    [btn setImage:img forState:UIControlStateNormal];
    [btn setFrame:frame];
    [btn setContentEdgeInsets:UIEdgeInsetsMake(fit_h, fit_w, fit_h, fit_w)];
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return btn;
}
+ (nonnull instancetype)xk_buttonWithFrame:(CGRect)frame imageNormal:(NSString *)imgNormal selectedImage:(NSString *)imgSelected target:(id)target action:(SEL)action
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *img    = [UIImage imageNamed:imgNormal];
    UIImage *imgS   = [UIImage imageNamed:imgSelected];
    CGFloat imgw    = CGImageGetWidth(img.CGImage);
    CGFloat imgh    = CGImageGetHeight(img.CGImage);
    CGFloat fit_w   = 7 * kRATIO;
    CGFloat fit_h   = fit_w * imgh/imgw;
    [btn setImage:img forState:UIControlStateNormal];
    [btn setImage:imgS forState:UIControlStateSelected];
    [btn setFrame:frame];
    [btn setContentEdgeInsets:UIEdgeInsetsMake(fit_h, fit_w, fit_h, fit_w)];
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    
    CALayer *circleLayer = [[CALayer alloc] init];
    circleLayer.frame = CGRectMake(2 * fit_w, 2 * fit_h, frame.size.width - 4 * fit_w, frame.size.height - 4 * fit_h);
    circleLayer.borderColor = RGBCOLOR_HEX(0xFF5800).CGColor;
    circleLayer.borderWidth = 1;
    circleLayer.cornerRadius = (frame.size.width - 4 * fit_w) * 0.5;
    [btn.layer addSublayer:circleLayer];
    
    return btn;
}


+ (nonnull instancetype)buttonFrame:(CGRect)frame imgSelected:(NSString *)imgSelected imgNormal:(NSString *)imgNormal target:(id)target action:(SEL)action mode:(UIViewContentMode)mode ContentEdgeInsets:(UIEdgeInsets)insets;
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setImage:[UIImage imageNamed:imgSelected] forState:UIControlStateSelected];
    [btn setImage:[UIImage imageNamed:imgNormal] forState:UIControlStateNormal];
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    [btn setFrame:frame];
    [btn setContentEdgeInsets:insets];
    [btn.imageView setContentMode:mode];

    return btn;
}
//+ (nonnull instancetype)buttonFrame:(CGRect)frame img:(NSString *)imgName target:(id)target action:(SEL)action mode

@end
