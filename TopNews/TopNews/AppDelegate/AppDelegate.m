//
//  AppDelegate.m
//  CrispyNews
//
//  Created by 陈肖坤 on 16/7/14.
//  Copyright © 2016年 陈肖坤. All rights reserved.
//

#import "AppDelegate.h"
#import "CNMenuDrawerTableViewController.h"
#import "CNPageViewController.h"
#import "CNChannelManager.h"
#import "CNApiManager.h"
#import "CNNewsDetailUIWebViewController.h"


#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKShareKit/FBSDKShareKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <Fabric/Fabric.h>
#import <TwitterKit/TwitterKit.h>
#import <AFNetworking/AFNetworkActivityIndicatorManager.h>
#import <AFNetworking/AFNetworkReachabilityManager.h>

//#import "LTLSUserManager.h"
#import "CNHttpRequest.h"
#import <SSZipArchive/SSZipArchive.h>
#import "CNDataLoad.h"

#if defined(__IPHONE_10_0) && __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
@import UserNotifications;
#endif

#import <FirebaseCore/FirebaseCore.h>
#import <FirebaseInstanceID/FirebaseInstanceID.h>
#import <FirebaseMessaging/FirebaseMessaging.h>

#pragma mark - 数据上报
#import "Agnes.h"
#import "AGS_Enums.h"
#import "AGS_App.h"

#import <KSCrash/KSCrashInstallationStandard.h>


#pragma mark - test todo delete after debug
#import "NSString+CN.h"
#import <ALSystemUtilities/ALSystem.h>

// Implement UNUserNotificationCenterDelegate to receive display notification via APNS for devices
// running iOS 10 and above. Implement FIRMessagingDelegate to receive data message via FCM for
// devices running iOS 10 and above.
#if defined(__IPHONE_10_0) && __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0

@interface AppDelegate () <UNUserNotificationCenterDelegate,FIRMessagingDelegate>

@end

#endif

// Copied from Apple's header in case it is missing in some cases (e.g. pre-Xcode 8 builds).
#ifndef NSFoundationVersionNumber_iOS_9_x_Max
#define NSFoundationVersionNumber_iOS_9_x_Max 1299
#endif


@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
   
    
    
    [[FBSDKApplicationDelegate sharedInstance] application:application didFinishLaunchingWithOptions:launchOptions];
    [FBSDKProfile enableUpdatesOnAccessTokenChange:YES];
    //1210650745662841  /   1232617296771123
    [FBSDKSettings setAppID:@"1210650745662841"];
    
