//
//  UIImageView+CN.m
//  TopNews
//
//  Created by xuewu.long on 16/10/30.
//  Copyright © 2016年 levt. All rights reserved.
//

#import "CNImageView+CN.h"
#import <objc/runtime.h>
#import <SDWebImage/UIView+WebCacheOperation.h>
#import "CNImgManager.h"

static char imageURLKey;
static char TAG_ACTIVITY_INDICATOR;
static char TAG_ACTIVITY_STYLE;
static char TAG_ACTIVITY_SHOW;


@implementation CNImageView (CN)


- (NSURL *)CNletvImgFromOriginUrl:(NSURL *)url{
    // 转换一下URL ，判别一下是不是乐视CDN地址的url
    if ([url.absoluteString containsString:@"letvimg"]) {
        NSLog(@"%@",url.absoluteString);
        if ([url.absoluteString containsString:@"_bak"]) {
            CGFloat scale = [UIScreen mainScreen].scale;
            NSMutableString *letvCDN = [NSMutableString stringWithString:url.absoluteString];
            [letvCDN replaceOccurrencesOfString:@"_bak" withString:[NSString stringWithFormat:@"_%.f_%.f",self.width * scale,self.height * scale] options:NSCaseInsensitiveSearch range:NSMakeRange(url.absoluteString.length - 10, 10)];
            url = [NSURL URLWithString:letvCDN];
        }
    }
    return url;
}

- (void)cn_setImageWithURL:(NSURL *)url;{
    [self cn_setImageWithURL:url placeholderImage:nil options:0 progress:nil completed:nil];
}


- (void)cn_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder;{
    [self cn_setImageWithURL:url placeholderImage:placeholder options:0 progress:nil completed:nil];
}

- (void)cn_setImageWithURL:(NSURL *)url completed:(SDWebImageCompletionBlock)completedBlock;{
    [self cn_setImageWithURL:url placeholderImage:nil options:0 progress:nil completed:completedBlock];
}

- (void)cn_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder completed:(SDWebImageCompletionBlock)completedBlock;{
    [self cn_setImageWithURL:url placeholderImage:placeholder options:0 progress:nil completed:completedBlock];
}
- (void)cn_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder options:(SDWebImageOptions)options progress:(SDWebImageDownloaderProgressBlock)progressBlock completed:(SDWebImageCompletionBlock)completedBlock;
{
    
    url = [self CNletvImgFromOriginUrl:url];
    
    objc_setAssociatedObject(self, &imageURLKey, url, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if (!(options & SDWebImageDelayPlaceholder)) {
        dispatch_main_async_safe(^{
            self.image = placeholder;
            [self showTitle:YES];
        });
    }
    
    if (url) {
        
        // check if activityView is enabled or not
        if ([self showActivityIndicatorView]) {
            [self addCNActivityIndicator];
        }
        weakSelf();
        id <SDWebImageOperation> operation = [CNImgManager.sharedManager downloadImageWithURL:url options:options progress:progressBlock completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
            [weakSelf removeActivityIndicator];
            if (!weakSelf) return;
            dispatch_main_sync_safe(^{
                if (!weakSelf) return;
                if (image && (options & SDWebImageAvoidAutoSetImage) && completedBlock)
                {
                    completedBlock(image, error, cacheType, url);
                    return;
                }
                else if (image) {
                    weakSelf.image = image;
                    [weakSelf setNeedsLayout];
                    if (CGImageGetWidth(image.CGImage) >= 4) {
                        [weakSelf showTitle:NO];
                    }
                } else {
                    if ((options & SDWebImageDelayPlaceholder)) {
                        weakSelf.image = placeholder;
                        [weakSelf setNeedsLayout];
                        [weakSelf showTitle:YES];
                    }
                }
                if (completedBlock && finished) {
                    completedBlock(image, error, cacheType, url);
                }
            });
        }];
        [self sd_setImageLoadOperation:operation forKey:@"UIImageViewImageLoad"];
    } else {
        dispatch_main_async_safe(^{
            [self removeActivityIndicator];
            if (completedBlock) {
                NSError *error = [NSError errorWithDomain:SDWebImageErrorDomain code:-1 userInfo:@{NSLocalizedDescriptionKey : @"Trying to load a nil url"}];
                completedBlock(nil, error, SDImageCacheTypeNone, url);
            }
        });
    }
}

- (UIActivityIndicatorView *)activityIndicator {
    return (UIActivityIndicatorView *)objc_getAssociatedObject(self, &TAG_ACTIVITY_INDICATOR);
}

- (void)setActivityIndicator:(UIActivityIndicatorView *)activityIndicator {
    objc_setAssociatedObject(self, &TAG_ACTIVITY_INDICATOR, activityIndicator, OBJC_ASSOCIATION_RETAIN);
}

- (void)setShowActivityIndicatorView:(BOOL)show{
    objc_setAssociatedObject(self, &TAG_ACTIVITY_SHOW, [NSNumber numberWithBool:show], OBJC_ASSOCIATION_RETAIN);
}

- (BOOL)showActivityIndicatorView{
    return [objc_getAssociatedObject(self, &TAG_ACTIVITY_SHOW) boolValue];
}

- (void)setIndicatorStyle:(UIActivityIndicatorViewStyle)style{
    objc_setAssociatedObject(self, &TAG_ACTIVITY_STYLE, [NSNumber numberWithInt:style], OBJC_ASSOCIATION_RETAIN);
}

- (int)getIndicatorStyle{
    return [objc_getAssociatedObject(self, &TAG_ACTIVITY_STYLE) intValue];
}


- (void)addCNActivityIndicator {
    if (!self.activityIndicator) {
        self.activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:[self getIndicatorStyle]];
        self.activityIndicator.translatesAutoresizingMaskIntoConstraints = NO;
        
        dispatch_main_async_safe(^{
            [self addSubview:self.activityIndicator];
            
            [self addConstraint:[NSLayoutConstraint constraintWithItem:self.activityIndicator
                                                             attribute:NSLayoutAttributeCenterX
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:self
                                                             attribute:NSLayoutAttributeCenterX
                                                            multiplier:1.0
                                                              constant:0.0]];
            [self addConstraint:[NSLayoutConstraint constraintWithItem:self.activityIndicator
                                                             attribute:NSLayoutAttributeCenterY
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:self
                                                             attribute:NSLayoutAttributeCenterY
                                                            multiplier:1.0
                                                              constant:0.0]];
        });
    }
    
    dispatch_main_async_safe(^{
        [self.activityIndicator startAnimating];
    });
    
}




- (void)cn_cancelCurrentImageLoad;{
    [self sd_cancelImageLoadOperationWithKey:@"UIImageViewImageLoad"];
}

- (void)removeActivityIndicator {
    if (self.activityIndicator) {
        [self.activityIndicator removeFromSuperview];
        self.activityIndicator = nil;
    }
}







- (UILabel *)labelTitle{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.width, 30)];
    label.text = @"TopNews";
    label.textColor = RGBCOLOR_HEX(0xFFFFFF);
    if (self.width > SCREENW * 0.5) {
        label.font = [CNUtils fontPreference:FONT_Helvetica size:25];
    }
    label.font = [CNUtils fontPreference:FONT_Helvetica size:17];
    return label;
}

- (void)showTitle:(BOOL)show {
    if (show) {
        [self.label setHidden:NO];
    }else{
        [self.label setHidden:YES];
    }
}


@end
