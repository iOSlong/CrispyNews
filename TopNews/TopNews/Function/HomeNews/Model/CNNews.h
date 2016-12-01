//
//  CNNewsModel.h
//  CrispyNews
//
//  Created by xuewu.long on 16/8/10.
//  Copyright © 2016年 letv. All rights reserved.
//

#import "CNObject.h"

@interface CNNews : CNObject

@property (nonatomic, strong) NSString *id;
@property (nonatomic, strong) NSString *url;
@property (nonatomic, strong) NSString *desc;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *author;
@property (nonatomic, strong) NSString *source;
@property (nonatomic, strong) NSString *domain;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSString *channels;
@property (nonatomic, strong) NSString *categoryName;

@property (nonatomic, strong) NSArray  *imgUrls;
@property (nonatomic, strong) NSArray  *detailImageUrls;
@property (nonatomic, strong) NSArray  *sections;
@property (nonatomic, strong) NSArray  *images;


@property (nonatomic, strong) NSNumber *imgType;    //图片类型 0 无图,1: 大图,2: 一张小图,3,三张小图
@property (nonatomic, strong) NSNumber *hasCollected;

@property (nonatomic, strong) NSString *recId;
@property (nonatomic, strong) NSString *recSource;
@property (nonatomic, strong) NSString *createTime;
@property (nonatomic, strong) NSString *publishTime;
@property (nonatomic, strong) NSNumber *collectTime;
@property (nonatomic, strong) NSString *publishTimeStr;
@property (nonatomic, strong) NSString *imgContextMap;

/// 本地添加，============================================
//=================
@property (nonatomic, strong) NSString *ID;
@property (nonatomic, strong) NSString *userId;
@property (nonatomic, strong) NSNumber *timerLoc;
@property (nonatomic, strong) NSNumber *readState;      // 阅读状态{0.未阅读， 1.已经阅读}TODO！
@property (nonatomic, strong) NSNumber *locCollected;   // 本地收藏{0:未本地收藏， 1:本地收藏 }
@property (nonatomic, strong) NSNumber *offline;        // 标志是否源自离线下载（0：非离线下载，1.来自离线下载）
@property (nonatomic, strong) NSString *channel;

@property (nonatomic, assign) BOOL marked;

/**
 用于处理在imgShowController 和 网络情况变化下的 图片展示新策略
 */
@property (nonatomic, strong) NSNumber *imgShowControl; // 0 无图， 1.大图，  2一张小图， 3 三张小图，
@property (nonatomic, strong) NSString *letvImgUrl;


- (CNNews *)newsCopy;



@end
