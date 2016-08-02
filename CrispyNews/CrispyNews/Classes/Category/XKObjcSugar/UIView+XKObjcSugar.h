//
//  UIView+XKObjcSugar.h
//  XKObjcSugar
//
//  Created by mac on 16/4/2.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (XKObjcSugar)

#pragma mark - Frame
/// 视图原点
@property (nonatomic) CGPoint xk_viewOrigin;
/// 视图尺寸
@property (nonatomic) CGSize xk_viewSize;

#pragma mark - Frame Origin
/// frame 原点 x 值
@property (nonatomic) CGFloat xk_x;
/// frame 原点 y 值
@property (nonatomic) CGFloat xk_y;

#pragma mark - Frame Size
/// frame 尺寸 width
@property (nonatomic) CGFloat xk_width;
/// frame 尺寸 height
@property (nonatomic) CGFloat xk_height;

#pragma mark - 截屏
/// 当前视图内容生成的图像
@property (nonatomic, readonly, nullable)UIImage *xk_capturedImage;

@end
