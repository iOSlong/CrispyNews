//
//  CNDataLoad.m
//  TopNews
//
//  Created by xuewu.long on 16/9/26.
//  Copyright © 2016年 levt. All rights reserved.
//

#import "CNDataLoad.h"
#import "CNHttpRequest.h"
#import "CNApiManager.h"
#import <SSZipArchive/SSZipArchive.h>


@interface CNDataLoad ()<NSURLSessionDownloadDelegate,SSZipArchiveDelegate>
@property (nonatomic, strong) NSURLSessionDownloadTask *downloadTask;

@end


@implementation CNDataLoad{
    CNFreshInfo _fInfo;
}

+ (instancetype)shareDataLoad {
    static dispatch_once_t onceToken;
    static CNDataLoad *shareObj;
    dispatch_once(&onceToken, ^{
        shareObj = [[CNDataLoad alloc] init];
    });
    return shareObj;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _isLoading  = NO;
        _newsDetailArray  = [NSMutableArray array];
    }
    return self;
}


- (void)loadNewsZipFromChannel:(CNChannel *)channel {
    _channel = channel;
    if (channel == nil) {
        _channel = [CNChannel new];
        _channel.englishName = @"India";
    }
    NSString *downLoadUrl = [CNApiManager apiNewsZipDownload:_channel.englishName];
    NSLog(@"downLoadUrl = %@",downLoadUrl);
    NSURL *url = [NSURL URLWithString:@"http://120.25.226.186:32812/resources/videos/minion_02.mp4"];
    url = [NSURL URLWithString:@"http://difang.kaiwind.com/tianjin/kpydsy/201404/04/W020140404408118575474.jpg"];
    url = [NSURL URLWithString:downLoadUrl];
    
    [self downloadWithURl:url];
    _isLoading = YES;
}


- (NSArray*) allFilesAtPath:(NSString*) dirString {
    NSMutableArray* array = [NSMutableArray arrayWithCapacity:10];
    NSFileManager* fileMgr = [NSFileManager defaultManager];
    NSArray* tempArray = [fileMgr contentsOfDirectoryAtPath:dirString error:nil];
    for (NSString* fileName in tempArray) {
        BOOL flag = YES;
        NSString* fullPath = [dirString stringByAppendingPathComponent:fileName];
        if ([fileMgr fileExistsAtPath:fullPath isDirectory:&flag]) {
            if (!flag) {
                [array addObject:fullPath];
            }
        }
    }
    return array;
}

- (void)archiveZipFile {
    CNDataManager *_DM = [CNDataManager shareDataController];
    NSString *zipPath = [_DM pathOfNameSpace];
    
    NSString *desPath = [zipPath stringByAppendingPathComponent:@"unNews"];
    
    zipPath = [zipPath stringByAppendingPathComponent:@"news_Top.zip"];
    
    
    NSError *error;
    if ([SSZipArchive unzipFileAtPath:zipPath toDestination:desPath overwrite:YES password:nil error:&error delegate:self]) {
        NSLog(@"success");
        NSLog(@"unzipPath = %@",zipPath);
    }else {
        NSLog(@"%@",error);
    }
}

// TODO , 接口header  添加请求数据处理，
- (void)downloadWithURl:(NSURL *)url {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:NEWSLIST_DOWNLOAD_TIMEOUT];
    NSDictionary *header = [CNHttpRequest shareHttpRequest].requestHeader;
    [request.allHTTPHeaderFields setValuesForKeysWithDictionary:header];
    self.downloadTask = [session downloadTaskWithRequest:request];
    [self.downloadTask resume];
    
    if ([self.delegate respondsToSelector:@selector(loadNewsProgress:error:over:show:)]) {
        [self.delegate loadNewsProgress:0.01 error:nil over:NO show:nil];
    }
}
- (void)loadCancel;
{
    [self.downloadTask cancel];
    _isLoading = NO;
    if ([self.delegate respondsToSelector:@selector(loadNewsProgress:error:over:show:)]) {
        [self.delegate loadNewsProgress:0 error:nil over:NO show:nil];
    }
}

