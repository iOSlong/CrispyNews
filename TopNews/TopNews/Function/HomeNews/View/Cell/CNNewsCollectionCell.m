//
//  CNNewsViewCell.m
//  CrispyNews
//
//  Created by 陈肖坤 on 16/8/17.
//  Copyright © 2016年 letv. All rights reserved.
//

#import "CNNewsCollectionCell.h"
#import "CNDataManager.h"
#import "CNNewsTableCell.h"
#import "CNChannelManager.h"
#import "CNNewsDetailViewController.h"
#import "CNRefreshAutoStateFooter.h"
#import "CNRefreshNormalHeader.h"
#import "CNStatusMask.h"
#import "CNDataLoad.h"


@interface CNNewsCollectionCell ()<UITableViewDelegate,UITableViewDataSource,CNNewsTableCellDelegate>

@property (nonatomic, strong) UITableView               *tableView;
@property (nonatomic, strong) NSMutableArray<CNNews *>  *arrNewsModel;
@property (nonatomic, strong) NSArray<CNNews *>         *arrNewsDB;
@property (nonatomic, strong) CNChannelManager          *channelManager;
@property (nonatomic, strong) CNRefreshNormalHeader     *refreshHeader;
@property (nonatomic, strong) CNRefreshAutoStateFooter  *refreshFooter;
@property (nonatomic, strong) CNStatusMask              *statusMask;
@property (nonatomic, strong) CNHeaderStatusBar         *headerStatus;


@end


@implementation CNNewsCollectionCell {
    PageCellBlock _PCBlock;
    
    NSInteger   _currentNetPage;
    BOOL        _loadMore;
    CNFreshInfo _fInfo;
}
- (void)cellPage:(PageCellBlock)thislock {
    _PCBlock = thislock;
}
- (NSMutableArray *)arrNewsModel {
    if (!_arrNewsModel) {
        _arrNewsModel = [NSMutableArray array];
        
    }
    return _arrNewsModel;
}
- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = RandomColor;

        /// 频道新闻列表控件  ：tableview
        self.tableView = [[UITableView alloc] initWithFrame:self.bounds style:UITableViewStylePlain];
        self.tableView.dataSource   = self;
        self.tableView.delegate     = self;
        self.tableView.separatorColor = RGBCOLOR_HEX(0xE8E8E8);
        self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:self.tableView];
        

        
        self.tableView.mj_header = self.refreshHeader;
        self.tableView.mj_footer = self.refreshFooter;
    

        _currentNetPage     = 0;
        _loadMore           = NO;
        _channelManager     = [CNChannelManager shareChannelManager];
        
        
        /// 标签
        self.labelIndex = [[UILabel alloc] initWithFrame:CGRectMake(100,SCREENH - 140, 100, 30)];
        self.labelIndex.textAlignment = NSTextAlignmentCenter;
        self.labelIndex.backgroundColor = [UIColor blueColor];
        [self.contentView addSubview:self.labelIndex];
        [self.labelIndex setHidden:YES];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(netStatusChange) name:NOTI_NETWORKSTATUSCHAGNE object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(newsDownLoadOver:) name:NOTI_NEWSDOWNLOAD_OVER object:nil];
        

    }
    return self;
}

#pragma mark - notiMethods
- (void)newsDownLoadOver:(NSNotification *)noti {
    NSLog(@"noti.userInfo %@",noti.userInfo);
    NSString *channel = [noti.userInfo objectForKey:@"channel"];
    if ([channel isEqualToString:self.channel.englishName])
    {
        CNDataLoad *_DL = [CNDataLoad shareDataLoad];
        if (_DL.newsArr)
        {
            if (_DL.newsDetailArray)
            {
                
                NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, _DL.newsArr.count)];
                [self.arrNewsModel insertObjects:_DL.newsArr atIndexes:indexSet];
                
                _loadMore = NO;
                [self freshShowState:CNRefreshFooterStateKeeping];
        
                [self.headerStatus showFrom:self hint:MSG_DOWNLOAD_COUNT((unsigned long)_DL.newsArr.count) hide:delay()];
            }
        }
    }
}

- (void)netStatusChange {
    if ([CNHttpRequest shareHttpRequest].netStatus == AFNetworkReachabilityStatusNotReachable)
    {
        [self.headerStatus showFrom:self hint:networknotAvailable hide:delay()];
    }
}

