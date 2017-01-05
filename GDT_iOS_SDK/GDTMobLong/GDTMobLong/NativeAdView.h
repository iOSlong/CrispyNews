//
//  NativeAdView.h
//  GDTMobLong
//
//  Created by xuewu.long on 16/12/27.
//
//

#import <UIKit/UIKit.h>
#import "GDTNativeAd.h"


typedef void(^NativeADVBlock)();
@interface NativeAdView : UIView

@property (nonatomic, strong) GDTNativeAdData *adData;
@property (nonatomic, copy)NativeADVBlock adBlock;


@property (nonatomic, strong) UIImageView *imgvShow;
@property (nonatomic, strong) UIImageView *imgvIcon;
@property (nonatomic, strong) UILabel *labelDesc;
@property (nonatomic, strong) UILabel *labelTitle;
@property (nonatomic, strong) UILabel *labelRating;

- (void)nativeAdBlock:(NativeADVBlock)adBlock;

@end
