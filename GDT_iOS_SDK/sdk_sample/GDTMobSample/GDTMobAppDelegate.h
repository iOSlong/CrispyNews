//
//  GDTMobAppDelegate.h
//  GDTMobSample
//
//  Created by GaoChao on 13-12-9.
//  Copyright (c) 2013年 Tencent. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewController.h"
#import "GDTSplashAd.h"

@interface GDTMobAppDelegate : UIResponder <UIApplicationDelegate,GDTSplashAdDelegate>

@property (retain, nonatomic) UIWindow *window;
@property (retain, nonatomic) UIViewController *viewController;
@property (retain, nonatomic) GDTSplashAd *splash;
@property (retain, nonatomic) UIView *bottomView;

@end
