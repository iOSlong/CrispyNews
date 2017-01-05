//
//  SplashViewContronller.m
//  GDTMobApp
//
//  Created by GaoChao on 15/8/21.
//  Copyright © 2015年 Tencent. All rights reserved.
//

#import "SplashViewController.h"
#import "GDTSplashAd.h"

@implementation SplashViewController
{
    GDTSplashAd *_splash;
    UIView *_bottomView;
}


-(void)viewDidLoad
{
    [super viewDidLoad];
    
    _splash = [[GDTSplashAd alloc] initWithAppkey:@"1105344611" placementId:@"9040714184494018"];
    _splash.delegate = self;
    
    if ([[UIScreen mainScreen] bounds].size.height >= 568.0f) {
        _splash.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"SplashBottomLogo"]];
    } else {
        _splash.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"SplashBottomLogo"]];
    }

    UIWindow *fK = [[UIApplication sharedApplication] keyWindow];
    _splash.fetchDelay = 5;
    
    [_splash loadAdAndShowInWindow:fK];
}

-(void)splashAdSuccessPresentScreen:(GDTSplashAd *)splashAd
{
    NSLog(@"%s",__FUNCTION__);
}

-(void)splashAdFailToPresent:(GDTSplashAd *)splashAd withError:(NSError *)error
{
    NSLog(@"%s%@",__FUNCTION__,error);
}

-(void)splashAdClicked:(GDTSplashAd *)splashAd
{
    NSLog(@"%s",__FUNCTION__);
}

-(void)splashAdApplicationWillEnterBackground:(GDTSplashAd *)splashAd
{
    NSLog(@"%s",__FUNCTION__);
}

-(void)splashAdWillClosed:(GDTSplashAd *)splashAd
{
    NSLog(@"%s",__FUNCTION__);
}

-(void)splashAdClosed:(GDTSplashAd *)splashAd
{
    NSLog(@"%s",__FUNCTION__);
   _splash = nil;
}

- (void)splashAdWillPresentFullScreenModal:(GDTSplashAd *)splashAd
{
    NSLog(@"%s",__FUNCTION__);
}

- (void)splashAdDidPresentFullScreenModal:(GDTSplashAd *)splashAd
{
     NSLog(@"%s",__FUNCTION__);
}

- (void)splashAdWillDismissFullScreenModal:(GDTSplashAd *)splashAd
{
     NSLog(@"%s",__FUNCTION__);
}
-(void)splashAdDidDismissFullScreenModal:(GDTSplashAd *)splashAd
{
    NSLog(@"%s",__FUNCTION__);
}




@end
