//
//  GDTMobAppDelegate.m
//  GDTMobSample
//
//  Created by GaoChao on 13-12-9.
//  Copyright (c) 2013年 Tencent. All rights reserved.
//

#import "GDTMobAppDelegate.h"
#import "GDTTrack.h"
@implementation GDTMobAppDelegate

@synthesize window = _window;
@synthesize viewController = _viewController;
@synthesize splash = _splash;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.viewController = [[ViewController alloc] initWithNibName:@"ViewController" bundle:nil];
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:self.viewController];
    nav.navigationBar.barStyle = UIBarStyleBlackOpaque;
    nav.navigationBar.topItem.title = @"广告样式";
    self.window.backgroundColor = [UIColor whiteColor];
    self.window.rootViewController = nav;
    [self.window makeKeyAndVisible];
    
    //开屏广告初始化并展示代码
//    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
//        GDTSplashAd *splashAd = [[GDTSplashAd alloc] initWithAppkey:@"1105344611" placementId:@"9040714184494018"];
//        splashAd.delegate = self;//设置代理1ez        //针对不同设备尺寸设置不同的默认图片，拉取广告等待时间会展示该默认图片。
//        if ([[UIScreen mainScreen] bounds].size.height >= 568.0f) {
//            splashAd.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"LaunchImage-568h"]];
//        } else {
//            splashAd.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"LaunchImage"]];
//        }
//        //设置开屏拉取时长限制，若超时则不再展示广告 
//        splashAd.fetchDelay = 3;
//        //［可选］拉取并展示全屏开屏广告
//        //[splashAd loadAdAndShowInWindow:self.window];
//        //设置开屏底部自定义LogoView，展示半屏开屏广告
//        _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, 100)];
//        UIImageView *logo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"SplashBottomLogo"]];
//        [_bottomView addSubview:logo];
//        logo.center = _bottomView.center;
//        _bottomView.backgroundColor = [UIColor whiteColor];
//
//        [splashAd loadAdAndShowInWindow:self.window withBottomView:_bottomView];
//        self.splash = splashAd;
//        
//    }
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    [GDTTrack activateApp];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

-(void)splashAdSuccessPresentScreen:(GDTSplashAd *)splashAd
{
    NSLog(@"%s",__FUNCTION__);
}

-(void)splashAdFailToPresent:(GDTSplashAd *)splashAd withError:(NSError *)error
{
    NSLog(@"%s%@",__FUNCTION__,error);
}
-(void)splashAdApplicationWillEnterBackground:(GDTSplashAd *)splashAd
{
    NSLog(@"%s",__FUNCTION__);
}
-(void)splashAdClicked:(GDTSplashAd *)splashAd
{
    NSLog(@"%s",__FUNCTION__);
}

- (void)splashAdWillClosed:(GDTSplashAd *)splashAd
{
    NSLog(@"%s",__FUNCTION__);
}
-(void)splashAdClosed:(GDTSplashAd *)splashAd
{
    NSLog(@"%s",__FUNCTION__);
    _splash = nil;
}
-(void)splashAdWillPresentFullScreenModal:(GDTSplashAd *)splashAd
{
    NSLog(@"%s",__FUNCTION__);
}
-(void)splashAdDidDismissFullScreenModal:(GDTSplashAd *)splashAd
{
    NSLog(@"%s",__FUNCTION__);
}
@end
