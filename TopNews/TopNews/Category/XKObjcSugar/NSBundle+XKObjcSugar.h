//
//  NSBundle+XKObjcSugar.h
//  XKObjcSugar
//
//  Created by mac on 16/4/2.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#define CTFBLocalizedString(key) [[NSBundle feedbackBundle] localizedStringForKey:key value:nil table:@"CNFeedbackViewController"]

@interface NSBundle (XKObjcSugar)

/// 当前版本号字符串
+ (nullable NSString *)xk_currentVersion;

/// 与当前屏幕尺寸匹配的启动图像
+ (nullable UIImage *)xk_launchImage;

+ (nullable NSBundle *)feedbackBundle;


@end
