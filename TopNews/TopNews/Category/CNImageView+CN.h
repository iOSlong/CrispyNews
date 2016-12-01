//
//  UIImageView+CN.h
//  TopNews
//
//  Created by xuewu.long on 16/10/30.
//  Copyright © 2016年 levt. All rights reserved.
//

#import "CNImageView.h"
#import "CNImgCache.h"
#import <SDWebImage/SDWebImageManager.h>

@interface CNImageView (CN)

- (NSURL *)CNletvImgFromOriginUrl:(NSURL *)url;

- (void)cn_setImageWithURL:(NSURL *)url;


- (void)cn_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder;

- (void)cn_setImageWithURL:(NSURL *)url completed:(SDWebImageCompletionBlock)completedBlock;

- (void)cn_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder completed:(SDWebImageCompletionBlock)completedBlock;
- (void)cn_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder options:(SDWebImageOptions)options progress:(SDWebImageDownloaderProgressBlock)progressBlock completed:(SDWebImageCompletionBlock)completedBlock;

- (void)cn_cancelCurrentImageLoad;



@end
