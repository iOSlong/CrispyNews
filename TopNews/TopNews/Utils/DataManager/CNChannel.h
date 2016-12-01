//
//  CNChannel.h
//  CrispyNews
//
//  Created by xuewu.long on 16/8/10.
//  Copyright © 2016年 letv. All rights reserved.
//

#import "CNObject.h"


typedef struct CNNewsFreshInfo{
    BOOL initDone;                  //标记是否启动频道浏览模式
    NSTimeInterval  timerLocStar;   //标记频道首条新闻     timerLoc
    NSTimeInterval  timerLocEnd;    //标记频道尾条条新闻    timerLoc
    NSInteger       showCount;      //显示数目
}CNFreshInfo;

@interface CNChannel : CNObject

@property (nonatomic, strong) NSString  *chinaName;
@property (nonatomic, strong) NSString  *createBy;
@property (nonatomic, strong) NSString  *createTime;
@property (nonatomic, strong) NSString  *englishName;
@property (nonatomic, strong) NSString  *id;
@property (nonatomic, strong) NSString  *ID;
@property (nonatomic, strong) NSString  *modiyBy;
@property (nonatomic, strong) NSString  *modiyTime;
@property (nonatomic, assign) NSNumber  *channelState;   //渠道状态（选中，未选中，~）
@property (nonatomic, assign) NSNumber  *sortLoc;        //排序位置（0，1，2，3 ~）


@property (nonatomic, assign) CNFreshInfo fInfo;

@end