#pragma mark Agnes 数据上报
    //埋点
    [CNUtils AgnesRegist];
    

    
    /// 用户第一次使用，serverMode 和 BuildMode 设置为一致。
    CNDefult *cndefult = [CNDefult shareDefult];
    if (cndefult.serverMode == nil && BUILD_MODE != 1) {
        cndefult.serverMode = [NSNumber numberWithInteger:BUILD_MODE];
        
        if (BUILD_MODE == 0) {
            cndefult.serverMode = @1;// 如果是测试包，默认使用线上数据。
        }
    }
    
    NSString *imageURL = @"http://www.livemint.com/rf/Image-621x414/LiveMint/Period2/2016/11/15/Photos/Opinion/edit-japan-kgxH--621x414@LiveMint.jpg";
    NSString *codeURL  = [imageURL URLEncoded];
    NSString *imgCaheName = [NSString cachedFileNameForKey:codeURL];
    NSLog(@"%@",imgCaheName);
    
    

    
    /// 容器视图控制器初始
    [self defaultRootController];
 
    /// 获取  News Themes Channels
    [self netGetChannels];
     
    

    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@""] options:@{} completionHandler:^(BOOL success) {
        
    }];
    
    
    
    
    // Register for remote notifications
    if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_7_1) {
        // iOS 7.1 or earlier. Disable the deprecation warnings.
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        UIRemoteNotificationType allNotificationTypes =
        (UIRemoteNotificationTypeSound |
         UIRemoteNotificationTypeAlert |
         UIRemoteNotificationTypeBadge);
        [application registerForRemoteNotificationTypes:allNotificationTypes];
#pragma clang diagnostic pop
    } else {
        // iOS 8 or later
        // [START register_for_notifications]
        if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_9_x_Max) {
            UIUserNotificationType allNotificationTypes =
            (UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge);
            UIUserNotificationSettings *settings =
            [UIUserNotificationSettings settingsForTypes:allNotificationTypes categories:nil];
            [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
        } else {
            // iOS 10 or later
#if defined(__IPHONE_10_0) && __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
            UNAuthorizationOptions authOptions =
            UNAuthorizationOptionAlert
            | UNAuthorizationOptionSound
            | UNAuthorizationOptionBadge;
            [[UNUserNotificationCenter currentNotificationCenter]
             requestAuthorizationWithOptions:authOptions
             completionHandler:^(BOOL granted, NSError * _Nullable error) {
                 
             }
             ];
            
            // For iOS 10 display notification (sent via APNS)
            [[UNUserNotificationCenter currentNotificationCenter] setDelegate:self];
            // For iOS 10 data message (sent via FCM)
            [[FIRMessaging messaging] setRemoteMessageDelegate:self];
#endif
        }
        [[UIApplication sharedApplication] registerForRemoteNotifications];
        // [END register_for_notifications]
    }
    // [START configure_firebase]
    [FIRApp configure];
    // [END configure_firebase]
    // Add observer for InstanceID token refresh callback.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tokenRefreshNotification:)
                                                 name:kFIRInstanceIDTokenRefreshNotification object:nil];
    
    
    
    KSCrashInstallationStandard* installation = [KSCrashInstallationStandard sharedInstance];
    installation.url = [NSURL URLWithString:@"https://collector.bughd.com/kscrash?key=7a63226fe7ff1f083a58581e4026084f"];
    [installation install];
    [installation sendAllReportsWithCompletion:nil];
    
    
//    NSDictionary *dict = nil;
//    ============ *
//    NSDictionary *newdict = @{@"dict":dict};
//    
//    NSLog(@"%@",newdict);
    
    
    
    return YES;
}

#pragma mark - Application_State About
// [END connect_to_fcm]
- (void)applicationDidBecomeActive:(UIApplication *)application {
    [FBSDKAppEvents activateApp];
    [self connectToFcm];
    NSLog(@"连接 FCM");
    
    NSDictionary *dict = @{@"eid":[CNUtils myRandomUUID]};
    [CNUtils reportInfo:dict widget:WIDGET_APPON Evt:evt_glide];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    
    NSDictionary *dict = @{@"eid":[CNUtils myRandomUUID]};
    [CNUtils reportInfo:dict widget:WIDGET_APPENBACK Evt:evt_glide];
}

// [START disconnect_from_fcm]
- (void)applicationDidEnterBackground:(UIApplication *)application {
    [[FIRMessaging messaging] disconnect];
    NSLog(@"断开 FCM");
    
    NSDictionary *dict = @{@"eid":[CNUtils myRandomUUID]};
    [CNUtils reportInfo:dict widget:WIDGET_APPHOMEBACK Evt:evt_glide];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    NSDictionary *dict = @{@"eid":[CNUtils myRandomUUID]};
    [CNUtils reportInfo:dict widget:WIDGET_APPOFF Evt:evt_glide];
    
    NSLog(@"terminate :%s",__FUNCTION__);
    NSLog(@"clear Over");
}




