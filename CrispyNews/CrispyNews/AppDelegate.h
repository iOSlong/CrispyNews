//
//  AppDelegate.h
//  CrispyNews
//
//  Created by 陈肖坤 on 16/7/14.
//  Copyright © 2016年 陈肖坤. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MMDrawerController/MMDrawerController.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic, readonly) MMDrawerController *crispyMenu;

@end

