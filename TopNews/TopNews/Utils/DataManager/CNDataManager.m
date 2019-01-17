//
//  CNDataManager.m
//  CrispyNews
//
//  Created by xuewu.long on 16/8/3.
//  Copyright © 2016年 letv. All rights reserved.
//

#import "CNDataManager.h"
#import "CNImgCache.h"

@interface CNDataManager ()

@end

@implementation CNDataManager


#pragma mark - Defult DataStore

+ (NSArray<CNChannel *> *)defultChannels {
    NSDictionary *channelPlist = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"channel" ofType:@"plist"]];
    NSArray *defultChannel = [channelPlist objectForKey:@"Defult"];
    
    NSMutableArray *channelArr = [NSMutableArray array];
    for (int i = 0; i < defultChannel.count; i ++ ) {
        CNChannel *channel = [CNChannel new];
        channel.englishName = defultChannel[i];
        channel.sortLoc = [NSNumber numberWithInteger:i];
        channel.ID = [NSString stringWithFormat:@"%d",i];
        //if(i <= 6)  // 默认设置6个频道
        channel.channelState = @1;
        [channelArr addObject:channel];
    }
    return channelArr;
}

+ (instancetype)shareDataController
{
    static CNDataManager *shareOBJ;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareOBJ = [[CNDataManager alloc] init];
    });
    return shareOBJ;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        /// do some suffix
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        self.userId = [defaults valueForKey:cn_USER_DEFAULT_KEY_UUID];
        // set user id.
        if(!self.userId){
            self.userId = @"tmpUserUUID";
        }
        
        [self mkdirOfCrispyNewsDB];
        
        [self createTable];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notiForLoadDetailSource:) name:NOTI_SOURCE_DETAIL_NEEDLOAD object:nil];

    }
    return self;
}
- (void)notiForLoadDetailSource:(NSNotification *)noti {
    [self mkdirOfCrispyNewsDB];
}


- (NSString *)pathOfDatabase {
    static NSString *dbPath = nil;
    if (nil == dbPath) {
        dbPath =  [[self pathOfNameSpace] stringByAppendingPathComponent:CACHE_DISK_DATABASE];
    }
    return dbPath;
}
- (NSString *)pathOfNewsDetail {
    static NSString *ndPath = nil;
    if (nil == ndPath) {
        ndPath = [[self pathOfNameSpace] stringByAppendingPathComponent:CACHE_DISK_NEWSDETAIL];
    }
    return ndPath;
}
- (NSString *)pathOfNameSpace {
    static NSString *nsPath = nil;
    if (nil == nsPath) {
        nsPath = [[CNImgCache shareImgCache] pathOfNameSpace];
    }
    return nsPath;
}

- (NSString *)pathOfDiskCache {
    return [[CNImgCache shareImgCache] diskCachePath];
}

- (void)mkdirOfCrispyNewsDB {
    NSString *dataPath      = [self pathOfDatabase];
    NSString *detailPath    = [self pathOfNewsDetail];
    NSLog(@"==========================================detailPath:\n %@",detailPath);
    if (![[NSFileManager defaultManager] fileExistsAtPath:dataPath]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:dataPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:detailPath]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:detailPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    // 将bundlePath中的html模板文件移动到下载资源文件中
    [self copyNetSourcesForCachePath:detailPath];

}



