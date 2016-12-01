//
//  CNDataManager.h
//  CrispyNews
//
//  Created by xuewu.long on 16/8/3.
//  Copyright © 2016年 letv. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FMDB/FMDB.h>
#import "CNNews.h"
#import "CNChannel.h"
#import "CNNewsDetail.h"
#import "CNDataSchema.h"

typedef NS_ENUM(NSUInteger, CNDBTableType) {
    CNDBTableTypeNewsChannel    = 1 << 1,
    CNDBTableTypeNewsFaves      = 1 << 2,
    CNDBTableTypeNewsDetail     = 3 << 1,
};

@interface CNDataManager : NSObject

@property (nonatomic, strong)   FMDatabase    *fmdb;
@property (nonatomic, copy)     NSString      *userId;

+ (instancetype)shareDataController;

- (NSString *)pathOfDatabase;
- (NSString *)pathOfNewsDetail;
- (NSString *)pathOfNameSpace;
- (NSString *)pathOfDiskCache;

extern int poolNewsMax(); // 新闻列表缓存池的最大理论最大容量


// 根据传入的类，生成创建表格的sqlString。
+ (NSString *)sqlCreateFormatTable:(NSString *)table class:(Class)cls;



#pragma mark - 频道
- (void)insertChannel:(CNChannel *)channel;
- (void)addChannels:(NSArray <CNChannel *> *)channels;
- (void)deleteChannelByID:(NSString *)channelID;
- (void)clearChannel_StateOn:(BOOL)stateON;
- (void)clearChannelList;
- (NSArray<CNChannel *> *)getChannelAllByASC:(BOOL)isASC;
- (NSArray<CNChannel *> *)getChannelAllByASC_StateOn:(BOOL)stateON;
+ (NSArray<CNChannel *> *)defultChannels;


#pragma mark - 新闻列表
- (void)insertNews:(CNNews *)news channel:(NSString *)channel type:(CNDBTableType)type;
- (void)addNews:(NSArray <CNNews *> *)newsList channel:(NSString *)channel type:(CNDBTableType)type;
- (void)deleteNewsList:(NSArray<NSString *> *)newsIdList type:(CNDBTableType)type;
- (void)deleteNews:(CNNews *)news type:(CNDBTableType)type;
- (void)deleteNewsByChannel:(NSString *)channel type:(CNDBTableType)type;
- (void)clearNewsListBy:(CNDBTableType)type;
- (NSArray <CNNews *> *)getNewsByChannel:(NSString *)channel limit:(NSInteger)limit size:(NSInteger)size type:(CNDBTableType)type;
- (void)addNews:(NSArray <CNNews *> *)newsList channel:(NSString *)channel type:(CNDBTableType)type countLimit:(BOOL)limit;
- (NSInteger)getNewsCountFromChannel:(NSString *)channel type:(CNDBTableType)type;

#pragma mark - 新闻详情
- (void)insertNewsDetail:(CNNewsDetail *)detail type:(CNDBTableType)type;
- (void)updateDetails:(NSArray<CNNewsDetail *> *)details type:(CNDBTableType)type;
- (void)clearNewsDetailList;
- (CNNewsDetail *)getNewsDetailById:(NSString *)newsId type:(CNDBTableType)type;
- (NSArray <CNNewsDetail *> *)getNewsDetailsBy:(NSArray<NSString *> *)idList type:(CNDBTableType)type;


#pragma mark - DownLoadFile
// 跟新详情，有则覆盖，无则添加。
//- (BOOL)updateNewsDetail:(NSData *)data ofNews:(CNNews *)news;
//// 根据新闻列表信息，获取新闻详情
//- (NSData *)getJsonOfDetailFromNews:(CNNews *)news;
//// 根据新闻Id， 移除新闻详情信息
//- (BOOL)removeDetailDirFromNewsId:(NSString *)newsId;
//// 更加新闻Id列表，移除新闻详情信息
//- (BOOL)removeDetailDirFromNewsIdList:(NSArray < NSString *> *)idList;



@end


