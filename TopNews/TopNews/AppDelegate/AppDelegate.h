//
//  AppDelegate.h
//  CrispyNews
//
//  Created by 陈肖坤 on 16/7/14.
//  Copyright © 2016年 陈肖坤. All rights reserved.
//

#import <UIKit/UIKit.h>



#import "CNHomeNewsViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic, readonly) MMDrawerController *crispyMenu;
@property (nonatomic, strong) CNHomeNewsViewController *homeNewsVC;

@end