#pragma mark - statusMask & header
- (CNStatusMask *)statusMask {
    if (!_statusMask) {
        _statusMask = [[CNStatusMask alloc] initWithFrame:CGRectMake(0,0, SCREENW, self.height) type:CNStatusMaskDataEmpty];
    }
    return _statusMask;
}
- (CNHeaderStatusBar *)headerStatus {
    if (!_headerStatus) {
        _headerStatus = [[CNHeaderStatusBar alloc] initWithFrame:CGRectMake(0, 0, SCREENW, 40)];
    }
    return _headerStatus;
}

#pragma mark - MJRefresh
- (CNRefreshNormalHeader *)refreshHeader {
    if (!_refreshHeader) {
        weakSelf();
        CNRefreshNormalHeader *header = [CNRefreshNormalHeader headerWithRefreshingBlock:^{
            NSLog(@"refreshHeader");
            [weakSelf loadNewData];
        }];
        // 设置自动切换透明度(在导航栏下面自动隐藏)
        header.automaticallyChangeAlpha = YES;
        // 隐藏时间
        header.lastUpdatedTimeLabel.hidden = YES;
        header.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
        header.stateLabel.textColor = [UIColor lightGrayColor];
        header.lastUpdatedTimeLabel.textColor = [UIColor lightGrayColor];
        _refreshHeader = header;
    }
    return _refreshHeader;
}

- (CNRefreshAutoStateFooter *)refreshFooter {
    if (!_refreshFooter) {
        weakSelf();
        CNRefreshAutoStateFooter *footer = [CNRefreshAutoStateFooter footerWithRefreshingBlock:^{
            [weakSelf loadMoreData];
        }];
        _refreshFooter = footer;
    }
    return _refreshFooter;
}




#pragma mark - TableView DataSource & Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.arrNewsModel.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    CNNews *news;
    if (self.arrNewsModel.count > indexPath.row) {
        news = self.arrNewsModel[indexPath.row];
    }
    if (news) {
        CNStatus cstatus    = [CNDefult shareDefult].cnStatus;
//        cstatus = CNStatusNetReachable2G;
        BOOL imgShowControl = [[CNDefult shareDefult].imgShowControl boolValue];
        NSLog(@"%ld",cstatus);
        if (cstatus == CNStatusNetReachableWifi) {
            // wifi 情况下 一切正常加载
            news.imgShowControl = news.imgType;
        }else if (cstatus&(CNStatusNetReachable2G|CNStatusNetReachableNone)){
            NSLog(@"imgshowState: 2G | Nonne");
            news.imgShowControl = 0;
            // 判断本地是否有图片
            if ([news.imgType integerValue] > 0) {
                if ([CNUtils isExistCacheImgListOfURL:[news.imgUrls firstObject]]) {
                    news.imgShowControl = news.imgType;
                }
            }
        }else if (cstatus&(CNStatusNetReachable3G|CNStatusNetReachable4G)){
            NSLog(@"imgshowState: 3G | 4G");
            if (imgShowControl) {
                news.imgShowControl = 0;
                if ([news.imgType integerValue] > 0) {
                    if ([CNUtils isExistCacheImgListOfURL:[news.imgUrls firstObject]]) {
                        news.imgShowControl = news.imgType;
                    }
                }
            }else{
                news.imgShowControl = news.imgType;
            }
        }else{
            news.imgShowControl = news.imgType;
        }
    }
    
    CNNewsTableCell *cell;
    if ([news.imgShowControl integerValue] == 1) {
        cell = [tableView dequeueReusableCellWithIdentifier:cellIDImgvFull];
        if (!cell) {
            cell = [[CNNewsTableCell alloc] initWithStyle:CNNewsCellTypeImgvFull reuseIdentifier:cellIDImgvFull];
        }
    }else if ([news.imgShowControl integerValue] == 2) {
        cell = [tableView dequeueReusableCellWithIdentifier:cellIDImgvSideR];
        if (!cell) {
            cell = [[CNNewsTableCell alloc] initWithStyle:CNNewsCellTypeImgvSideR reuseIdentifier:cellIDImgvSideR];
        }
    }else if ([news.imgShowControl integerValue] == 3) {
        cell = [tableView dequeueReusableCellWithIdentifier:cellIDImgvParts];
        if (!cell) {
            cell = [[CNNewsTableCell alloc] initWithStyle:CNNewsCellTypeImgvParts reuseIdentifier:cellIDImgvParts];
        }
    }else if ([news.imgShowControl integerValue] == 0){
        cell = [tableView dequeueReusableCellWithIdentifier:cellIDImgvNone];
        if (!cell) {
            cell = [[CNNewsTableCell alloc] initWithStyle:CNNewsCellTypeImgvNone reuseIdentifier:cellIDImgvNone];
        }

    }
    cell.showIndexPath = indexPath;
    cell.news = news;
    cell.delegate = self;
    
    return cell;
}

