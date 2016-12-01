//
//  CNApiManager.m
//  CrispyNews
//
//  Created by xuewu.long on 16/8/17.
//  Copyright © 2016年 letv. All rights reserved.
//

#import "CNApiManager.h"

@implementation CNApiManager

+ (instancetype)shareApiManager {
    static dispatch_once_t onceToken;
    static CNApiManager *thisObjc;
    dispatch_once(&onceToken, ^{
        thisObjc = [[CNApiManager alloc] init];
    });
    return thisObjc;
}

+ (NSString *)apiNewsListWithChannel:(NSString *)channel {
    return [NSString stringWithFormat:@"%@api/news/%@/list.do",[CNUtils getNewsServerHost],[channel urlCoding]];
}

+ (NSString *)apiNewsJsonDetail:(NSString *)newsId {
    return [NSString stringWithFormat:@"%@api/news/%@/detail.json",[CNUtils getNewsServerHost],newsId];
}

+ (NSString *)apiNewsTextDetail:(NSString *)newsId {
        return [NSString stringWithFormat:@"%@api/news/%@/detail.do",[CNUtils getNewsServerHost],newsId];
}

+ (NSString *)apiNewsDetailWithChannel:(NSString *)channelId {
    NSMutableString *muStr = [NSMutableString stringWithString:[CNUtils getNewsServerHost]];
    [muStr appendFormat:@"api/news/%@/detail.do?platform=IOS",channelId];
    return muStr;
}

+ (NSString *)apiDetailCommentsByNewsId:(NSString *)newsId {
    return [NSString stringWithFormat:@"%@api/comments/%@/addComment.do",[CNUtils getNewsServerHost],newsId];
}

+ (NSString *)apiDetailCollection:(BOOL)isCollect byNewsId:(NSString *)newsId {
    if (isCollect) {
        return [NSString stringWithFormat:@"%@api/collection/%@/collect.do",[CNUtils getNewsServerHost],newsId];
    }else{
        return [CNApiManager apiNewsCollecionsCancel];
    }
}
+ (NSString *)apiNewsCollecionsCancel {
    return [NSString stringWithFormat:@"%@api/collection/cancel.do",[CNUtils getNewsServerHost]];
}

+ (NSString *)apiDetailGetCommentsByNewsId:(NSString *)newsId {
    return [NSString stringWithFormat:@"%@api/comments/%@/list.do",[CNUtils getNewsServerHost],newsId];
}

+ (NSString *)apiDetailGetRecommendsByNewsId:(NSString *)newsId {
    return [NSString stringWithFormat:@"%@api/news/%@/recommend.json",[CNUtils getNewsServerHost],newsId];
}


+ (NSString *)apiChannelsRecomment;{
    return [NSString stringWithFormat:@"%@api/news/channels.do",[CNUtils getNewsServerHost]];
}

+ (NSString *)apiChannelsPreference;{
    return nil;
}

+ (NSString *)apiChannelList;{
    return  [NSString stringWithFormat:@"%@api/channel/list.json",[CNUtils getNewsServerHost]];
}

+ (NSString *)apiNewsZipDownload:(NSString *)channel {
    return [NSString stringWithFormat:@"%@api/news/%@/download.do?limit=%d",[CNUtils getNewsServerHost],[channel urlCoding],DOWNLOAD_COUNT];
}

+ (NSString *)apiNewsColletionList {
    return [NSString stringWithFormat:@"%@api/collection/list.json",[CNUtils getNewsServerHost]];
}


+ (NSString *)apiNewsCollectionStateJudgeByNewsId:(NSString *)newsId {
    return [NSString stringWithFormat:@"%@api/collection/%@/existing.do",[CNUtils getNewsServerHost],newsId];
}

+ (NSString *)apiNewsLogin {
    return [NSString stringWithFormat:@"%@/api/news/login.do",[CNUtils getNewsServerHost]];
}

+ (NSString *)apiNewsLogOut {
    return [NSString stringWithFormat:@"%@/api/news/loginout.do",[CNUtils getNewsServerHost]];
}

+ (NSString *)apiNewsPushToken {
    return [NSString stringWithFormat:@"%@/push/token",[CNUtils getPushServerHost]];
}

+ (NSString *)apiNewsShareDetailId:(NSString *)detailId {
    NSMutableString *mStr = [NSMutableString stringWithString:[CNUtils getShareServerHost]];
    [mStr appendFormat:@"news/%@?platform=IOS",detailId];
    return mStr;
}

@end
