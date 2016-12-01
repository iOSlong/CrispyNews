//
//  CNApiManager.h
//  CrispyNews
//
//  Created by xuewu.long on 16/8/17.
//  Copyright © 2016年 letv. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CNApiManager : NSObject

+ (instancetype)shareApiManager;

/*
 http://cripsynews.le.com/api/news/{channel}/list.do POST 访问 params start 和limit
 */
+ (NSString *)apiNewsListWithChannel:(NSString *)channel;

+ (NSString *)apiNewsJsonDetail:(NSString *)newsId;

+ (NSString *)apiNewsTextDetail:(NSString *)newsId;


+ (NSString *)apiNewsDetailWithChannel:(NSString *)channelId;

+ (NSString *)apiDetailCommentsByNewsId:(NSString *)newsId;

+ (NSString *)apiDetailCollection:(BOOL)isCollect byNewsId:(NSString *)newsId;

+ (NSString *)apiDetailGetCommentsByNewsId:(NSString *)newsId;

+ (NSString *)apiDetailGetRecommendsByNewsId:(NSString *)newsId;

+ (NSString *)apiChannelsRecomment;

+ (NSString *)apiChannelsPreference;

+ (NSString *)apiChannelList;

+ (NSString *)apiNewsZipDownload:(NSString *)channel;

//9.判断新闻是否收藏
+ (NSString *)apiNewsCollectionStateJudgeByNewsId:(NSString *)newsId;

/*10.获取收藏新闻列表
 请求URL                      方法类型
 /api/collection/list.json      POST
 要求必须登录
 参数列表:
 参数名称   类型     描述               是否必填（Y/N）
 all	int     客户端已经同步的总条数     Y
 limit	int     每页大小(默认10)         N*/
+ (NSString *)apiNewsColletionList;

/*4.取消收藏新闻
请求URL                       方法类型
/api/collection/cancel.do       POST
需要强制用户登录(uid和token必须)
参数列表
参数名称    类型          描述                      是否必填（Y/N）
newsId   String     新闻id，可以传多个，以逗号分隔       Y*/
+ (NSString *)apiNewsCollecionsCancel;


+ (NSString *)apiNewsLogin;

+ (NSString *)apiNewsLogOut;

+ (NSString *)apiNewsPushToken;

+ (NSString *)apiNewsShareDetailId:(NSString *)detailId;



/*
 //#pragma mark - NetAccess interface
 ////http://crispynews.le.com/api/news/channels.do
 //#define kNet_baseURL        @"http://10.154.250.99:8090/"
 //
 ////http://10.154.250.99:8090/api/news/%7BnewsId%7D/detail.do
 //
 ////http://10.154.250.99:8090/api/news/channels.do
 //
 ///// 新闻列表http://crispynews.le.com/api/news/list.do
 //#define kNet_newsList       @"http://10.154.250.99:8090/api/news/channel/list.do"
 //#define kNet_newsChannels   @"api/news/channels.do"
 //
 //
 //#define kNet_newsDetail     @"http://crispynews.le.com/api/news/%7BnewsId%7D/detail.do"
 //
 //#define originUrl @"http://10.154.250.99:8090/api/news/{channel}/list.do POST 访问 params start 和limit"
 apiNewsListWithChannel
 http:10.154.250.99:8090/api/news/{channel}/download.do // 下载zip
 */
@end
