//
//  MBProgressHUD+CN.h.h
//  TopNews
//
//  Created by 陈肖坤 on 16/11/4.
//  Copyright © 2016年 levt. All rights reserved.
//

#import "MBProgressHUD.h"

@interface MBProgressHUD (CN)
/**
 *  信息提示
 *  @param information 提示文字
 *  @param view        HUD展示的view
 *  @param afterDelay  展示的时间
 */
+ (MBProgressHUD *)showTextString:(NSString *)TextString toView:(UIView *)view andAfterDelay:(float)afterDelay;
/**
 *  自定义view
 *  @param customview 自定义的view
 *  @param textString 提示文字
 *  @param view       HUD展示的view
 *  @param afterDelay 展示时间
 */
+ (void)showCustomview:(UIView *)customview andTextString:(NSString *)textString toView:(UIView *)view;// andAfterDelay:(float)afterDelay;

// 隐藏加载框
+ (void)hideHUDForView:(UIView *)view;

+ (void)hideHUD;

@end
