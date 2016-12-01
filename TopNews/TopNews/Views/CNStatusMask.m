//
//  CNStatusMask.m
//  TopNews
//
//  Created by xuewu.long on 16/9/13.
//  Copyright © 2016年 levt. All rights reserved.
//

#import "CNStatusMask.h"

@implementation CNHeaderStatusBar {
    BOOL isShowing;
}
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame: frame]) {
        self.label = [[UILabel alloc] initWithFrame:self.bounds];
        self.label.textAlignment = NSTextAlignmentCenter;
        self.label.textColor = RGBACOLOR_HEX(0xfc5700, 0.4);
        self.label.font = [CNUtils fontPreference:nil size:16];
        self.label.text = networknotAvailable;
        [self addSubview:self.label];
        
        self.imgvBack = [[UIImageView alloc] initWithFrame:self.bounds];
        self.imgvBack.backgroundColor = RGBACOLOR_HEX(0xfc5700, 0.05);
        [self addSubview:self.imgvBack];
        [self sendSubviewToBack:self.imgvBack];
//        self.layer.backgroundColor = RGBACOLOR_HEX(0xfc5700, 0.05).CGColor;
        self.backgroundColor = [UIColor whiteColor];
        
    }
    return self;
}

- (void)showFrom:(UIView *)desView hide:(CGFloat)delay {
    if (isShowing) {
        return;
    }
    isShowing = YES;
    self.top = -40;
    [self setHidden:NO];
    [desView addSubview:self];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:0.25 animations:^{
            self.top = 0;
        } completion:^(BOOL finished) {
            [self performSelector:@selector(hidden) withObject:self afterDelay:delay];
        }];

    });
}

- (void)showFrom:(UIView *)desView hint:(NSString *)msg hide:(CGFloat)delay offSetY:(CGFloat)offY;
{
    if (isShowing) {
        return;
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        isShowing = YES;
        self.top = -40 + offY;
        self.label.text = msg;
        [self setHidden:NO];
        [desView addSubview:self];
        [desView bringSubviewToFront:self];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [UIView animateWithDuration:0.25 animations:^{
                self.top = offY;
            } completion:^(BOOL finished) {
                [self performSelector:@selector(hidden) withObject:self afterDelay:delay];
            }];
        });
    });

}

- (void)showFrom:(UIView *)desView hint:(NSString *)msg hide:(CGFloat)delay {
    [self showFrom:desView hint:msg hide:delay offSetY:0];
}

- (void)hidden{
    [UIView animateWithDuration:0.25 animations:^{
        self.top = -40;
    } completion:^(BOOL finished) {
        isShowing = NO;
        [self setHidden:YES];
        [self removeFromSuperview];
    }];
}
CGFloat delay()
{
    return 2.0f;
}
NSString * fetchCount(NSInteger count)
{
    return [NSString stringWithFormat:@"%ld news fetched",count];
}

@end



@implementation CNStatusMask

- (instancetype)initWithFrame:(CGRect)frame type:(CNStatusMaskType)type {
    self = [super initWithFrame:frame];
    if (self) {
        UIImage *img_ufo = [UIImage imageNamed:@"img_ufo"];
        CGFloat img_w = CGImageGetWidth(img_ufo.CGImage)/2;
        CGFloat img_h = CGImageGetHeight(img_ufo.CGImage)/2;
        
        CGFloat real_w = 277.0 * kRATIO / 2;
        CGFloat real_h = real_w * img_h/img_w;
        
        _imgvFace = [[UIImageView alloc] initWithFrame:CGRectMake((frame.size.width - real_w)/2, (frame.size.height - real_h)/2 - 64, real_w, real_h)];
        _imgvFace.image = img_ufo;
        
        
        _label = [[UILabel alloc] initWithFrame:CGRectMake(0, _imgvFace.bottom, self.width, 40)];
        _label.textAlignment = NSTextAlignmentCenter;
        _label.font = [CNUtils fontPreference:nil size:16];
        _label.textColor = RGBACOLOR_HEX(0x131313, 0.3);
        _label.text = @"TopNews";
        if (type == CNStatusMaskFavesEmpty) {
            _label.text = @"No Bookmarks found";
        }
        
        [self addSubview:_imgvFace];
        [self addSubview:_label];

    }
    return self;
}

@end
