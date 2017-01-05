//
//  BannerViewController.m
//  GDTTestDemo
//
//  Created by 高超 on 13-11-1.
//  Copyright (c) 2013年 高超. All rights reserved.
//

#define IS_OS_7_OR_LATER    ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)

#import "BannerViewController.h"
#import "GDTMobBannerView.h"
#import "InterstitialViewController.h"

@implementation BannerViewController

- (void) viewWillDisappear:(BOOL)animated {
    NSLog(@"Banner viewWillDisappear");
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"Banner view did load");
    
    // Custom initialization
    NSString *appkey = @"1105344611";
    NSString *posId = @"4090812164690039";
    
    NSLog(@"Banner view init");
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        bannerView = [[GDTMobBannerView alloc] initWithFrame:CGRectMake(0,0,GDTMOB_AD_SUGGEST_SIZE_728x90.width,GDTMOB_AD_SUGGEST_SIZE_728x90.height)
                                                      appkey:appkey placementId:posId];
    } else {
        bannerView = [[GDTMobBannerView alloc] initWithFrame:CGRectMake(0,0,GDTMOB_AD_SUGGEST_SIZE_320x50.width,GDTMOB_AD_SUGGEST_SIZE_320x50.height)
                                                      appkey:appkey placementId:posId];
    }

    
    if (IS_OS_7_OR_LATER) {
        self.extendedLayoutIncludesOpaqueBars = NO;
        self.edgesForExtendedLayout = UIRectEdgeBottom | UIRectEdgeLeft | UIRectEdgeRight;
    }
    
    bannerView.delegate = self;
    bannerView.currentViewController = [[UIApplication sharedApplication] keyWindow].rootViewController;
    bannerView.isAnimationOn = NO;
    bannerView.showCloseBtn = NO;
    bannerView.isGpsOn = YES;
    [bannerView loadAdAndShow];

//    UIWindow *fK = [[UIApplication sharedApplication] keyWindow];
//    [fK addSubview:bannerView];
    [self.view addSubview:bannerView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    NSLog(@"receive Memory Warning");
}

- (IBAction)load:(id)sender {
    [self unLoad:nil];
    
    NSString *appkey = [_appKeyText text];
    NSString *placementId = [_placementIdText text];
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        bannerView = [[GDTMobBannerView alloc] initWithFrame:CGRectMake(0,0,GDTMOB_AD_SUGGEST_SIZE_728x90.width,GDTMOB_AD_SUGGEST_SIZE_728x90.height)
                                                      appkey:appkey placementId:placementId];
    } else {
        bannerView = [[GDTMobBannerView alloc] initWithFrame:CGRectMake(0,0,GDTMOB_AD_SUGGEST_SIZE_320x50.width,GDTMOB_AD_SUGGEST_SIZE_320x50.height)
                                                      appkey:appkey placementId:placementId];
    }

    /*bannerView2 = [[GDTMobBannerView alloc] initWithFrame:CGRectMake(([[UIScreen mainScreen] bounds].size.width / 2 ), 0,
     bannerWidth,
     50)
     appkey:appkey placementId:placementId];*/
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wunused-variable"
    int interval =  [[_refreshIntervalText text] intValue];
#pragma clang diagnostic pop
    
    bool gpsEnabled = _gpsSwitch.on;
    
    
    bannerView.delegate = self;
    bannerView.isAnimationOn = _animationSwitch.on;
    bannerView.showCloseBtn = _closeBtnSwitch.on;
    bannerView.currentViewController = self.navigationController;
    bannerView.interval = 10;
    bannerView.isGpsOn = gpsEnabled;
    [bannerView loadAdAndShow];

    [self.view addSubview:bannerView];
    
    
}

- (IBAction)unLoad:(id)sender {
    
    [bannerView removeFromSuperview];
    bannerView = nil;
    /*[bannerView2 removeFromSuperview];
     bannerView2 = nil;*/
}

- (void)bannerViewMemoryWarning
{
    NSLog(@"did receive memory warning");
}

// 请求广告条数据成功后调用
//
// 详解:当接收服务器返回的广告数据成功后调用该函数
- (void)bannerViewDidReceived
{
    NSLog(@"banner Received");
}

// 请求广告条数据失败后调用
//
// 详解:当接收服务器返回的广告数据失败后调用该函数
- (void)bannerViewFailToReceived:(NSError *)error
{
    NSLog(@"banner failed to Received : %@",error);
}

// 广告栏被点击后调用
//
// 详解:当接收到广告栏被点击事件后调用该函数
- (void)bannerViewClicked
{
    NSLog(@"banner clicked");
}

// 应用进入后台时调用
//
// 详解:当点击下载或者地图类型广告时，会调用系统程序打开，
// 应用将被自动切换到后台
- (void)bannerViewWillLeaveApplication
{
    NSLog(@"banner leave application");
}
- (IBAction)didEndOnExit:(id)sender {
    [sender resignFirstResponder];
}

- (IBAction)testGotoAnotherView:(id)sender {
    
    InterstitialViewController *_viewC = [[InterstitialViewController alloc] init];

    [self.navigationController pushViewController:_viewC animated:YES];
    
}

-(void)bannerViewDidDismissFullScreenModal
{
    NSLog(@"%s",__FUNCTION__);
}

-(void)bannerViewWillDismissFullScreenModal
{
    NSLog(@"%s",__FUNCTION__);
}

-(void)bannerViewWillPresentFullScreenModal
{
    NSLog(@"%s",__FUNCTION__);
}

-(void)bannerViewDidPresentFullScreenModal
{
    NSLog(@"%s",__FUNCTION__);
}


- (void)setVisible
{
    bannerView.hidden = YES;
}

-(void)dealloc
{
    NSLog(@"bannervc dealloc");
}
@end
