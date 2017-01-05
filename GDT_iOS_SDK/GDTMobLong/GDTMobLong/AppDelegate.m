//
//  AppDelegate.m
//  GDTMobLong
//
//  Created by xuewu.long on 16/12/27.
//
//

#import "AppDelegate.h"
#import "GDTTrack.h"
#import "GDTSplashAd.h"
#import "NativeAdView.h"

@interface AppDelegate ()<GDTSplashAdDelegate>

@end

@implementation AppDelegate{
    GDTSplashAd *_splash;
    UIView *_bottomView;
    
    
    GDTNativeAd *_nativeAd;     //原生广告实例
    NSArray *_data;             //原生广告数据数组
    GDTNativeAdData *_currentAd;//当前展示的原生广告数据对象
    NativeAdView *_nativeView;

}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    
//    [self splashAd];
//    [self performSelector:@selector(splashAd) withObject:self afterDelay:0];

    return YES;
}

//启动图adID调用失败 - 
#pragma mark - Get
- (void) splashAd {
    NSString *demoID = @"1105344611";
    NSString *demoAdID = @"9040714184494018";
    
    NSString *sdspID = @"1105916224";
    NSString *sdspAdID = @"6090919871932330";
    
    NSString *androdID = @"1105841673";
    NSString *androdAdID = @"8010612801033163";
    
    NSString *chaojiID = @"1105751475";
    NSString *chaojiAdID = @"1000517781949708";
    
    
    GDTSplashAd *splashAd = [[GDTSplashAd alloc] initWithAppkey:demoID placementId:demoAdID];
    splashAd.delegate = self;//设置代理1ez        //针对不同设备尺寸设置不同的默认图片，拉取广告等待时间会展示该默认图片。
    if ([[UIScreen mainScreen] bounds].size.height >= 568.0f) {
        //        splashAd.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"LaunchImage-568h"]];
        //    } else {
        //        splashAd.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"LaunchImage"]];
    }
    //设置开屏拉取时长限制，若超时则不再展示广告
    splashAd.fetchDelay = 5;
    //［可选］拉取并展示全屏开屏广告
    //[splashAd loadAdAndShowInWindow:self.window];
    //设置开屏底部自定义LogoView，展示半屏开屏广告
    _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, 100)];
    UIImageView *logo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"SplashBottomLogo.jgp"]];
    logo.frame = _bottomView.bounds;
    [_bottomView addSubview:logo];
    _bottomView.backgroundColor = [UIColor blueColor];
    
    UIWindow *fK = [[UIApplication sharedApplication] keyWindow];
    [splashAd loadAdAndShowInWindow:fK withBottomView:_bottomView];
    
    _splash = splashAd;
}




-(void)splashAdSuccessPresentScreen:(GDTSplashAd *)splashAd;{
    NSLog(@"splashAd = %@",splashAd);
}

/**
 *  开屏广告展示失败
 */
-(void)splashAdFailToPresent:(GDTSplashAd *)splashAd withError:(NSError *)error;{
    NSLog(@"%@",error);
}



- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    [GDTTrack activateApp];
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