- (void)cellNews:(CNNews *)news event:(CNNewsCellEvent)event info:(NSDictionary *)info {
    if (_PCBlock ) {
        NSInteger index = [self.arrNewsModel indexOfObject:news];
        NSIndexPath *blockIndexPath = [NSIndexPath indexPathForRow:index inSection:0];
        _PCBlock (CNPageCellEventNewsLongPress, news, blockIndexPath);
    }
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (_PCBlock && indexPath.row < self.arrNewsModel.count) {
        NSIndexPath *blockIndexPath = [indexPath copy];
        _PCBlock (CNPageCellEventNewsListClick, self.arrNewsModel[indexPath.row],blockIndexPath);
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CNNews *news ;
    if (self.arrNewsModel.count > indexPath.row) {
        news = self.arrNewsModel[indexPath.row];
    }
    
    CGFloat cellFit_H = [CNNewsTableCell cellHeightWithModel:news];
    
    return cellFit_H;
}

#pragma mark  - UICollectionViewCell Methods

/* 探知被重用的 Cell 相关信息的方法 {}
 /// TODO （1，2，3，4，5，6，7，8 ……）
 1. Cancel 原有正在进行的网络请求，
 2. 开始进行新的网络请求
 3. 对请求完整的数据，进行标记存储管理
 4. 在程序退出之后记得将数据进行缓存记忆处理。
 5. 当检测到网络的时候，（成功请求到数据的前提下，进行新数据更新，删除原有陈旧数据）
 6. 网络状态检测
 */
- (void)prepareForReuse {
    [super prepareForReuse];
    NSLog(@"self.channel = %@",self.channel.englishName);
    //    [self.arrNewsModel removeAllObjects];
    //    [self.newsTableView reloadData];
    
    //    [self.refreshHeader beginRefreshing];
}





#pragma mark - Set method rewrite

- (void)setChannel:(CNChannel *)channel {
    _channel = channel;
    self.labelIndex.text = channel.englishName;
    
    [self.arrNewsModel removeAllObjects];
    
//    [self.arrNewsModel addObjectsFromArray:[self.channelManager.dataManager getNewsByChannel:channel.englishName limit:NO]];
    
    
//    self.arrNewsDB = [self.channelManager.dataManager getNewsByChannel:channel.englishName limit:NO];
    NSArray<CNNews *> *pageNewsArr;
    
    //1. 初次启动
    if (channel.fInfo.initDone == NO)
    {
        _fInfo.initDone = YES;
        pageNewsArr = [self.channelManager.dataManager getNewsByChannel:channel.englishName limit:0 size:PAGECOUNT_NEWS type:CNDBTableTypeNewsChannel];
    }
    //2. 再次启动
    else
    {
        NSLog(@"fInfo_count = %ld",(long)_fInfo.showCount);
       pageNewsArr = [self.channelManager.dataManager getNewsByChannel:channel.englishName limit:0 size:channel.fInfo.showCount type:CNDBTableTypeNewsChannel];
    }
    
    if (pageNewsArr.count)
    {
        _fInfo.timerLocStar = [[pageNewsArr firstObject].timerLoc doubleValue];
        _fInfo.timerLocEnd  = [[pageNewsArr lastObject].timerLoc doubleValue];
        _fInfo.showCount    = pageNewsArr.count;
        
        channel.fInfo = _fInfo;
        
        [self.arrNewsModel addObjectsFromArray:pageNewsArr];
        [self.tableView reloadData];
        [self.statusMask removeFromSuperview];
        self.refreshFooter.state = MJRefreshStateIdle;

    }
    else
    {
        [self.tableView addSubview:self.statusMask];
        [self.tableView reloadData];
        [self loadNewData];
    }
    
    
    
    if ([CNHttpRequest shareHttpRequest].netStatus == AFNetworkReachabilityStatusNotReachable)
    {
        [self.headerStatus showFrom:self hint:networknotAvailable hide:delay()];
    }
}




#pragma mark - HTTPRequest 

- (void)loadNewData {
    _loadMore       = NO;
    _currentNetPage    += 1;
    
    if (self.arrNewsModel.count) {
        self.refreshFooter.state = MJRefreshStateIdle;
    }else{
        [self.refreshFooter setTitle:@"" forState:MJRefreshStateNoMoreData];
        self.refreshFooter.state = MJRefreshStateNoMoreData;
    }
//    self.tableView.mj_footer = self.refreshFooter;

    NSDictionary *param = @{@"start" : [NSNumber numberWithInteger:_currentNetPage]};
    [self netWorkGetNewsList:self.channel.englishName param:param];
    
    
    [CNUtils reportInfo:nil widget:WIDGET_NEWSLIST_FRESHHEADER Evt:evt_click];

}

- (void)loadMoreData {
    NSArray<CNNews *> * pageNewsArr = [self.channelManager.dataManager getNewsByChannel:_channel.englishName limit:_channel.fInfo.showCount size:PAGECOUNT_NEWS type:CNDBTableTypeNewsChannel];
    _loadMore       = YES;

    
    if (pageNewsArr.count)
    {
        [self.arrNewsModel addObjectsFromArray:pageNewsArr];
        _fInfo.showCount = [self.arrNewsModel count];
        _fInfo.timerLocStar = [[self.arrNewsModel firstObject].timerLoc doubleValue];
        _fInfo.timerLocEnd  = [[self.arrNewsModel lastObject].timerLoc doubleValue];
        _channel.fInfo = _fInfo;
        [self.refreshFooter endRefreshing];
        [self.tableView reloadData];
                
    }
    else
    {
        _currentNetPage    += 1;
        NSDictionary *param = @{@"start" : [NSNumber numberWithInteger:_currentNetPage]};
        [self netWorkGetNewsList:self.channel.englishName param:param];
    }
    
    [CNUtils reportInfo:nil widget:WIDGET_NEWSLIST_FRESHFOOTER Evt:evt_click];
}

- (void)freshShowState:(CNRefreshFooterState)cnSatate{
    dispatch_async(dispatch_get_main_queue(), ^{
        _fInfo.showCount        = self.arrNewsModel.count;
        _fInfo.timerLocStar     = [[self.arrNewsModel firstObject].timerLoc doubleValue];
        _fInfo.timerLocEnd      = [[self.arrNewsModel lastObject].timerLoc doubleValue];
        self.channel.fInfo = _fInfo;

        self.refreshFooter.cnState = cnSatate;
        if (self.arrNewsModel.count == 0) {
            [self.tableView addSubview:self.statusMask];
        }else{
            [self.statusMask removeFromSuperview];
        }
        
        if (_loadMore == NO) {
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
        }else{
            [self.tableView reloadData];
        }
        
    });
}

- (void) netWorkGetNewsList:(NSString *)channelName param:(NSDictionary *)param {
    NSDictionary *info = @{
                           @"cid"   :self.channel.englishName,
                           @"eid"   :[CNUtils myRandomUUID],
                           @"from"  :@"refresh",
                           };
    [CNUtils reportInfo:info widget:WIDGET_NEWSLIST_LOAD Evt:evt_click];

    weakSelf();
    [[CNHttpRequest shareHttpRequest] POST:[CNApiManager apiNewsListWithChannel:channelName] parameters:param success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        [weakSelf.refreshHeader endRefreshing];
        [weakSelf.refreshFooter endRefreshing];
        
        CNNetInfo *netInfo = [[CNNetInfo alloc]init];
        [netInfo yy_modelSetWithJSON:responseObject];
        _currentNetPage = [netInfo.page integerValue];
        NSArray *result = [responseObject objectForKey:@"result"];
        if (netInfo.success && [result isKindOfClass:[NSArray class]] && result.count)
        {
            NSMutableArray *newArr = [NSMutableArray array];
            NSTimeInterval timer = [[NSDate date] timeIntervalSince1970] * 1000;//整数毫秒级
            if (_loadMore == NO)
            {
                //                    [weakSelf.arrNewsModel removeAllObjects];
//                imgUrls
                
                for (NSDictionary *newsDict in result)
                {

                    CNNews *news = [CNNews new];
                
                    [news yy_modelSetWithJSON:newsDict];
                    
                    timer --;
                    news.timerLoc   = [NSNumber numberWithDouble:timer];
                    news.readState  = @0;
                    news.channel    = weakSelf.channel.englishName;
                    
                    // todo for test need delete
                    
                    [newArr addObject:news];
                    
                    //                        [weakSelf.arrNewsModel addObject:news];
                }

                NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, newArr.count)];
                [weakSelf.arrNewsModel insertObjects:newArr atIndexes:indexSet];
            }
            else
            {
                timer = [[weakSelf.arrNewsModel lastObject].timerLoc doubleValue];
                for (NSDictionary *newsDict in result)
                {
                    CNNews *news = [CNNews new];
                    
                    [news yy_modelSetWithJSON:newsDict];
                    
                    timer --;
                    news.timerLoc = [NSNumber numberWithDouble:timer];
                    news.channel    = weakSelf.channel.englishName;
                    news.readState  = @0;
                    
                    [newArr addObject:news];
                }
                [weakSelf.arrNewsModel addObjectsFromArray:newArr];
            }
            // 1. 下拉刷新都做存储， 加载大于poolNewsMax()的时候不要进行加载。
            if (_loadMore == NO || [[CNDataManager shareDataController] getNewsCountFromChannel:weakSelf.channel.englishName type:CNDBTableTypeNewsChannel] < poolNewsMax())
            {
                CNChannelManager *_CM = [CNChannelManager shareChannelManager];
                [_CM.dataManager addNews:newArr channel:channelName type:CNDBTableTypeNewsChannel countLimit:YES];
                
            }
            /// 刷新界面。
            if ([netInfo.limit integerValue] > result.count) {
                [weakSelf freshShowState:CNRefreshFooterStateNoMoreData];
            }else{
                [weakSelf freshShowState:CNRefreshFooterStateIdle];
            }
            if (_loadMore == NO) {
                [weakSelf.headerStatus showFrom:weakSelf
                                           hint:fetchCount(result.count)
                                           hide:TIMER_HIDE_DELAY];
            }
        }
        else // no result
        {
            /// 刷新界面。
            _currentNetPage -= 1;
            if (_arrNewsModel.count == 0) {
                [weakSelf freshShowState:CNRefreshFooterStateEmptyData];
            }else{
                if (_loadMore) {
                    [weakSelf freshShowState:CNRefreshFooterStateNoMoreData];
                }else{
                    [weakSelf freshShowState:CNRefreshFooterStateIdle];
                }
            }
            if (result && _loadMore) {
                [weakSelf.headerStatus showFrom:weakSelf
                                           hint:fetchCount([result isKindOfClass:[NSArray class]] ? result.count: 0)
                                           hide:TIMER_HIDE_DELAY];
            }
        }
        
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        [weakSelf.refreshHeader endRefreshing];
        [weakSelf.refreshFooter endRefreshing];
        _currentNetPage -= 1;
        if (error.userInfo) {
            NSString *errMsg = [error.userInfo objectForKey:@"NSLocalizedDescription"];
            if (errMsg) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [weakSelf.headerStatus showFrom:weakSelf hint:networknotAvailable hide:delay()];
                });
            }
        }
        if (weakSelf.arrNewsModel.count == 0) {
            [weakSelf freshShowState:CNRefreshFooterStateEmptyData];
        }else{
            [weakSelf freshShowState:CNRefreshFooterStateKeeping];
        }
        // todo mac 启动VPN代理，将导致@"NSLocalizedDescription" : @"The network connection was lost."	，
        if ([CNHttpRequest shareHttpRequest].netStatus == AFNetworkReachabilityStatusNotReachable)
        {
            [weakSelf.headerStatus showFrom:weakSelf hint:networknotAvailable hide:delay()];
        }else if (error.userInfo && [[error.userInfo objectForKey:@"NSLocalizedDescription"] hasPrefix:@"Could not connect to the server"]){
            [weakSelf.headerStatus showFrom:weakSelf hint:networknotAvailable hide:delay()];
        }
    
    }];
}







@end
