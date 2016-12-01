//
//  CNImgManager.h
//  TopNews
//
//  Created by xuewu.long on 16/10/30.
//  Copyright © 2016年 levt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SDWebImage/SDWebImageManager.h>
#import "CNImgCache.h"


@class CNImgManager;
@protocol CNImgManagerDelegate <NSObject>
@optional
- (BOOL)imageManager:(CNImgManager *)imageManager shouldDownloadImageForURL:(NSURL *)imageURL;

- (UIImage *)imageManager:(CNImgManager *)imageManager transformDownloadedImage:(UIImage *)image withURL:(NSURL *)imageURL;
@end




@interface CNImgManager : NSObject
@property (weak, nonatomic) id <CNImgManagerDelegate> delegate;

@property (strong, nonatomic, readonly) CNImgCache *imgCache;
@property (strong, nonatomic, readonly) SDWebImageDownloader *imageDownloader;

+ (CNImgManager *)sharedManager;

- (NSString *)cacheKeyForURL:(NSURL *)url;


- (id <SDWebImageOperation>)downloadImageWithURL:(NSURL *)url
                                         options:(SDWebImageOptions)options
                                        progress:(SDWebImageDownloaderProgressBlock)progressBlock
                                       completed:(SDWebImageCompletionWithFinishedBlock)completedBlock;




@end
