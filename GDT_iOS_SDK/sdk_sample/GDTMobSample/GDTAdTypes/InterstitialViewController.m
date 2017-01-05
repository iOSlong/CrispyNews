//
//  EmptyViewController.m
//  GDTTestDemo
//
//  Created by 高超 on 13-11-1.
//  Copyright (c) 2013年 高超. All rights reserved.
//

#import "InterstitialViewController.h"

#define IS_OS_7_OR_LATER    ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)

@implementation InterstitialViewController

static NSString *INTERSTITIAL_STATE_TEXT = @"插屏状态";

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        
    }
    return self;
}

- (void)viewDidLoad
{
    if (IS_OS_7_OR_LATER) {
        self.extendedLayoutIncludesOpaqueBars = NO;
        self.edgesForExtendedLayout = UIRectEdgeBottom | UIRectEdgeLeft | UIRectEdgeRight;
    }
    [super viewDidLoad];
    _interstitialObj = [[GDTMobInterstitial alloc] initWithAppkey:@"1105344611" placementId:@"2030814134092814"];
    
    _interstitialObj.delegate = self;

}

-(void)viewWillAppear:(BOOL)animated
{
    NSLog(@"%s",__FUNCTION__);
    [super viewWillAppear:animated];
}
- (IBAction)releaseInterstitial:(id)sender {
    _interstitialObj = nil;
}

- (IBAction)loadAd:(id)sender {
    NSLog(@"load");
    [_interstitialObj loadAd];

}

- (IBAction)showAd:(id)sender {
#pragma clang diagnostic push 
#pragma clang diagnostic ignored "-Wunused-variable"
    UIViewController *vc = [[[UIApplication sharedApplication] keyWindow] rootViewController];
    //vc = [self navigationController];
#pragma clang diagnostic pop
    
    [_interstitialObj presentFromRootViewController:self];
}

// 广告预加载成功回调
//
// 详解:当接收服务器返回的广告数据成功后调用该函数
- (void)interstitialSuccessToLoadAd:(GDTMobInterstitial *)interstitial
{
    _interstitialStateLabel.text = [NSString stringWithFormat:@"%@:%@",INTERSTITIAL_STATE_TEXT,@"Success Loaded." ];
}

// 广告预加载失败回调
//
// 详解:当接收服务器返回的广告数据失败后调用该函数
- (void)interstitialFailToLoadAd:(GDTMobInterstitial *)interstitial error:(NSError *)error
{
    _interstitialStateLabel.text = [NSString stringWithFormat:@"%@:%@",INTERSTITIAL_STATE_TEXT,@"Fail Loaded." ];
    NSLog(@"interstitial fail to load, Error : %@",error);
}

// 插屏广告将要展示回调
//
// 详解: 插屏广告即将展示回调该函数
- (void)interstitialWillPresentScreen:(GDTMobInterstitial *)interstitial
{
    _interstitialStateLabel.text = [NSString stringWithFormat:@"%@:%@",INTERSTITIAL_STATE_TEXT,@"Going to present." ];
}

// 插屏广告视图展示成功回调
//
// 详解: 插屏广告展示成功回调该函数
- (void)interstitialDidPresentScreen:(GDTMobInterstitial *)interstitial
{
    _interstitialStateLabel.text = [NSString stringWithFormat:@"%@:%@",INTERSTITIAL_STATE_TEXT,@"Success Presented." ];
}

// 插屏广告展示结束回调
//
// 详解: 插屏广告展示结束回调该函数
- (void)interstitialDidDismissScreen:(GDTMobInterstitial *)interstitial
{
    _interstitialStateLabel.text = [NSString stringWithFormat:@"%@:%@",INTERSTITIAL_STATE_TEXT,@"Finish Presented." ];
    [_interstitialObj loadAd];
}

// 应用进入后台时回调
//
// 详解: 当点击下载应用时会调用系统程序打开，应用切换到后台
- (void)interstitialApplicationWillEnterBackground:(GDTMobInterstitial *)interstitial
{
    _interstitialStateLabel.text = [NSString stringWithFormat:@"%@:%@",INTERSTITIAL_STATE_TEXT,@"Application enter background." ];
}



@end
