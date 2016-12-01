//
//  CNViewController.h
//  CrispyNews
//
//  Created by xuewu.long on 16/8/8.
//  Copyright © 2016年 letv. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@interface CNViewController : UIViewController

@property (nonatomic, assign) BOOL arrowBack;


- (void)showHint:(NSString *)hint hide:(CGFloat)delay debug:(BOOL)configure;
- (void)showHint:(NSString *)hint hide:(CGFloat)delay;
- (void)showHint:(NSString *)hint hide:(CGFloat)delay enableBackgroundUserAction:(BOOL)enable;

@end