- (void)copyNetSourcesForCachePath:(NSString *)cachePath {
    if (!cachePath) {
        cachePath = [self pathOfNewsDetail];
    }
    NSString *fileJS    = [[NSBundle mainBundle] pathForResource:DEV_MODELH5 ofType:@"js"];
    NSString *fileCSS   = [[NSBundle mainBundle] pathForResource:DEV_MODELH5 ofType:@"css"];
    NSString *fileHTML  = [[NSBundle mainBundle] pathForResource:DEV_MODELH5 ofType:@"html"];
    NSString *iscroll_liteJS    = [[NSBundle mainBundle] pathForResource:@"iscroll_lite.mini" ofType:@"js"];
    
    NSString *placeholderIMG = [[NSBundle mainBundle] pathForResource:@"690x328-1@1x" ofType:@"png"];
    
    
    
    NSError *error = nil;
    NSString *cacheDetailJS     = [cachePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.js",DEV_MODELH5]];
    NSString *cacheDetailCSS    = [cachePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.css",DEV_MODELH5]];
    NSString *cacheDetailHTML   = [cachePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.html",DEV_MODELH5]];
    NSString *cachePlaceholderIMG   = [cachePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",DEV_PLACEHOLDERIMG]];
    
    
    [[NSFileManager defaultManager] removeItemAtPath:cacheDetailJS error:&error];
    [[NSFileManager defaultManager] removeItemAtPath:cacheDetailCSS error:&error];
    [[NSFileManager defaultManager] removeItemAtPath:cacheDetailHTML error:&error];
    [[NSFileManager defaultManager] removeItemAtPath:cachePlaceholderIMG error:&error];

    
    [[NSFileManager defaultManager] copyItemAtPath:fileJS toPath:cacheDetailJS error:&error];
    [[NSFileManager defaultManager] copyItemAtPath:fileCSS toPath:cacheDetailCSS error:&error];
    [[NSFileManager defaultManager] copyItemAtPath:fileHTML toPath:cacheDetailHTML error:&error];
    [[NSFileManager defaultManager] copyItemAtPath:placeholderIMG toPath:cachePlaceholderIMG error:&error];
    
    
    [[NSFileManager defaultManager] copyItemAtPath:iscroll_liteJS toPath:[cachePath stringByAppendingPathComponent:@"iscroll_lite.mini.js"] error:nil];
    
    
    NSError *errorR = nil;
    NSArray *arr = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:[[NSBundle mainBundle] bundlePath] error:&errorR];
    NSMutableArray *muArr = [NSMutableArray array];
    for (NSString *jpgFile in arr) {
        if ([jpgFile hasSuffix:@".jpg"]) {
            [muArr addObject:jpgFile];
            NSString *fileJPG    = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:jpgFile];
            [[NSFileManager defaultManager] copyItemAtPath:fileJPG toPath:[cachePath stringByAppendingPathComponent:jpgFile] error:&errorR];
            if (errorR) {
                NSLog(@"%@",errorR);
            }
        }
    }
    
}

+ (NSString *)sqlCreateFormatTable:(NSString *)table class:(Class)cls;
{
    NSString *sqlFormat =  [cls stringForSQLFormat];
    NSString *sqlStr = [NSString stringWithFormat:@"create table if not exists %@ (order_id integer primary key autoincrement,%@)",table,sqlFormat];
    return sqlStr;
}

/// 创建表格
- (void)createTable {
    
    NSString *dbPath = [self pathOfDatabase];
    NSString *sqlitePath = [dbPath stringByAppendingPathComponent:k_DB_FILE_NAME];
    self.fmdb = [FMDatabase databaseWithPath:sqlitePath];
    
    if (![self.fmdb open]) {
        NSLog(@"could not open db");
    }
    else {
        if (![_fmdb tableExists:k_TABLE_NAME_CHANNEL]) {
            BOOL success = [_fmdb executeUpdate:k_SQL_CREATE_TABLE_CHANNEL];
            NSLog(@"create table %@ , %@",k_TABLE_NAME_CHANNEL,(success ? @"success！": @"fail！"));
        }
        
        
        if (![_fmdb tableExists:tableNewsChannel]) {
            BOOL success = [_fmdb executeUpdate:SQL_CREATETABLE_NEWS_CHANNEL];
            NSLog(@"create table %@ , %@",tableNewsChannel,(success ? @"success！": @"fail！"));
        }
        if (![_fmdb tableExists:tableNewsFaves]) {
            BOOL success = [_fmdb executeUpdate:SQL_CREATETABLE_NEWS_FAVES];
            NSLog(@"create table %@ , %@",tableNewsFaves,(success ? @"success！": @"fail！"));
        }
        if (![_fmdb tableExists:tableNewsDetail]) {
            BOOL success = [_fmdb executeUpdate:SQL_CREATETABLE_NEWS_DETAIL];
            NSLog(@"create table %@ , %@",tableNewsDetail,(success ? @"success！": @"fail！"));
        }
        [self.fmdb close];
    }
}

extern int poolNewsMax(){
    return 300;
}


#pragma mark - DB insert & delete & modify & query
#pragma mark -

#pragma mark Channel About
- (void)insertChannel:(CNChannel *)channel {
    if (!channel) {
        return;
    }
    if (![_fmdb open]) {
        NSLog(@"could not open db");
    }
    else
    {
        BOOL delState = [_fmdb executeUpdate:k_SQL_DELETE_CHANNEL_FORMAT, channel.ID];
        if (delState) {
            NSLog(@"原有数据被删除！");
        }
        
        BOOL success = [_fmdb executeUpdate:k_SQL_INSERT_CHANNEL_FORMAT, channel.ID,channel.channelState,channel.sortLoc,channel.chinaName,channel.englishName,channel.createBy,channel.createTime,channel.modiyBy,channel.modiyTime,self.userId];
        
        if (success) {
            //            NSLog(@"success insert channel %@",channel);
        }else{
            //            NSLog(@"failed insert channel %@",channel);
        }
        [_fmdb close];
    }
}

- (void)addChannels:(NSArray<CNChannel *> *)channels {
    if (!channels || !channels.count) {
        return;
    }
    if (![_fmdb open]) {
        NSLog(@"could not open db");
    }
    else
    {
        [_fmdb beginTransaction];
        @try {
            for (NSInteger i = 0; i < channels.count; i++) {
                CNChannel *channel = channels[i];
                BOOL success = [_fmdb executeUpdate:k_SQL_INSERT_CHANNEL_FORMAT, channel.ID, channel.channelState,channel.sortLoc,channel.chinaName,channel.englishName,channel.createBy,channel.createTime,channel.modiyBy,channel.modiyTime,self.userId];
                if (success) {
                    //                    NSLog(@"success insert channel %@",channel);
                }else{
                    NSLog(@"failed insert channel %@",channel);
                }
            }
        } @catch (NSException *exception) {
            NSLog(@"batch add channel list exception :%@",[exception reason]);
            [_fmdb rollback];
        } @finally {
            [_fmdb commit];
            [_fmdb close];
        }
    }
}

- (void)deleteChannelByID:(NSString *)channelID {
    if (!channelID ) {
        return;
    }
    if (![_fmdb open]) {
        NSLog(@"could not open db");
    }
    else
    {
        BOOL success = [_fmdb executeUpdate:k_SQL_DELETE_CHANNEL_FORMAT, channelID];
        if (success) {
            NSLog(@"success delete channel ID with:%@",channelID);
        }else{
            NSLog(@"failed delete channel ID with:%@",channelID);
        }
        [_fmdb close];
    }
}


- (void)clearChannel_StateOn:(BOOL)stateON;
{
    if (![_fmdb open]) {
        NSLog(@"could not open db");
    }
    else
    {
        NSString *excuteSQL = k_SQL_CLEAR_STATEONCHANNEL_FORMAT;
        if (stateON == NO) {
            excuteSQL = k_SQL_CLEAR_STATEOFFCHANNEL_FORMAT;
        }
        BOOL success = [_fmdb executeUpdate:excuteSQL];
        if (success) {
            NSLog(@"delete from channel_list successful");
        }else{
            NSLog(@"failed clear channel_list.");
        }
        [_fmdb close];
    }
}

- (void)clearChannelList {
    if (![_fmdb open]) {
        NSLog(@"could not open db");
    }
    else
    {
        BOOL success = [_fmdb executeUpdate:k_SQL_CLEAR_CHANNEL_LIST_FORMAT];
        if (success) {
            NSLog(@"delete from channel_list successful");
        }else{
            NSLog(@"failed clear channel_list.");
        }
        [_fmdb close];
    }
}


- (NSArray<CNChannel *> *)getChannelAllByASC:(BOOL)isASC {
    FMResultSet *rs;
    NSMutableArray *rArr = [NSMutableArray array];
    if (![_fmdb open]) {
        NSLog(@"could not open db");
    }
    else
    {
        if (isASC) {
            rs = [_fmdb executeQuery:k_SQL_QUERY_CHANNEL_ASC_LISTALL_FORMAT];
        }
        else{
            rs = [_fmdb executeQuery:k_SQL_QUERY_CHANNEL_DESC_LISTALL_FORMAT];
        }
        while ([rs next]) {
            NSDictionary *rsEDict = [rs resultDictionary];
            CNChannel *channel = [CNChannel new];
            [channel yy_modelSetWithJSON:rsEDict];
            [rArr addObject:channel];
        }
        [_fmdb close];
    }
    return rArr;
}
- (NSArray<CNChannel *> *)getChannelAllByASC_StateOn:(BOOL)stateON {
    FMResultSet *rs;
    NSMutableArray *rArr = [NSMutableArray array];
    if (![_fmdb open]) {
        NSLog(@"could not open db");
    }
    else
    {
        if (stateON) {
            rs = [_fmdb executeQuery:k_SQL_QUERY_CHANNEL_ASC_STATE_ON_LISTALL_FORMAT];
        }
        else{
            rs = [_fmdb executeQuery:k_SQL_QUERY_CHANNEL_DESC_STATEON_ON_LISTALL_FORMAT];
        }
        while ([rs next]) {
            NSDictionary *rsEDict = [rs resultDictionary];
            CNChannel *channel = [CNChannel new];
            [channel yy_modelSetWithJSON:rsEDict];
            [rArr addObject:channel];
        }
        [_fmdb close];
    }
    return rArr;
}


#pragma mark News About
- (void)insertNews:(CNNews *)news channel:(NSString *)channel type:(CNDBTableType)type;
{
    if (!news || !channel || channel.length == 0) {
        return;
    }
    [news cnModelToJSONData];

    if (![_fmdb open]) {
        NSLog(@"could not open db");
    }
    else
    {
        static NSString *delSql = nil;
        static NSString *updateSql = nil;
        if (type == CNDBTableTypeNewsChannel) {
            delSql      = SQL_DELETE_NEWSCHANNEL_FORMAT;
            updateSql   = SQL_INSERT_NEWS_CHANNEL_FORMAT;
        }else if (type == CNDBTableTypeNewsFaves) {
            delSql      = SQL_DELETE_NEWSFAVES_FORMAT;
            updateSql   = SQL_INSERT_NEWS_FAVES_FORMAT;
        }
        
        BOOL delState = [_fmdb executeUpdate:delSql, news.ID];
        NSLog(@"deleteState: %d newsID = %@ channel = %@ %@",delState, news.ID,channel,delSql);
        
        if (type == CNDBTableTypeNewsChannel || type == CNDBTableTypeNewsFaves) {
            BOOL suc = [_fmdb executeUpdate:updateSql,news.ID, news.channel, news.timerLoc, news.data];
            NSLog(@"update %d insert newsID: %@ (%@)",suc,news.ID,updateSql);
        }
        [_fmdb close];
    }
}

- (void)addNews:(NSArray <CNNews *> *)newsList channel:(NSString *)channel type:(CNDBTableType)type;
{
    if (!newsList || !newsList.count) {
        return;
    }
    if (![_fmdb open]) {
        NSLog(@"could not open db");
    }
    else
    {
        static NSString *delSql = nil;
        static NSString *updateSql = nil;
        if (type == CNDBTableTypeNewsChannel) {
            delSql      = SQL_DELETE_NEWSCHANNEL_FORMAT;
            updateSql   = SQL_INSERT_NEWS_CHANNEL_FORMAT;
        }else if (type == CNDBTableTypeNewsFaves) {
            delSql      = SQL_DELETE_NEWSFAVES_FORMAT;
            updateSql   = SQL_INSERT_NEWS_FAVES_FORMAT;
        }
        
        
        [_fmdb beginTransaction];
        @try {
            for (int i = 0; i < newsList.count; i++) {
                CNNews *news = newsList[i];
                [news cnModelToJSONData];
                
                BOOL delState = [_fmdb executeUpdate:delSql, news.ID];
                NSLog(@"delete %d newsID = %@ channel = %@ %@",delState, news.ID,channel,delSql);
                
                BOOL suc = [_fmdb executeUpdate:updateSql,news.ID, channel ? channel:@"", news.timerLoc, news.data];
                NSLog(@"update %d insert newsID:%@ (%@)",suc,news.ID,updateSql);
            }
        } @catch (NSException *exception) {
            NSLog(@"batch add new list exception :%@",[exception reason]);
            [_fmdb rollback];
        } @finally {
            [_fmdb commit];
            [_fmdb close];
        }
    }
}

- (void)addNews:(NSArray <CNNews *> *)newsList channel:(NSString *)channel type:(CNDBTableType)type countLimit:(BOOL)limit;
{
    if (!newsList || !newsList.count || !channel || channel.length == 0) {
        return;
    }
    if (![_fmdb open]) {
        NSLog(@"could not open db");
    }
    else
    {
        static NSString *delSql     = nil;
        static NSString *updateSql  = nil;
        static NSString *tableName  = nil;
        
        if (type == CNDBTableTypeNewsChannel) {
            delSql      = SQL_DELETE_NEWSCHANNEL_FORMAT;
            updateSql   = SQL_INSERT_NEWS_CHANNEL_FORMAT;
            tableName   = tableNewsChannel;
        }else if (type == CNDBTableTypeNewsFaves) {
            delSql      = SQL_DELETE_NEWSFAVES_FORMAT;
            updateSql   = SQL_INSERT_NEWS_FAVES_FORMAT;
            tableName   = tableNewsFaves;
        }

        // 1.  将newsList 添加到news_list表中
        [_fmdb beginTransaction];
        @try {
            for (int i = 0; i < newsList.count; i++) {
                CNNews *news = newsList[i];
                [news cnModelToJSONData];
                
                BOOL delState = [_fmdb executeUpdate:delSql, news.ID];
                NSLog(@"delete %d newsID = %@ channel = %@ %@",delState, news.ID,channel,delSql);
                
                if (type == CNDBTableTypeNewsChannel || type == CNDBTableTypeNewsFaves) {
                    BOOL suc = [_fmdb executeUpdate:updateSql,news.ID, news.channel, news.timerLoc, news.data];
                    NSLog(@"update %d insert newsID:%@ (%@)",suc,news.ID,updateSql);
                }
            }
            
            if (limit == YES)
            {
                ///2 计算channel->news 数目
                FMResultSet *rs;
                int  newsCount = 0;
                NSString *sqlStr = [NSString stringWithFormat:@"select count(*) as num from %@ where channel = ?",tableName];
                rs = [_fmdb executeQuery:sqlStr, channel];
                while ([rs next]) {
                    NSDictionary *rsEDict = [rs resultDictionary];
                    NSLog(@"rsEDict %@",rsEDict);
                    if (rsEDict) {
                        newsCount =  [[rsEDict objectForKey:@"num"] intValue];
                    }
                }
                
                // 判断 是否需要进行删除操作
                if (newsCount > poolNewsMax())
                {
                    sqlStr = [NSString stringWithFormat:@"select timerLoc from %@ where channel = ? order by timerLoc desc",tableName];
                    rs = [_fmdb executeQuery:sqlStr, channel];
                    NSTimeInterval delTimer = 0;
                    while ([rs next]) {
                        delTimer ++;
                        if (delTimer == poolNewsMax()) {
                            NSDictionary *rsEDict = [rs resultDictionary];
                            NSLog(@"rsEDict %@",rsEDict);
                            if (rsEDict) {
                                delTimer =  [[rsEDict objectForKey:@"timerLoc"] doubleValue];
                                break;
                            }
                        }
                    }
                    
                    // 执行删除操作(根据timerLoc 的大小)
                    if (delTimer > poolNewsMax())
                    {
                        sqlStr = [NSString stringWithFormat:@"delete from %@ where channel = ? and timerLoc < %.2f",tableName,delTimer];
                        BOOL delState = [_fmdb executeUpdate:sqlStr,channel];
                        if (delState) {
                            NSLog(@"> poolNewsMax 删除成功");
                        }else{
                            NSLog(@"> poolNewsMax 删除失败");
                        }
                    }
                }
            }
        } @catch (NSException *exception) {
            NSLog(@"batch add new list exception :%@",[exception reason]);
            [_fmdb rollback];
        } @finally {
            [_fmdb commit];
        }
    }
}

- (void)deleteNewsList:(NSArray<NSString *> *)newsIdList type:(CNDBTableType)type;
{
    if (newsIdList==nil || newsIdList.count == 0) {
        return;
    }
    if (![_fmdb open]) {
        NSLog(@"could not open db");
    }
    else
    {
        static NSString *sqlStr = nil;
        if (type == CNDBTableTypeNewsChannel) {
            sqlStr      = SQL_DELETE_NEWSCHANNEL_FORMAT;
        }else if (type == CNDBTableTypeNewsFaves) {
            sqlStr      = SQL_DELETE_NEWSFAVES_FORMAT;
        }
        
        [_fmdb beginTransaction];
        @try {
            for (int i = 0; i < newsIdList.count; i++) {
                NSString *newsId  = newsIdList[i];
                BOOL delState = [_fmdb executeUpdate:sqlStr, newsId];
                NSLog(@"%@  delete %d newsID = %@", sqlStr, delState, newsId);
            }
        } @catch (NSException *exception) {
            NSLog(@"batch add new list exception :%@",[exception reason]);
            [_fmdb rollback];
        } @finally {
            [_fmdb commit];
            [_fmdb close];
        }
    }
}



- (void)deleteNews:(CNNews *)news type:(CNDBTableType)type;
{
    if (![_fmdb open]) {
        NSLog(@"could not open db");
    }
    else
    {
        static NSString *sqlStr = nil;
        if (type == CNDBTableTypeNewsChannel) {
            sqlStr      = SQL_DELETE_NEWSCHANNEL_FORMAT;
        }else if (type == CNDBTableTypeNewsFaves) {
            sqlStr      = SQL_DELETE_NEWSFAVES_FORMAT;
        }
        BOOL delState = [_fmdb executeUpdate:sqlStr, news.ID];
        NSLog(@"%@  delete %d newsID = %@", sqlStr, delState, news.ID);
        
        [_fmdb close];
    }
}
- (void)deleteNewsByChannel:(NSString *)channel type:(CNDBTableType)type;
{
    if (!channel || channel.length == 0) {
        return;
    }
    if (![_fmdb open]) {
        NSLog(@"could not open db");
    }
    else
    {
        static NSString *sqlStr = nil;
        if (type == CNDBTableTypeNewsChannel) {
            sqlStr      = SQL_DELETE_NEWSCHANNEL_BYCHANNEL_FORMAT;
        }else if (type == CNDBTableTypeNewsFaves) {
            sqlStr      = SQL_DELETE_NEWSFAVES_BYCHANNEL_FORMAT;
        }
        BOOL delState = [_fmdb executeUpdate:sqlStr,channel];
        NSLog(@"%@  delete %d channel = %@", sqlStr, delState, channel);
        
        [_fmdb close];
    }
}


- (void)clearNewsListBy:(CNDBTableType)type;
{
    if (![_fmdb open]) {
        NSLog(@"could not open db");
    }
    else
    {
        static NSString *sqlStr = nil;
        if (type == CNDBTableTypeNewsChannel) {
            sqlStr      = SQL_CLEAR_NEWSCHANNEL_LIST;
        }else if (type == CNDBTableTypeNewsFaves) {
            sqlStr      = SQL_CLEAR_NEWSFAVES_LIST;
        }
        BOOL delState = [_fmdb executeUpdate:sqlStr];
        NSLog(@"%@  delete %d ", sqlStr, delState);
        [_fmdb close];
    }
}


- (NSArray <CNNews *> *)getNewsByChannel:(NSString *)channel limit:(NSInteger)limit size:(NSInteger)size type:(CNDBTableType)type;
{
    FMResultSet *rs;
    NSMutableArray *rArr = [NSMutableArray array];
    if (![_fmdb open]) {
        NSLog(@"could not open db");
    }
    else
    {
        static NSString *sqlStr = nil;
        if (type == CNDBTableTypeNewsChannel)
        {
            sqlStr = [NSString stringWithFormat:@"select * from %@ where channel = ? order by timerLoc desc limit %ld, %ld",tableNewsChannel,limit,size];
            if (size == 0) {
                sqlStr = [NSString stringWithFormat:@"select * from %@ where channel = ? order by timerLoc desc",tableNewsChannel];
            }
            rs = [_fmdb executeQuery:sqlStr, channel];
        }
        else if (type == CNDBTableTypeNewsFaves)
        {
            if (TextValid(channel)) {
                sqlStr = [NSString stringWithFormat:@"select * from %@ where channel = ? order by timerLoc desc limit %ld, %ld",tableNewsFaves,limit,size];
                if (size == 0) {
                    sqlStr = [NSString stringWithFormat:@"select * from %@ where channel = ? order by timerLoc desc",tableNewsFaves];
                }
            }else{
                sqlStr = [NSString stringWithFormat:@"select * from %@ order by timerLoc desc limit %ld, %ld",tableNewsFaves,limit,size];
                if (size == 0) {
                    sqlStr = [NSString stringWithFormat:@"select * from %@ order by timerLoc desc",tableNewsFaves];
                }
            }
            rs = [_fmdb executeQuery:sqlStr, channel];
        }
        
        
        
        while ([rs next]) {
            NSDictionary *rsEDict = [rs resultDictionary];
            CNNews * news = [CNNews new];
            [news yy_modelSetWithJSON:rsEDict];
            if (type == CNDBTableTypeNewsFaves || type == CNDBTableTypeNewsChannel) {
                id data = [rsEDict objectForKey:@"data"];
                if (data && data != [NSNull null]){
                    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                    [news yy_modelSetWithJSON:json];
                }
            }
            [rArr addObject:news];
        }
        [_fmdb close];
    }
    return rArr;
}

- (NSInteger)getNewsCountFromChannel:(NSString *)channel type:(CNDBTableType)type;
{
    FMResultSet *rs;
    NSInteger  newsCount = 0;
    if (![_fmdb open]) {
        NSLog(@"could not open db");
    }
    else{
        ///2 计算channel->news 数目
        static NSString *tableName  = nil;
        if (type == CNDBTableTypeNewsChannel) {
            tableName   = tableNewsChannel;
        }else if (type == CNDBTableTypeNewsFaves) {
            tableName   = tableNewsFaves;
        }
        if (channel && channel.length) {
            NSString *sqlStr = [NSString stringWithFormat:@"select count(*) as num from %@ where channel = ?",tableName];
            rs = [_fmdb executeQuery:sqlStr, channel];
        }else{
            NSString *sqlStr = [NSString stringWithFormat:@"select count(*) as num from %@",tableName];
            rs = [_fmdb executeQuery:sqlStr];
        }
        while ([rs next]) {
            NSDictionary *rsEDict = [rs resultDictionary];
            NSLog(@"rsEDict %@",rsEDict);
            if (rsEDict) {
                newsCount =  [[rsEDict objectForKey:@"num"] integerValue];
            }
        }
        
        [_fmdb close];
    }
    return newsCount;
}

#pragma mark NewsDetail About
- (void)insertNewsDetail:(CNNewsDetail *)detail type:(CNDBTableType)type {
    if (!detail) {
        return;
    }
    [detail cnModelToJSONData];
    if (![_fmdb open]) {
        NSLog(@"could not open db");
    }
    else
    {
        static NSString *delSql     = nil;
        static NSString *updSql  = nil;
        if (type == CNDBTableTypeNewsDetail) {
            delSql  = SQL_DELETE_NEWSDETAIL_FORMAT;
            updSql  = SQL_INSERT_NEWS_DETAIL_FORMAT;
        }
        BOOL delState = [_fmdb executeUpdate:delSql, detail.ID];
        if (delState) {
            NSLog(@"delete %d detailID = %@ channel = %@",delState,detail.ID,detail.channels);
        }
        
        if (type == CNDBTableTypeNewsDetail) {
            BOOL suc = [_fmdb executeUpdate:updSql,detail.ID, detail.channel, detail.timerLoc, detail.data];
            NSLog(@"update %d detailID:%@,(%@)",suc,detail.ID,updSql);
        }
        [_fmdb close];
    }
}

- (void)updateDetails:(NSArray<CNNewsDetail *> *)details type:(CNDBTableType)type {
    if (!details || !details.count) {
        return;
    }
    if (![_fmdb open]) {
        NSLog(@"could not open db");
    }
    else
    {
        static NSString *delSql     = nil;
        static NSString *updSql  = nil;
        if (type == CNDBTableTypeNewsDetail) {
            delSql  = SQL_DELETE_NEWSDETAIL_FORMAT;
            updSql  = SQL_INSERT_NEWS_DETAIL_FORMAT;
        }
        
        [_fmdb beginTransaction];
        @try {
            for (int i = 0; i < details.count; i++) {
                CNNewsDetail *detail = details[i];
                [detail cnModelToJSONData];
                
                BOOL delState = [_fmdb executeUpdate:delSql, detail.ID];
                if (delState) {
                    NSLog(@"delete %d detailID = %@ channel = %@",delState,detail.ID,detail.channels);
                }
                
                if (type == CNDBTableTypeNewsDetail) {
                    BOOL suc = [_fmdb executeUpdate:updSql,detail.ID, detail.channel, detail.timerLoc, detail.data];
                    NSLog(@"update %d detailID:%@,(%@)",suc,detail.ID,updSql);
                }
            }
        } @catch (NSException *exception) {
            NSLog(@"batch add new list exception :%@",[exception reason]);
            [_fmdb rollback];
        } @finally {
            [_fmdb commit];
            [_fmdb close];
        }
    }

}

- (void)clearNewsDetailList {
    if (![_fmdb open]) {
        NSLog(@"could not open db");
    }
    else
    {
        BOOL suc = [_fmdb executeUpdate:SQL_CLEAR_NEWSDETAIL_LIST];
        if (suc) {
            NSLog(@"delete from newsdetail_list successful");
        }else{
            NSLog(@"failed clear newsdetail_list");
        }
        [_fmdb close];
    }

}

- (NSArray <CNNewsDetail *> *)getNewsDetailsBy:(NSArray<NSString *> *)idList type:(CNDBTableType)type;
{
    FMResultSet *rs;
    NSMutableArray *rArr = [NSMutableArray array];
    if (![_fmdb open]) {
        NSLog(@"could not open db");
    }
    else
    {
        static NSString *sqlStr = nil;
        if (type == CNDBTableTypeNewsDetail) {
            sqlStr = [NSString stringWithFormat:@"select * from %@ where ",tableNewsDetail];
        }
        for (int i = 0 ;i < idList.count ;i ++) {
            NSString *IDnum = idList[i];
            if (i == 0) {
                sqlStr = [sqlStr stringByAppendingString:[NSString stringWithFormat:@"ID = '%@'",IDnum]];
            }else{
                sqlStr = [sqlStr stringByAppendingString:[NSString stringWithFormat:@" or ID = '%@'",IDnum]];
            }
        }
        rs = [_fmdb executeQuery:sqlStr];
        while ([rs next]) {
            NSDictionary *rsEDict = [rs resultDictionary];
            CNNewsDetail * newsDetail = [CNNewsDetail new];
            [newsDetail yy_modelSetWithJSON:rsEDict];
            
            NSData *data = [rsEDict objectForKey:@"data"];
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            if (json) {
                [newsDetail yy_modelSetWithJSON:json];
            }
            [rArr addObject:newsDetail];
        }
        [_fmdb close];
    }
    return rArr;
}

- (CNNewsDetail *)getNewsDetailById:(NSString *)newsId type:(CNDBTableType)type {
    FMResultSet *rs;
    NSMutableArray *rArr = [NSMutableArray array];
    if (![_fmdb open]) {
        NSLog(@"could not open db");
    }
    else
    {
        static NSString *sqlStr = nil;
        if (type == CNDBTableTypeNewsDetail) {
            sqlStr = SQL_QUERY_NEWSDETAIL_BYID_FROMAT;
        }
        rs = [_fmdb executeQuery:sqlStr, newsId];
        while ([rs next]) {
            NSDictionary *rsEDict = [rs resultDictionary];
            CNNewsDetail * newsDetail = [CNNewsDetail new];
            [newsDetail yy_modelSetWithJSON:rsEDict];
            
            NSData *data = [rsEDict objectForKey:@"data"];
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            if (json) {
                [newsDetail yy_modelSetWithJSON:json];
            }
            [rArr addObject:newsDetail];
        }
        [_fmdb close];
    }
    return [rArr lastObject];
}



#pragma mark - DownLoadFile
//- (NSData *)getJsonOfDetailFromNews:(CNNews *)news;
//{
//    NSString *newslistPath  = [CNUtils pathOfDiskCache];
//    NSString *targetPath    = [[newslistPath stringByAppendingPathComponent:news.ID]
//                               stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.json",news.ID]];
//    NSData *data = [CNUtils dataFromPath:targetPath];
//    return data;
//}
//
//- (BOOL)updateNewsDetail:(NSData *)data ofNews:(CNNews *)news;
//{
//    NSString *newslistPath  = [CNUtils pathOfDiskCache];
//    NSString *detailDirPath    = [newslistPath stringByAppendingPathComponent:news.ID];
//    if ([[NSFileManager defaultManager] fileExistsAtPath:detailDirPath]) {
//       return [[NSFileManager defaultManager] createFileAtPath:[detailDirPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.json",news.ID]] contents:data attributes:nil];
//    }else{
//        [[NSFileManager defaultManager] createDirectoryAtPath:detailDirPath withIntermediateDirectories:NO attributes:nil error:nil];
//        return [[NSFileManager defaultManager] createFileAtPath:[detailDirPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.json",news.ID]] contents:data attributes:nil];
//    }
//}
//
//- (BOOL)removeDetailDirFromNewsId:(NSString *)newsId;
//{
//    NSString *newslistPath  = [CNUtils pathOfDiskCache];
//    NSString *detailDirPath    = [newslistPath stringByAppendingPathComponent:newsId];
//    return [[NSFileManager defaultManager] removeItemAtPath:detailDirPath error:nil];
//}
//
//- (BOOL)removeDetailDirFromNewsIdList:(NSArray < NSString *> *)idList;
//{
//    for (NSString *newsId in idList) {
//        [self removeDetailDirFromNewsId:newsId];
//    }
//    return YES;
//}

@end





