//
//  UIImageView+CNImageView.h
//  CrispyNews
//
//  Created by xuewu.long on 16/8/20.
//  Copyright © 2016年 letv. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (CNImageView)

+ (instancetype)imgvWithFrame:(CGRect)frame imgName:(NSString *)imgName;

+ (instancetype)imgvWithFrame:(CGRect)frame color:(UIColor *)color;

@end
