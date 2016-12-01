//
//  CNImgDownloader.m
//  TopNews
//
//  Created by xuewu.long on 16/11/3.
//  Copyright © 2016年 levt. All rights reserved.
//

#import "CNImgDownloader.h"
#import "CNImgCache.h"

static NSData *kPNGData = nil;

BOOL ImgHasPNGPreffix(NSData *data);

BOOL ImgHasPNGPreffix(NSData *data) {
    NSUInteger pngSignatureLength = [kPNGData length];
    if ([data length] >= pngSignatureLength) {
        if ([[data subdataWithRange:NSMakeRange(0, pngSignatureLength)] isEqualToData:kPNGData]) {
            return YES;
        }
    }
    
    return NO;
}




@implementation CNImgDownloader

+ (id<SDWebImageOperation>)downLoadFromUrl:(NSURL *)url completed:(SDWebImageDownloaderCompletedBlock)completedBlock storePath:(NSString *)cachePath;{
    return [CNImgDownloader downLoadFromUrl:url options:SDWebImageDownloaderLowPriority progress:nil completed:completedBlock storePath:cachePath];
}

+ (id<SDWebImageOperation>)downLoadFromUrl:(NSURL *)url completed:(SDWebImageDownloaderCompletedBlock)completedBlock;
{
    return [CNImgDownloader downLoadFromUrl:url options:SDWebImageDownloaderLowPriority progress:nil completed:completedBlock storePath:[CNUtils pathOfNewsDetail]];
}

+ (id<SDWebImageOperation>)downLoadFromUrl:(NSURL *)url storePath:(NSString *)cachePath;{
    return [CNImgDownloader downLoadFromUrl:url completed:nil storePath:cachePath];
}

+ (id<SDWebImageOperation>)downLoadFromUrl:(NSURL *)url;{
    return [CNImgDownloader downLoadFromUrl:url storePath:[CNUtils pathOfNewsDetail]];
}


+ (id<SDWebImageOperation>)downLoadFromUrl:(NSURL *)url options:(SDWebImageDownloaderOptions)options progress:(SDWebImageDownloaderProgressBlock)progressBlock completed:(SDWebImageDownloaderCompletedBlock)completedBlock storePath:(NSString *)cachePath {
    
    if ([url isKindOfClass:NSString.class]) {
        url = [NSURL URLWithString:(NSString *)url];
    }
    if (![url isKindOfClass:NSURL.class]) {
        url = nil;
    }
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL flag;
    //    UIImage *image, NSData *data, NSError *error, BOOL finished
    if ([fileManager fileExistsAtPath:cachePath isDirectory:&flag]) {
        if (!flag) {
            if (completedBlock != nil) {
                completedBlock(nil, nil, [[NSError alloc] initWithDomain:@"noPath" code:0 userInfo:@{@"info":@"cachePath is not a directory"}], NO);
            }
            return nil;
        }
    }else{
        NSError *error;
        [[NSFileManager defaultManager] createDirectoryAtPath:cachePath withIntermediateDirectories:YES attributes:nil error:&error];
        if (error) {
            if (completedBlock != nil) {
                completedBlock(nil, nil, error, NO);
            }
            return nil;
        }
    }
    if (url == nil) {
        if (completedBlock != nil) {
            completedBlock(nil, nil, [[NSError alloc] initWithDomain:@"noPath" code:0 userInfo:@{@"info":@"url is invalid"}], NO);
        }
        return nil;
    }
    // TODO 如果已经下载到了磁盘，就不需要在下载啦
    
    NSString *decodeURL = [NSString cachedFileNameForKey:url.absoluteString];
    if([CNUtils file:decodeURL existsAtDirectory:[CNUtils pathOfNewsDetail]]){
        NSLog(@"decodeUrl = %@",decodeURL);
        return nil;
    }

    return  [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:url options:options progress:progressBlock completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
        
        dispatch_async(dispatch_queue_create([CACHE_DISK_IMAGELIST cStringUsingEncoding:NSUTF8StringEncoding], DISPATCH_QUEUE_SERIAL), ^{
            NSData *imagedata = data;
            if (image && !imagedata) {
#if TARGET_OS_IPHONE
                int alphaInfo = CGImageGetAlphaInfo(image.CGImage);
                BOOL hasAlpha = !(alphaInfo == kCGImageAlphaNone ||
                                  alphaInfo == kCGImageAlphaNoneSkipFirst ||
                                  alphaInfo == kCGImageAlphaNoneSkipLast);
                BOOL imageIsPng = hasAlpha;
                
                // But if we have an image data, we will look at the preffix
                if ([data length] >= [kPNGData length]) {
                    imageIsPng = ImgHasPNGPreffix(data);
                }
                
                if (imageIsPng) {
                    imagedata = UIImagePNGRepresentation(image);
                }
                else {
                    imagedata = UIImageJPEGRepresentation(image, (CGFloat)1.0);
                }
#else
                imagedata = [NSBitmapImageRep representationOfImageRepsInArray:image.representations usingType: NSJPEGFileType properties:nil];
#endif
            }
            
            [CNImgDownloader storeImageDataToDisk:imagedata forKey:url.absoluteString atPath:cachePath];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if (completedBlock != nil) {
                    completedBlock(image, data, error, finished);
                }
            });
        });
    }];
}

+ (void)storeImageDataToDisk:(NSData *)imageData forKey:(NSString *)key atPath:(NSString *)dicPath {
    
    if (!imageData) {
        return;
    }
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if (![fileManager fileExistsAtPath:dicPath]) {
        [fileManager createDirectoryAtPath:dicPath withIntermediateDirectories:YES attributes:nil error:NULL];
    }
    
    // get cache Path for image key
    NSString *cachePathForKey = [[CNImgCache shareImgCache] cachePathForKey:key inPath:dicPath];
    // transform to NSUrl
    NSURL *fileURL = [NSURL fileURLWithPath:cachePathForKey];
    
    BOOL success = [fileManager createFileAtPath:cachePathForKey contents:imageData attributes:nil];
    if (success == NO) {
        NSLog(@"fail to createFileAtPath:%@",cachePathForKey);
    }
    
    // disable iCloud backup
    [fileURL setResourceValue:[NSNumber numberWithBool:YES] forKey:NSURLIsExcludedFromBackupKey error:nil];
}


@end