#pragma mark - DataManager
- (void)newslistJsonConfigure:(NSString *)json from:(NSString *)dirPath {
    NSArray *jsonList = [CNUtils jsonFromPath:dirPath jsonName:json];
    if(jsonList && jsonList.count){
        NSMutableArray<CNNews *> *newsArr = [NSMutableArray array];
        NSMutableArray<CNNewsDetail *> *newsDetailArr = [NSMutableArray array];
        NSTimeInterval timer = [[NSDate date] timeIntervalSince1970] * 1000;//整数毫秒级
        for (NSDictionary *dictNews in jsonList) {
            CNNews *news = [[CNNews alloc] init];
            [news yy_modelSetWithJSON:dictNews];
            timer --;
            news.timerLoc   = [NSNumber numberWithDouble:timer];
            news.readState  = @0;
            news.offline    = @1;
            news.channel    = self.channel.englishName;
            [newsArr addObject:news];
            
            CNNewsDetail *detail = [[CNNewsDetail alloc] init];
            [detail yy_modelSetWithJSON:dictNews];
            detail.channel      = self.channel.englishName;
            detail.offline      = @1;
            detail.contentPath  = [dirPath stringByAppendingPathComponent:news.ID];
            NSData  *resultData = [NSJSONSerialization dataWithJSONObject:dictNews options:NSJSONWritingPrettyPrinted error:nil];
            detail.result = resultData;
            [newsDetailArr addObject:detail];
        }
        
        /// 存储下载新闻列表及详情
        CNDataManager *_DM = [CNDataManager shareDataController];
        [_DM addNews:newsArr channel:self.channel.englishName type:CNDBTableTypeNewsChannel countLimit:YES];//新闻列表
        //新闻详情
        [_DM updateDetails:newsDetailArr type:CNDBTableTypeNewsDetail];
        

        /// 同步数据信息channel.finfo
        _newsArr    = newsArr;
        _fInfo      = self.channel.fInfo;
        _fInfo.showCount    += _newsArr.count;
        _fInfo.timerLocStar = [[_newsArr firstObject].timerLoc doubleValue];
        self.channel.fInfo  = _fInfo;
        
        _isLoading = NO;
        if ([self.delegate respondsToSelector:@selector(loadNewsProgress:error:over:show:)]) {
            [self.delegate loadNewsProgress:1 error:nil over:YES show:nil];
        }
    }
}


#pragma mark - SSZipArchive && DataBase
- (void)archiveZipFile:(NSString *)zfile {
    NSString *tarPath = [[CNUtils pathOfNameSpace] stringByAppendingPathComponent:zfile];
    NSString *desPath = [[CNUtils pathOfNameSpace] stringByAppendingPathComponent:@"tempArc"];
    // 1.解压文件
    NSError *error;
    BOOL unZip =  [SSZipArchive unzipFileAtPath:tarPath toDestination:desPath overwrite:NO password:nil error:&error delegate:self];
    if (unZip)
    {
        // 2.读取 配置 list.json文件数据,
        [self newslistJsonConfigure:@"list.json" from:desPath];
        
        [self filesCategoryToCachePathFromDir:desPath];
    }
    else
    {
        NSLog(@"unZipErrot = %@",error);
        _isLoading = NO;
        if ([self.delegate respondsToSelector:@selector(loadNewsProgress:error:over:show:)]) {
            [self.delegate loadNewsProgress:0 error:error over:YES show:MSG_DOWNLOAD_FAILD];
        }
    }
    // 5. 删除下载的zip压缩文件
    [[NSFileManager defaultManager] removeItemAtPath:tarPath error:nil];
}

