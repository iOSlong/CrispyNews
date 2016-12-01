//
//  CNRefreshAutoStateFooter.h
//  TopNews
//
//  Created by xuewu.long on 16/9/13.
//  Copyright © 2016年 levt. All rights reserved.
//

#import <MJRefresh/MJRefresh.h>

typedef NS_ENUM(NSUInteger, CNRefreshFooterState) {
    /** 普通闲置状态 */
    CNRefreshFooterStateIdle        = MJRefreshStateIdle,
    /** 松开就可以进行刷新的状态 */
    CNRefreshFooterStatePulling     = MJRefreshStatePulling,
    /** 正在刷新中的状态 */
    CNRefreshFooterStateRefreshing  = MJRefreshStateRefreshing,
    /** 即将刷新的状态 */
    CNRefreshFooterStateWillRefresh = MJRefreshStateWillRefresh,
    /** 所有数据加载完毕，没有更多的数据了 */
    CNRefreshFooterStateNoMoreData  = MJRefreshStateNoMoreData,
    /** 列表完全没有数据*/
    CNRefreshFooterStateEmptyData,
    /* 列表footer 不显示任何数据*/
    CNRefreshFooterStateBlankInfo,
    /** 没有网络的情况下给一个无网络的提示*/
    CNRefreshFooterStateNetNone,
    /** 不对列表原有状态进行变更 */
    CNRefreshFooterStateKeeping
};

@interface CNRefreshAutoStateFooter : MJRefreshAutoStateFooter

@property (nonatomic, assign) CNRefreshFooterState cnState;


@end
