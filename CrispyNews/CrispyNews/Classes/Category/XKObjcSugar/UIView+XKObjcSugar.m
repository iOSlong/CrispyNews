//
//  UIView+XKObjcSugar.m
//  XKObjcSugar
//
//  Created by mac on 16/4/2.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "UIView+XKObjcSugar.h"

@implementation UIView (XKObjcSugar)

#pragma mark - Frame
- (CGPoint)xk_viewOrigin {
    return self.frame.origin;
}

- (void)setXk_viewOrigin:(CGPoint)xk_viewOrigin {
    CGRect newFrame = self.frame;
    newFrame.origin = xk_viewOrigin;
    self.frame = newFrame;
}

- (CGSize)xk_viewSize {
    return self.frame.size;
}

- (void)setXk_viewSize:(CGSize)xk_viewSize {
    CGRect newFrame = self.frame;
    newFrame.size = xk_viewSize;
    self.frame = newFrame;
}

#pragma mark - Frame Origin
- (CGFloat)xk_x {
    return self.frame.origin.x;
}

- (void)setXk_x:(CGFloat)xk_x {
    CGRect newFrame = self.frame;
    newFrame.origin.x = xk_x;
    self.frame = newFrame;
}

- (CGFloat)xk_y {
    return self.frame.origin.y;
}

- (void)setXk_y:(CGFloat)xk_y {
    CGRect newFrame = self.frame;
    newFrame.origin.y = xk_y;
    self.frame = newFrame;
}

#pragma mark - Frame Size
- (CGFloat)xk_width {
    return self.frame.size.width;
}

- (void)setXk_width:(CGFloat)xk_width {
    CGRect newFrame = self.frame;
    newFrame.size.width = xk_width;
    self.frame = newFrame;
}

- (CGFloat)xk_height {
    return self.frame.size.height;
}

- (void)setXk_height:(CGFloat)xk_height {
    CGRect newFrame = self.frame;
    newFrame.size.height = xk_height;
    self.frame = newFrame;
}

#pragma mark - 截屏
- (UIImage *)xk_capturedImage {
    
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, YES, 0);
    
    UIImage *result = nil;
    if ([self drawViewHierarchyInRect:self.bounds afterScreenUpdates:YES]) {
        result = UIGraphicsGetImageFromCurrentImageContext();
    }
    
    UIGraphicsEndImageContext();
    
    return result;
}

@end
