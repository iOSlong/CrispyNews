//
//  CNImgDownloader.h
//  TopNews
//
//  Created by xuewu.long on 16/11/3.
//  Copyright © 2016年 levt. All rights reserved.
//

#import <SDWebImage/SDWebImageDownloader.h>

@interface CNImgDownloader : SDWebImageDownloader

+ (id <SDWebImageOperation>)downLoadFromUrl:(NSURL *)url
                                    options:(SDWebImageDownloaderOptions)options
                                   progress:(SDWebImageDownloaderProgressBlock)progressBlock
                                  completed:(SDWebImageDownloaderCompletedBlock)completedBlock
                                  storePath:(NSString *)cachePath;


+ (id<SDWebImageOperation>)downLoadFromUrl:(NSURL *)url completed:(SDWebImageDownloaderCompletedBlock)completedBlock storePath:(NSString *)cachePath;

+ (id<SDWebImageOperation>)downLoadFromUrl:(NSURL *)url completed:(SDWebImageDownloaderCompletedBlock)completedBlock;

+ (id<SDWebImageOperation>)downLoadFromUrl:(NSURL *)url storePath:(NSString *)cachePath;

+ (id<SDWebImageOperation>)downLoadFromUrl:(NSURL *)url;




@end