//+ (BOOL)filesMoveDir:(NSString *)dirPath toDir:(NSString *)desDir;
- (BOOL)filesCategoryToCachePathFromDir:(NSString *)dirPath
{
    NSString *newslistPath      = [CNUtils pathOfImageList];
    NSString *newsDetailPath    = [CNUtils pathOfNewsDetail];
    NSFileManager* fileMgr      = [NSFileManager defaultManager];
    BOOL flag = YES;
    if ([fileMgr fileExistsAtPath:newslistPath isDirectory:&flag] == NO ||[fileMgr fileExistsAtPath:newsDetailPath isDirectory:&flag] == NO || [fileMgr fileExistsAtPath:dirPath isDirectory:&flag] == NO) {
        return NO;
    }
    
    dispatch_async(dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0), ^{
        NSArray *dirArr = [fileMgr contentsOfDirectoryAtPath:dirPath error:nil];
        for (NSString *fileName in dirArr)
        {
            NSString *fullPath  = [dirPath stringByAppendingPathComponent:fileName];
            NSString *newPath   = [newslistPath stringByAppendingPathComponent:fileName];
            if ([fullPath CNISImagePath])
            {
                NSString *imgCaheName = [NSString cachedFileNameForKey:[fileName URLDecoded]];
                newPath = [newslistPath stringByAppendingPathComponent:imgCaheName];
            }
            else if(fullPath.pathExtension.length == 0)
            {
                // 重新fullPath目录下的图片名
                if([CNUtils cnImgurlFilecodeInPath:fullPath]){
                    [CNUtils filesMoveDir:fullPath toDir:newsDetailPath];
                }
                continue;
            }
            if ([fileMgr fileExistsAtPath:newPath]){
                [fileMgr removeItemAtPath:newPath error:nil];
            }
            NSError *error;
            if([fileMgr moveItemAtPath:fullPath toPath:newPath error:&error] == NO){
                NSLog(@"%@",error);
            }
        }
        NSError *error;
        [fileMgr removeItemAtPath:dirPath error:&error];
        //        return YES;
    });
    return YES;
}



#pragma mark - NSURLSessionDelegate
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    NSLog(@"error = %@",error);
    _isLoading = NO;
    if (error ) {
        if ([self.delegate respondsToSelector:@selector(loadNewsProgress:error:over:show:)]) {
//            NSString *hintInfo = [error.userInfo objectForKey:@"NSLocalizedDescription"];
            [self.delegate loadNewsProgress:0 error:error over:YES show:MSG_DOWNLOAD_FAILD];
        }
    }
}
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location {
    // 获取下载文件缓存路径
    NSString *dfPath = [CNUtils pathOfNameSpace];
    
    // 下载文件名
    dfPath = [dfPath stringByAppendingPathComponent:downloadTask.response.suggestedFilename];
    
    // 转移下载临时文件覆盖至指定缓存路径
    if ([[NSFileManager defaultManager] fileExistsAtPath:dfPath]) {
        [[NSFileManager defaultManager] removeItemAtPath:dfPath error:nil];
    }
    NSError *error = nil;
    [[NSFileManager defaultManager] moveItemAtURL:location toURL:[NSURL fileURLWithPath:dfPath] error:&error];
    if (error) {
        NSLog(@"%@",error);
    }
    NSLog(@"path = %@",dfPath);
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    // 处理归档下载的文件
    [self archiveZipFile:downloadTask.response.suggestedFilename];
}

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite {
    CGFloat pro = 1.0 * totalBytesWritten / totalBytesExpectedToWrite;
    NSLog(@"-->%02f",1.0 * totalBytesWritten / totalBytesExpectedToWrite);
    if ([self.delegate respondsToSelector:@selector(loadNewsProgress:error:over:show:)]) {
        [self.delegate loadNewsProgress:pro>0.01 ? pro : 0.01 error:nil over:NO show:nil];
    }
}








// 解压
- (void)releaseZipFilesWithUnzipFileAtPath:(NSString *)zipPath Destination:(NSString *)unzipPath{
    NSError *error;
    if ([SSZipArchive unzipFileAtPath:zipPath toDestination:unzipPath overwrite:YES password:nil error:&error delegate:self]) {
        NSLog(@"success");
        NSLog(@"unzipPath = %@",unzipPath);
    }else {
        NSLog(@"%@",error);
    }
}
- (void)zipArchiveWillUnzipArchiveAtPath:(NSString *)path zipInfo:(unz_global_info)zipInfo;{
    NSLog(@"%@",path);
}
- (void)zipArchiveDidUnzipArchiveAtPath:(NSString *)path zipInfo:(unz_global_info)zipInfo unzippedPath:(NSString *)unzippedPath;{
    NSLog(@"%@",path);

}




@end
