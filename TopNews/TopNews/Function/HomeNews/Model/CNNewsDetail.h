//
//  CNNewsDetail.h
//  TopNews
//
//  Created by xuewu.long on 16/9/28.
//  Copyright © 2016年 levt. All rights reserved.
//

#import "CNObject.h"

@interface CNNewsDetail : CNObject

@property (nonatomic, strong) NSString *id;
@property (nonatomic, strong) NSString *ID;
@property (nonatomic, strong) NSString *url;
@property (nonatomic, strong) NSString *site;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *author;
@property (nonatomic, strong) NSString *source;
@property (nonatomic, strong) NSString *context;
@property (nonatomic, strong) NSString *channels;
@property (nonatomic, strong) NSArray  *sections;
@property (nonatomic, strong) NSNumber *createTime;
@property (nonatomic, strong) NSNumber *publishTime;
@property (nonatomic, strong) NSNumber *hasCollected;
@property (nonatomic, strong) NSArray  *detailImageList;
@property (nonatomic, strong) NSString *detailImages;
@property (nonatomic, strong) NSString *listImageList;
@property (nonatomic, strong) NSDictionary *imgContextMap;

//=============
@property (nonatomic, strong) NSData    *result;       // 用于记录获取到的json类容
@property (nonatomic, strong) NSString  *channel;    // 所在渠道
@property (nonatomic, strong) NSNumber  *locCollected; //本地收藏{0:未本地收藏， 1:本地收藏 }
@property (nonatomic, strong) NSString  *contentPath;// 详情沙盒资源地址
@property (nonatomic, strong) NSNumber  *timerLoc;
@property (nonatomic, strong) NSNumber  *offline;        // 标志是否源自离线下载（0：非离线下载，1.来自离线下载）


@end
