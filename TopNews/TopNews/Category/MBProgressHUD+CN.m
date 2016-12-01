//
//  MBProgressHUD+CN.m
//  TopNews
//
//  Created by 陈肖坤 on 16/11/4.
//  Copyright © 2016年 levt. All rights reserved.
//


#import "MBProgressHUD+CN.h"


@implementation MBProgressHUD (CN)
+ (MBProgressHUD *)showTextString:(NSString *)TextString toView:(UIView *)view andAfterDelay:(float)afterDelay{
    
    if (view == nil) view = [UIApplication sharedApplication].keyWindow;
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    
    hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    
    hud.mode = MBProgressHUDModeCustomView;
    
    hud.label.text = TextString;
    
//    hud.offset = CGPointMake(0.f, MBProgressMaxOffset);
    
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
    
    [hud hideAnimated:YES afterDelay:afterDelay];
    
    return hud;
    
}
/**
 NSMutableArray *imageArr = [NSMutableArray array];
 for (int i = 1; i < 12; i ++ ) {
 [imageArr addObject:[UIImage imageNamed:[NSString stringWithFormat:@"loading_7_%d",i]]];
 }
 UIImageView *showImageView = [[UIImageView alloc] init];
 showImageView.animationImages = imageArr;
 //    [showImageView setAnimationRepeatCount:0];
 [showImageView setAnimationDuration:(imageArr.count + 1) * 0.075];
 [showImageView startAnimating];
 
 [MBProgressHUD showCustomview:showImageView andTextString:@"正在登录..." toView:nil andAfterDelay:5.0];
 */
+ (void)showCustomview:(UIView *)customview andTextString:(NSString *)textString toView:(UIView *)view {//andAfterDelay:(float)afterDelay{
    
    if (view == nil) view = [UIApplication sharedApplication].keyWindow;
    
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    
    //MBProgressHUDModeCustomView (自定义 View)
    hud.mode = MBProgressHUDModeIndeterminate;
    
    hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    
    //    hud.bezelView.color = RGB(185, 185, 185);
    
    hud.customView = customview;
    
    hud.square = YES;
    
    hud.label.text = textString;
    
    hud.label.preferredMaxLayoutWidth = 140;
    
    hud.label.numberOfLines = 3;
    
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;

    
//    [hud hideAnimated:YES afterDelay:afterDelay];
    
}

+ (void)hideHUDForView:(UIView *)view
{
    if (view == nil) view = (UIView*)[UIApplication sharedApplication].delegate.window;
    [self hideHUDForView:view animated:YES];
}

+ (void)hideHUD
{
    [self hideHUDForView:nil];
}


@end
