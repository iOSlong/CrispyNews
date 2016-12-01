//
//  ViewController.m
//  CrispyNews
//
//  Created by 陈肖坤 on 16/7/14.
//  Copyright © 2016年 陈肖坤. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Extension)

/// 根据当前图像，和指定的尺寸，生成圆角图像并且返回
- (void)xk_cornerImageWithSize:(CGSize)size fillColor:(UIColor *)fillColor completion:(void (^)(UIImage *image))completion;


@end
