//
//  EmptyViewController.h
//  GDTTestDemo
//
//  Created by 高超 on 13-11-1.
//  Copyright (c) 2013年 高超. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "GDTMobInterstitial.h"
#import "GDTMobBannerView.h"

@interface InterstitialViewController : UIViewController<GDTMobInterstitialDelegate>
{
    GDTMobInterstitial *_interstitialObj;
    
}

@property (unsafe_unretained, nonatomic) IBOutlet UILabel *interstitialStateLabel;
- (IBAction)showAd:(id)sender;
- (IBAction)loadAd:(id)sender;

@end