//#pragma mark - Notification About
//
////注册远程推送通知完毕就会调用  --获得deviceToken
//- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
//{
//    NSLog(@"======%@",deviceToken);
//    [self obtainDeviceToken:deviceToken];
//}
//
//- (void)obtainDeviceToken:(NSData *)deviceToken {
//    
//    NSString  *tokenStr = [[deviceToken description] stringByReplacingOccurrencesOfString:@"<" withString:@""];
//    tokenStr = [tokenStr stringByReplacingOccurrencesOfString:@">" withString:@""];
//    tokenStr = [tokenStr stringByReplacingOccurrencesOfString:@" " withString:@""];
//    
//    //封装参数
//    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
//    parameters[@"devId"] = [CNUtils getDeviceUIID];
//    parameters[@"token"] = tokenStr;
//    parameters[@"app_key"] = @"fbdpvvc07ilnutke81291202";
//    parameters[@"model"] = @"iPhone";
//    parameters[@"version"] = @"V1.3.4";
//    
//    NSString *urlStr = [CNUtils getPushServerHost];
//    [CNDefult shareDefult].deviceToken = tokenStr;
//    
//    [[CNHttpRequest shareHttpRequest] POST:urlStr parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
//        NSLog(@"===%@",responseObject);
//        //        value	__NSCFString *	@"app_key错误,未找到对应的app，请检查app合法性"	0x000000012f802f50
//    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
//        NSLog(@"你好%@",error);
//        
//    }];
//
//}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    if (error) {
        NSLog(@"error = %@",error);
    }
}

- (void)applicationReceivedRemoteMessage:(FIRMessagingRemoteMessage *)remoteMessage {

}

////接收远程推送的信息前台(系统)
//- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
//    
//    if (userInfo) {
//        NSLog(@"userInfo = %@",userInfo);
//        [CNUtils showHint:[[userInfo objectForKey:@"aps"] objectForKey:@"alert"] hide:3];
//    }
//}
//
////接收远程推送的信息后台(系统和 Firebase 都走这方法)
//- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
//{
//    if (userInfo) {
//        NSLog(@"userInfo = %@",userInfo[@"news_detail_uri"]);
////        NSString *pushUrlStr = userInfo[@"news_derail_uri"];
//        // 1.取出MainViewController
////        UINavigationController *rootNav = (UINavigationController *)self.window.rootViewController;
////        CNNewsDetailViewController *mainVc = [rootNav.childViewControllers firstObject];
////        [rootNav popToRootViewControllerAnimated:NO];
//        
//        NSRange range = [userInfo[@"news_derail_uri"] rangeOfString:@"?"];
//        
//        // 2.从?后一位开始截取,截取到URL的字符串
//        NSString *appStr = [userInfo[@"news_derail_uri"] substringFromIndex:range.location + 1];
//        NSString *appURLStr = [NSString stringWithFormat:@"%@://", appStr];
//        
//         NSLog(@"%@", appURLStr);
//        // 3.打开URL(打开对应的APP)
//        NSURL *appURL = [NSURL URLWithString:appURLStr];
//        if ([[UIApplication sharedApplication] canOpenURL:appURL]) {
//            [[UIApplication sharedApplication] openURL:appURL];
//        }
//
//
//    }
//}
#if defined(__IPHONE_10_0) && __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
//firebase 在后台时
- (void)userNotificationCenter:(UNUserNotificationCenter *)center
didReceiveNotificationResponse:(UNNotificationResponse *)response
         withCompletionHandler:(void (^)())completionHandler {
    NSDictionary *userInfo = response.notification.request.content.userInfo;
    NSLog(@"%@", userInfo[@"news_detail_uri"]);
    NSLog(@"%@", userInfo);
    
}

//firebase 在前台时
- (void)userNotificationCenter:(UNUserNotificationCenter *)center
       willPresentNotification:(UNNotification *)notification
         withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler {
    // Print message ID.
    NSDictionary *userInfo = notification.request.content.userInfo;
    NSLog(@"Message ID: %@", userInfo[@"news_detail_uri"]);

}

#endif

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    return [[FBSDKApplicationDelegate sharedInstance] application:application
                                                          openURL:url
                                                sourceApplication:sourceApplication
                                                       annotation:annotation];

}

