//
//  BannerViewController.h
//  GDTTestDemo
//
//  Created by 高超 on 13-11-1.
//  Copyright (c) 2013年 高超. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GDTMobBannerView.h"
#import <CoreLocation/CLLocationManagerDelegate.h>
#import <StoreKit/StoreKit.h>

@interface BannerViewController : UIViewController<GDTMobBannerViewDelegate>
{
    GDTMobBannerView *bannerView;
   // GDTMobBannerView *bannerView2;
    NSTimer *timer;
    IBOutlet UITextField *_appKeyText;
    IBOutlet UITextField *_placementIdText;
    IBOutlet UITextField *_refreshIntervalText;
    IBOutlet UISwitch *_gpsSwitch;
    IBOutlet UISwitch *_animationSwitch;
    IBOutlet UISwitch *_closeBtnSwitch;
    UIView *container;
}
- (IBAction)load:(id)sender;
- (IBAction)unLoad:(id)sender;

- (IBAction)didEndOnExit:(id)sender;

- (IBAction)testGotoAnotherView:(id)sender;
@end
