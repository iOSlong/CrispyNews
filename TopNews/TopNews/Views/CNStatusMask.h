//
//  CNStatusMask.h
//  TopNews
//
//  Created by xuewu.long on 16/9/13.
//  Copyright © 2016年 levt. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CNHeaderStatusBar : UIView

@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) UIImageView *imgvBack;

- (void)showFrom:(UIView *)desView hide:(CGFloat)delay;
- (void)showFrom:(UIView *)desView hint:(NSString *)msg hide:(CGFloat)delay;
- (void)showFrom:(UIView *)desView hint:(NSString *)msg hide:(CGFloat)delay offSetY:(CGFloat)offY;

CGFloat delay();
NSString * fetchCount(NSInteger count);


@end



typedef NS_ENUM(NSUInteger, CNStatusMaskType) {
    CNStatusMaskDataEmpty,
    CNStatusMaskFavesEmpty,
    CNStatusMaskNone,
    CNStatusMaskOther,
};

@interface CNStatusMask : UIView

@property (nonatomic, strong) UIImageView *imgvFace;
@property (nonatomic, strong) UILabel *label;

- (instancetype)initWithFrame:(CGRect)frame type:(CNStatusMaskType)type;


@end
