//
//  AppDelegate.m
//  CrispyNews
//
//  Created by 陈肖坤 on 16/7/14.
//  Copyright © 2016年 陈肖坤. All rights reserved.
//

#import "AppDelegate.h"
#import "CNHomeNewsViewController.h"
#import "CNMenuDrawerTableViewController.h"


@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    
    [self defaultRootController];
    
    
    [self.window makeKeyAndVisible];
    
    
    //    -------------------
    //    龙
    //    的技术解决的实际的s
    //    ==================
    
    
    return YES;
}


- (void)defaultRootController {
    
    CNHomeNewsViewController *homeNewsVC = [[CNHomeNewsViewController alloc]init];
    
    CNMenuDrawerTableViewController *menuDrawerVC = [[CNMenuDrawerTableViewController alloc]init];
    CNNavigationController *homeNesNav = [[CNNavigationController alloc] initWithRootViewController:homeNewsVC];
    
    _crispyMenu = [[MMDrawerController alloc]initWithCenterViewController:homeNesNav leftDrawerViewController:menuDrawerVC];
    
    [_crispyMenu setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
    [_crispyMenu setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeAll];
    [_crispyMenu setShouldStretchDrawer:NO];
    [_crispyMenu setShowsShadow:YES];
    [_crispyMenu setMaximumLeftDrawerWidth:k_Drawer_W];
    
    self.window.rootViewController = self.crispyMenu;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
