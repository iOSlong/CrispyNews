//
//  UIImageView+CNImageView.m
//  CrispyNews
//
//  Created by xuewu.long on 16/8/20.
//  Copyright © 2016年 letv. All rights reserved.
//

#import "UIImageView+CNImageView.h"

@implementation UIImageView (CNImageView)

+ (instancetype)imgvWithFrame:(CGRect)frame imgName:(NSString *)imgName {
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:frame];
    imageView.image = [UIImage imageNamed:imgName];
    return imageView;
}

+ (instancetype)imgvWithFrame:(CGRect)frame color:(UIColor *)color {
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:frame];
    imageView.backgroundColor = color;
    return imageView;
}
@end
