
//
//  NativeAdView.m
//  GDTMobLong
//
//  Created by xuewu.long on 16/12/27.
//
//

#import "NativeAdView.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface NativeAdView ()

@end

#define k_spanH 8
#define k_spanV 5

@implementation NativeAdView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self configureUIItems];
        
        [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick:)]];
    }
    return self;
}

- (void)tapClick:(UITapGestureRecognizer *)tapG {
    if (self.adBlock) {
        self.adBlock();
    }
}

- (void)nativeAdBlock:(NativeADVBlock)adBlock {
    _adBlock = adBlock;
}

- (void)configureUIItems {
    self.imgvShow = [[UIImageView alloc] initWithFrame:CGRectMake(k_spanH, k_spanV, self.bounds.size.height * 2, self.bounds.size.height - 2 * k_spanV)];
    self.imgvShow.contentMode = UIViewContentModeScaleAspectFill;
    self.imgvShow.backgroundColor = [UIColor yellowColor];
    self.imgvIcon = [[UIImageView alloc] initWithFrame:self.imgvShow.frame];
    self.imgvIcon.contentMode = UIViewContentModeScaleAspectFit;
    
    self.labelTitle = [[UILabel alloc] initWithFrame:CGRectMake(k_spanH * 2 + self.imgvShow.bounds.size.width, k_spanV, self.bounds.size.width - (k_spanH * 3 + self.imgvShow.bounds.size.width), 20)];
    
    self.labelDesc = [[UILabel alloc] initWithFrame:CGRectMake(self.labelTitle.frame.origin.x, self.labelTitle.frame.origin.y + self.labelTitle.bounds.size.height + k_spanV, self.labelTitle.frame.size.width, self.bounds.size.height - 3 * k_spanV - 20)];
    self.labelDesc.numberOfLines = 3;
    
//    self.imgvShow.backgroundColor = [UIColor lightGrayColor];
//    self.labelTitle.backgroundColor = [UIColor lightGrayColor];
//    self.labelDesc.backgroundColor = [UIColor lightGrayColor];
    
    
    [self addSubview:self.imgvShow];
    [self addSubview:self.imgvIcon];
    [self addSubview:self.labelTitle];
    [self addSubview:self.labelDesc];
    
}

- (void)setAdData:(GDTNativeAdData *)adData
{
    
    self.labelTitle.text = [adData.properties objectForKey:@"title"];
    self.labelDesc.frame = CGRectMake(self.labelTitle.frame.origin.x, self.labelTitle.frame.origin.y + self.labelTitle.bounds.size.height + k_spanV, self.labelTitle.frame.size.width, self.bounds.size.height - 3 * k_spanV - 20);
    self.labelDesc.text  = [adData.properties objectForKey:@"desc"];
    [self.labelDesc sizeToFit];
    
    NSString *iconUrl = [adData.properties objectForKey:@"icon"]; // 小图
//    NSString *imgvUrl = [adData.properties objectForKey:@"img"];// 大图
    
    [self.imgvShow sd_setImageWithURL:[NSURL URLWithString:iconUrl]];
//    [self.imgvShow sd_setImageWithURL:[NSURL URLWithString:imgvUrl]];
    
}




@end







