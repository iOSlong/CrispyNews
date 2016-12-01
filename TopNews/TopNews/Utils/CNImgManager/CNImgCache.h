//
//  CNImgCache.h
//  TopNews
//
//  Created by xuewu.long on 16/10/30.
//  Copyright © 2016年 levt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SDWebImage/SDImageCache.h>

@interface CNImgCache : NSObject

@property (assign, nonatomic) BOOL shouldDecompressImages;


@property (assign, nonatomic) BOOL shouldDisableiCloud;


@property (assign, nonatomic) NSInteger maxCacheAge;


@property (assign, nonatomic) NSUInteger maxCacheSize;

+ (CNImgCache *)shareImgCache;

- (NSString *)diskCachePath;
- (NSString *)pathOfNameSpace;

- (id)initWithNamespace:(NSString *)ns;

- (id)initWithNamespace:(NSString *)ns diskCacheDirectory:(NSString *)directory;

-(NSString *)makeDiskCachePath:(NSString*)fullNamespace;

- (NSOperation *)queryDiskCacheForKey:(NSString *)key done:(SDWebImageQueryCompletedBlock)doneBlock;



- (NSString *)cachePathForKey:(NSString *)key inPath:(NSString *)path;


- (NSString *)defaultCachePathForKey:(NSString *)key;

- (void)storeImage:(UIImage *)image recalculateFromImage:(BOOL)recalculate imageData:(NSData *)imageData forKey:(NSString *)key toDisk:(BOOL)toDisk;

- (void)clearDiskOnCompletion:(SDWebImageNoParamsBlock)completion;

- (void)clearDisk;

- (void)cleanDiskWithCompletionBlock:(SDWebImageNoParamsBlock)completionBlock;




@end