- (void)tokenRefreshNotification:(NSNotification *)notification {
    
    NSString *refreshedToken = [[FIRInstanceID instanceID] token];
    NSLog(@"InstanceID token: %@", refreshedToken);
    
    // Connect to FCM since connection may have failed when attempted before having a token.
    [self connectToFcm];
    //tokem传给服务器
    NSString *loginURL = [CNApiManager apiNewsPushToken];
    NSLog(@"%@",loginURL);
    //封装参数
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters [@"pushToken"] = refreshedToken;
    parameters [@"pushChannel"] = @1;
    
    [[CNHttpRequest shareHttpRequest] POST:loginURL parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        NSLog(@"===%@",responseObject);
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
    
    
}
//    [self obtainDeviceToken:refreshedToken];
//}
//
//- (void)obtainDeviceToken:(NSData *)refreshedToken {
//    
//    NSString  *tokenStr = [[refreshedToken description] stringByReplacingOccurrencesOfString:@"<" withString:@""];
//    tokenStr = [tokenStr stringByReplacingOccurrencesOfString:@">" withString:@""];
//    tokenStr = [tokenStr stringByReplacingOccurrencesOfString:@" " withString:@""];
//    
//    //封装参数
//    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
//    parameters[@"devId"] = [CNUtils getDeviceUIID];
//    parameters[@"token"] = tokenStr;
//    parameters[@"app_key"] = @"fbdpvvc07ilnutke81291202";
//    parameters[@"model"] = @"iPhone";
//    parameters[@"version"] = @"V1.3.4";
//    
//    NSString *urlStr = [CNUtils getPushServerHost];
//    [CNDefult shareDefult].deviceToken = tokenStr;
//    
//    [[CNHttpRequest shareHttpRequest] POST:urlStr parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
//        NSLog(@"===%@",responseObject);
//        //        value	__NSCFString *	@"app_key错误,未找到对应的app，请检查app合法性"	0x000000012f802f50
//    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
//        NSLog(@"你好%@",error);
//        
//    }];
//    
//}

// [START connect_to_fcm]
- (void)connectToFcm {
    [[FIRMessaging messaging] connectWithCompletion:^(NSError * _Nullable error) {
        if (error != nil) {
            NSLog(@"无法连接到 FCM. %@", error);
        } else {
            NSLog(@"连接 FCM.");
        }
    }];
}


#pragma mark - 容器视图控制器初始
- (void)defaultRootController {
    
    CNMenuDrawerTableViewController *menuDrawerVC = [[CNMenuDrawerTableViewController alloc]init];
    
    
    _homeNewsVC = [[CNHomeNewsViewController alloc]init];
    CNNavigationController *homeNesNav = [[CNNavigationController alloc] initWithRootViewController:_homeNewsVC];
    
    _crispyMenu = [[MMDrawerController alloc]initWithCenterViewController:homeNesNav leftDrawerViewController:menuDrawerVC];
    
    [_crispyMenu setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
    [_crispyMenu setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeAll];
    [_crispyMenu setShouldStretchDrawer:NO];
    [_crispyMenu setShowsShadow:YES];
    [_crispyMenu setMaximumLeftDrawerWidth:k_Drawer_W];

    self.window.rootViewController = self.crispyMenu;

    [self.window makeKeyAndVisible];
    
}


- (void)netGetChannels {
    // TODO! 存储的如果没有，那么从本地默认plist中取出数据。
    CNChannelManager *_channelM = [CNChannelManager shareChannelManager];
    
    NSArray *sqlChannels = [_channelM.dataManager getChannelAllByASC_StateOn:YES];
    if (sqlChannels && sqlChannels.count)
    {
        [_channelM addChannels:sqlChannels];
    }
    else
    {
        // 获取本地默认频道
        NSArray *defultChannels = [CNDataManager defultChannels];
        
        // 分配数据存储空间
        [_channelM addChannels:defultChannels];
        
        // 删除数据库中 选中频道
        [_channelM.dataManager clearChannel_StateOn:YES];
        [_channelM.dataManager clearChannel_StateOn:NO];

        // 添加默认选中频道到数据库中
        [_channelM.dataManager addChannels:defultChannels];
    }
        
    // 更新频道数据分页界面
    [self reloadChannelToHomeViewController:_channelM.arrChannel];
    // 目前所有频道使用本地工程目录文件中的频道信息。 TODO!  1.系统频道推荐偏好接口获取  2.用户可设置频道选项设置。
}

- (void)reloadChannelToHomeViewController:(NSArray *)channels {
//    NSLog(@"channels = %@",channels);
    self.homeNewsVC.arrChannel = channels;
}






@end


