//
//  CNFavouriteViewController.m
//  CrispyNews
//
//  Created by xuewu.long on 16/8/8.
//  Copyright © 2016年 letv. All rights reserved.
//

#import "CNFavouriteViewController.h"
#import "CNStatusMask.h"
#import "CNApiManager.h"
#import "CNDataManager.h"
#import "CNNewsTableCell.h"
#import "CNRefreshNormalHeader.h"
#import "CNRefreshAutoStateFooter.h"
#import "CNTestInfoViewController.h"
#import "CNNewsDetailUIWebViewController.h"
#import "CNChannel.h"
#import "CNBottomView.h"

@interface CNFavouriteViewController ()<UITableViewDelegate,UITableViewDataSource,CNNewsTableCellDelegate,CNBottomViewDelegate>

@property (nonatomic, strong) CNBarButtonItem *barItemR;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) CNStatusMask              *statusMask;
@property (nonatomic, strong) CNHeaderStatusBar         *headerStatus;
@property (nonatomic, strong) NSArray<CNNews *>         *arrNewsDB;
@property (nonatomic, strong) NSMutableArray<CNNews *>  *arrNewsModel;
//@property (nonatomic, strong) CNRefreshNormalHeader     *refreshHeader;
@property (nonatomic, strong) CNRefreshAutoStateFooter  *refreshFooter;
@property (nonatomic, strong) CNBottomView              *bottomView;

@property (nonatomic, strong) NSMutableArray    *arrMarked;
@property (nonatomic, strong) NSMutableArray    *allIdList;
@property (nonatomic, strong) NSMutableArray    *locIdList;
@property (nonatomic, strong) NSMutableArray    *signIdList;
@end

@implementation CNFavouriteViewController{
    NSInteger   _currentNetPage;
    NSInteger   _markCount;
    BOOL        _loadMore;
    CNFreshInfo _fInfo;
}


#pragma mark - statusMask & header
- (CNStatusMask *)statusMask {
    if (!_statusMask) {
        _statusMask = [[CNStatusMask alloc] initWithFrame:CGRectMake(0,0, SCREENW, self.view.height) type:CNStatusMaskFavesEmpty];
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
//- (CNRefreshNormalHeader *)refreshHeader {
//    if (!_refreshHeader) {
//        weakSelf();
//        CNRefreshNormalHeader *header = [CNRefreshNormalHeader headerWithRefreshingBlock:^{
//            NSLog(@"refreshHeader");
//            [weakSelf loadNewData];
//        }];
//        // 设置自动切换透明度(在导航栏下面自动隐藏)
//        header.automaticallyChangeAlpha = YES;
//        // 隐藏时间
//        header.lastUpdatedTimeLabel.hidden = YES;
//        header.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
//        header.stateLabel.textColor = [UIColor lightGrayColor];
//        header.lastUpdatedTimeLabel.textColor = [UIColor lightGrayColor];
//        _refreshHeader = header;
//    }
//    return _refreshHeader;
//}

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

- (CNBottomView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[CNBottomView alloc] initWithFrame:CGRectMake(0, 0, SCREENW, 45) style:CNBottomViewStyleBookMark];
        _bottomView.bottom = self.view.height + _bottomView.height;
        _bottomView.delegate = self;
        _bottomView.alpha = 0;
    }
    return _bottomView;
}

- (void)bottomViewShow:(BOOL)show {
    if (show == YES) {
        _bottomView.alpha = 1;
        [UIView animateWithDuration:0.25 animations:^{
            _bottomView.bottom = self.view.height;
        }];
    }else{
        [UIView animateWithDuration:0.25 animations:^{
            _bottomView.bottom = self.view.height + self.bottomView.height;
            _bottomView.alpha = 0;
        }];

    }
}

- (void)reloadBottomViews {
    _markCount = 0;
    for (CNNews *news in self.arrNewsModel) {
        if (news.marked) {
            _markCount ++;
        }
    }
    self.bottomView.markCount = [NSString stringWithFormat:@"%ld",_markCount];
    if (_markCount == self.arrNewsModel.count && self.arrNewsModel.count > 0) {
        self.bottomView.markAll = YES;
    }else{
        self.bottomView.markAll = NO;
    }
    if (_markCount == 0 && self.arrNewsModel.count == 0) {
        self.barItemR.barState = CNBarItemStateCancel;
        [self bottomViewShow:NO];
    }
}

#pragma mark - 处理删除事件
- (void)delNewsSaved{
    [self.arrMarked removeAllObjects];
    [self.locIdList removeAllObjects];
    [self.signIdList removeAllObjects];
    [self.allIdList removeAllObjects];
    
    for (CNNews *news in self.arrNewsModel) {
        if (news.marked == YES) {
            [_allIdList addObject:news.ID];
            if ([news.hasCollected boolValue]) {
                [_signIdList addObject:news.ID];
            }
            if ([news.locCollected boolValue]) {
                [_locIdList addObject:news.ID];
            }
            [self.arrMarked addObject:news];
        }
    }
    
    if ([[CNDefult shareDefult].userState boolValue]) {
        NSLog(@"signIdlist = %@",[_signIdList componentsJoinedByString:@","]);
        [self netCancelColletion:_signIdList];
    }else{
        NSArray *detailArr = [[CNDataManager shareDataController] getNewsDetailsBy:_allIdList type:CNDBTableTypeNewsDetail];
        for (CNNewsDetail *detail in detailArr) {
            detail.locCollected = @0;
        }
        
        [[CNDataManager shareDataController] updateDetails:detailArr type:CNDBTableTypeNewsDetail];
        [[CNDataManager shareDataController] deleteNewsList:_allIdList type:CNDBTableTypeNewsFaves];
        
        
        for (CNNews *news in self.arrMarked) {
            NSInteger index = [self.arrNewsModel indexOfObject:news];
            [self.arrNewsModel removeObjectAtIndex:index];
        }
        [self reloadBottomViews];
        if (self.arrNewsModel.count == 0) {
            [self freshShowState:CNRefreshFooterStateEmptyData];
        }else{
            [self freshShowState:CNRefreshFooterStateNoMoreData];
        }
    }
}

- (void)delCollectionWithSignSuc:(BOOL)signDelSuccess{
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSArray *detailArr;
        if (signDelSuccess) {
            detailArr = [[CNDataManager shareDataController] getNewsDetailsBy:_allIdList type:CNDBTableTypeNewsDetail];
            for (CNNewsDetail *detail in detailArr) {
                detail.hasCollected = @0;
                detail.locCollected = @0;
            }
            [[CNDataManager shareDataController] deleteNewsList:_allIdList type:CNDBTableTypeNewsFaves];
            
            for (CNNews *news in self.arrMarked) {
                NSInteger index = [self.arrNewsModel indexOfObject:news];
                [self.arrNewsModel removeObjectAtIndex:index];
            }
        }else{
            detailArr = [[CNDataManager shareDataController] getNewsDetailsBy:_locIdList type:CNDBTableTypeNewsDetail];
            for (CNNewsDetail *detail in detailArr) {
                detail.locCollected = @0;
            }
            [[CNDataManager shareDataController] deleteNewsList:_locIdList type:CNDBTableTypeNewsFaves];
            
            for (CNNews *news in self.arrMarked) {
                NSInteger index = [self.arrNewsModel indexOfObject:news];
                if ([news.hasCollected boolValue] == 0) {
                    [self.arrNewsModel removeObjectAtIndex:index];
                }
            }
        }
        [[CNDataManager shareDataController] updateDetails:detailArr type:CNDBTableTypeNewsDetail];
        
        // 刷新界面
        dispatch_async(dispatch_get_main_queue(), ^{
            [self reloadBottomViews];
            if (self.arrNewsModel.count == 0) {
                [self freshShowState:CNRefreshFooterStateEmptyData];
            }else{
                [self freshShowState:CNRefreshFooterStateNoMoreData];
            }
        });
        
    });
    
  
}

- (void)editStateNone {
    for (CNNews *new in self.arrNewsModel) {
        new.marked = NO;
    }
    [self.tableView reloadData];
    [self reloadBottomViews];
}
- (void)bottomBtnClickEvent:(CNBottomEvent)event {
    switch (event) {
        case CNBottomEventMarkNone:
        {
            [self editStateNone];
        }
            break;
        case CNBottomEventMarkAll:{
            for (CNNews *new in self.arrNewsModel) {
                new.marked = YES;
            }
            [self.tableView reloadData];
            [self reloadBottomViews];
        }
            break;
        case CNBottomEventDelClick:
        {
            if (_markCount > 0) {
                [self delNewsSaved];
                [CNUtils reportInfo:nil widget:WIDGET_FAVESLIST_DEL_CLICK Evt:evt_click];
            }
        }
            break;
            
        default:
            break;
    }
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (_fInfo.showCount < 10) {
        _fInfo.showCount = 10;
        [self reloadSavedList];
    }
    [CNUtils reportInfo:nil widget:WIDGET_FAVESLIST_EXPOSE Evt:evt_click];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (self.barItemR.barState == CNBarItemStateEdit) {
        self.barItemR.barState = CNBarItemStateCancel;
        [self bottomViewShow:NO];
    }
}

- (CNBarButtonItem *)barItemR{
    if (_barItemR == nil) {
        _barItemR = [[CNBarButtonItem alloc] barButtomItem:@"Edit"];
        _barItemR.barState = CNBarItemStateCancel;
        weakSelf();
        [_barItemR barBlock:^(CNBarButtonItem *barBItem) {
            [CNUtils reportInfo:nil widget:WIDGET_FAVESLIST_EDIT_CLICK Evt:evt_click];
            if (barBItem.barState == CNBarItemStateCancel) {
                barBItem.barState = CNBarItemStateEdit;
                [weakSelf editStateNone];
                [weakSelf bottomViewShow:YES];
            }
            else{
                barBItem.barState = CNBarItemStateCancel;
                [weakSelf bottomViewShow:NO];
            }
            [weakSelf.tableView reloadData];
        }];
    }
    return _barItemR;
}

- (void)configureNavigationBarWithRightItemSHow:(BOOL)show {
    UIBarButtonItem *rightSpaceItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    rightSpaceItem.width =  iPhone6Plus? -15:-8;
    if (show) {
        self.navigationItem.rightBarButtonItems = @[rightSpaceItem,self.barItemR];
    }else{
        self.navigationItem.rightBarButtonItems = @[];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _arrNewsModel = [NSMutableArray array];
    _arrMarked  = [NSMutableArray array];
    _allIdList  = [NSMutableArray array];
    _locIdList  = [NSMutableArray array];
    _signIdList = [NSMutableArray array];

    
    
    self.arrowBack = YES;
    
    
    [self configureNavigationBarWithRightItemSHow:NO];
    
    
    
    
    /// 频道新闻列表控件  ：tableview
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tableView.dataSource   = self;
    self.tableView.delegate     = self;
    self.tableView.separatorColor = RGBCOLOR_HEX(0xE8E8E8);
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:self.tableView];
    
    
    
//    self.tableView.mj_header = self.refreshHeader;
    self.tableView.mj_footer = self.refreshFooter;
    
    
    [self.view addSubview:self.bottomView];
    
    
    
    
    
    // TODO添加登录状态判断处理
    if (_fInfo.initDone == NO) {
        _fInfo.initDone = YES;
        NSArray *cacheArr = [[CNDataManager shareDataController] getNewsByChannel:nil limit:0 size:PAGECOUNT_NEWS type:CNDBTableTypeNewsFaves];
        _fInfo.showCount = cacheArr.count;
        if (cacheArr) {
            NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, cacheArr.count)];
            [self.arrNewsModel insertObjects:cacheArr atIndexes:indexSet];
        }
        else
        {
            [self loadNewData];
        }
    }else{
        
    }
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
    CNNewsTableCell *cell;
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
    
    if ([news.imgType integerValue] == 1) {
        cell = [tableView dequeueReusableCellWithIdentifier:cellIDImgvFull];
        if (!cell) {
            cell = [[CNNewsTableCell alloc] initWithStyle:CNNewsCellTypeImgvFull reuseIdentifier:cellIDImgvFull];
        }
    }else if ([news.imgType integerValue] == 2) {
        cell = [tableView dequeueReusableCellWithIdentifier:cellIDImgvSideR];
        if (!cell) {
            cell = [[CNNewsTableCell alloc] initWithStyle:CNNewsCellTypeImgvSideR reuseIdentifier:cellIDImgvSideR];
        }
    }else if ([news.imgType integerValue] == 3) {
        cell = [tableView dequeueReusableCellWithIdentifier:cellIDImgvParts];
        if (!cell) {
            cell = [[CNNewsTableCell alloc] initWithStyle:CNNewsCellTypeImgvParts reuseIdentifier:cellIDImgvParts];
        }
    }else if ([news.imgType integerValue] == 0){
        cell = [tableView dequeueReusableCellWithIdentifier:cellIDImgvNone];
        if (!cell) {
            cell = [[CNNewsTableCell alloc] initWithStyle:CNNewsCellTypeImgvNone reuseIdentifier:cellIDImgvNone];
        }
    }
    
    cell.news = news;
    cell.delegate = self;
    if (self.barItemR.barState == CNBarItemStateEdit) {
        cell.cellState = CNNewsCellStateEditing;
    }else{
        cell.cellState = CNNewsCellStateNormal;
    }
    
    return cell;
}

- (void)cellNews:(CNNews *)news event:(CNNewsCellEvent)event info:(NSDictionary *)info{
    if (event == CNNewsCellEventLongPress) {
        CNTestInfoViewController *_testInfoVC = [[CNTestInfoViewController alloc] init];
        _testInfoVC.newsId = news.ID;
        [self.navigationController pushViewController:_testInfoVC animated:YES];
    }else{
        [self reloadBottomViews];
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.barItemR.barState == CNBarItemStateEdit) {
        CNNewsTableCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        cell.marked = !cell.marked;
    }else{
        CNNewsDetailUIWebViewController *_newsweb = [[CNNewsDetailUIWebViewController alloc] init];
        CNNews *news = [self.arrNewsModel objectAtIndex:indexPath.row];
        _newsweb.news = news;
        _newsweb.channelName = @"saved";
        _newsweb.newsFrom    = NSStringFromClass([self class]);
        weakSelf();
        [_newsweb detailBlock:^(NSDictionary *eventInfo) {
            [weakSelf reloadSavedList];
        }];
        [self.navigationController pushViewController:_newsweb animated:YES];
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


- (void)loadNewData {
    _loadMore = NO;
    [self netGetCollectionList];
}
- (void)loadMoreData {
    NSArray<CNNews *> * pageNewsArr = [[CNDataManager shareDataController] getNewsByChannel:nil limit:_fInfo.showCount size:PAGECOUNT_NEWS type:CNDBTableTypeNewsFaves];
    _loadMore       = YES;
    
    if (pageNewsArr.count)
    {
        [self.arrNewsModel addObjectsFromArray:pageNewsArr];
        _fInfo.showCount = [self.arrNewsModel count];
        [self.refreshFooter endRefreshing];
//        [self.headerStatus showFrom:self.view
//                               hint:fetchCount(pageNewsArr.count)
//                               hide:TIMER_HIDE_DELAY offSetY:NAVBAROFFSETY];
        [self.tableView reloadData];
    }
    else
    {
        [self netGetCollectionList];
    }
}


- (void)reloadSavedList {
    NSInteger favesCount = [[CNDataManager shareDataController] getNewsCountFromChannel:nil type:CNDBTableTypeNewsFaves];
    if (favesCount < _fInfo.showCount) {

    }
    NSArray *cacheArr = [[CNDataManager shareDataController] getNewsByChannel:nil limit:0 size:_fInfo.showCount type:CNDBTableTypeNewsFaves];
    _fInfo.showCount = cacheArr.count;
    if (cacheArr.count)
    {
        [self.arrNewsModel removeAllObjects];
        NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, cacheArr.count)];
        [self.arrNewsModel insertObjects:cacheArr atIndexes:indexSet];
        if (self.arrNewsModel.count == favesCount) {
            [self freshShowState:CNRefreshFooterStateNoMoreData];
        }
    }
    else
    {
        [self loadNewData];
    }
}

- (void)freshShowState:(CNRefreshFooterState)cnSatate{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.refreshFooter.cnState = cnSatate;
        if (self.tableView.contentSize.height < SCREENH && self.arrNewsModel.count < 10) {
            self.refreshFooter.cnState = CNRefreshFooterStateBlankInfo;
        }
        if (self.arrNewsModel.count == 0) {
            [self.tableView addSubview:self.statusMask];
        }else{
            [self.statusMask removeFromSuperview];
        }
        [self.tableView reloadData];
        if (self.arrNewsModel.count) {
            [self configureNavigationBarWithRightItemSHow:YES];
        }else{
            [self configureNavigationBarWithRightItemSHow:NO];
        }
    });
}


#pragma mark 计算已经加载数据中线上数据的数目。
- (NSNumber *)locLineCollectionCount {
    NSInteger lineCount = 0;
    for (CNNews *news in self.arrNewsModel) {
        if ([news.hasCollected boolValue]) {
            lineCount ++;
        }
    }
    return [NSNumber numberWithInteger:lineCount];
}

#pragma mark - NetWorking
- (void)netGetCollectionList {
    NSString *colletionsApi = [CNApiManager apiNewsColletionList];
    weakSelf();
    NSDictionary *param = @{@"all"  : [self locLineCollectionCount]};
    NSLog(@"param:%@",param);
    [[CNHttpRequest shareHttpRequest] POST:colletionsApi parameters:param success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
//        [weakSelf.refreshHeader endRefreshing];
        [weakSelf.refreshFooter endRefreshing];
        CNNetInfo *netInfo = [[CNNetInfo alloc]init];
        [netInfo yy_modelSetWithJSON:responseObject];
        if (netInfo.success)
        {
            NSArray *result = [responseObject objectForKey:@"result"];
            if ([result isKindOfClass:[NSArray class]] && result.count)
            {
                NSMutableArray *newArr = [NSMutableArray array];

                for (NSDictionary *newsDict in result)
                {
                    CNNews *news = [CNNews new];
                    
                    [news yy_modelSetWithJSON:newsDict];
                    news.timerLoc = news.collectTime;
                    
                    // 本地遍历去重
                    for (CNNews *locNews in weakSelf.arrNewsModel) {
                        if ([locNews.ID isEqualToString:news.ID]) {
                            [weakSelf.arrNewsModel removeObject:locNews];
                            break;
                        }
                    }
                    [newArr addObject:news];
                    
                }
                
                [weakSelf.arrNewsModel addObjectsFromArray:newArr];
                NSInteger newLocLineCount = [[CNDefult shareDefult].locLineCollectionCount integerValue] + newArr.count;
                [CNDefult shareDefult].locLineCollectionCount = [NSNumber numberWithInteger:newLocLineCount];
                [[CNDataManager shareDataController] addNews:newArr channel:nil type:CNDBTableTypeNewsFaves];
                /// 刷新界面。
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    for (int i = 0; i < weakSelf.arrNewsModel.count ; i ++ ) {
                        for (int j = 0; j < weakSelf.arrNewsModel.count; j ++) {
                            CNNews *iNews = weakSelf.arrNewsModel[i];
                            CNNews *jNews = weakSelf.arrNewsModel[j];
                            if (iNews.timerLoc < jNews.timerLoc) {
                                [weakSelf.arrNewsModel exchangeObjectAtIndex:i withObjectAtIndex:j];
                            }
                        }
                    }
                    
                    if ([netInfo.limit integerValue] > result.count) {
                        [weakSelf freshShowState:CNRefreshFooterStateNoMoreData];
                    }else{
                        [weakSelf freshShowState:CNRefreshFooterStateIdle];
                    }
                    
                    [weakSelf.headerStatus showFrom:weakSelf.view
                                               hint:fetchCount(result.count)
                                               hide:TIMER_HIDE_DELAY offSetY:NAVBAROFFSETY];
                });
                
            }
            else // no result
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (_loadMore == NO) {
                        [weakSelf.headerStatus showFrom:weakSelf.view
                                                   hint:fetchCount(0)
                                                   hide:TIMER_HIDE_DELAY offSetY:NAVBAROFFSETY];
                    }
                });
                if (_arrNewsModel.count == 0) {
                    [weakSelf freshShowState:CNRefreshFooterStateEmptyData];
                }else{
                    if (_loadMore) {
                        [weakSelf freshShowState:CNRefreshFooterStateNoMoreData];
                    }else{
                        [weakSelf freshShowState:CNRefreshFooterStateIdle];
                    }
                }
            }
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                if (_loadMore == NO) {
                    [weakSelf.headerStatus showFrom:weakSelf.view
                                               hint:fetchCount(0)
                                               hide:TIMER_HIDE_DELAY offSetY:NAVBAROFFSETY];
                }
            });
            if (_arrNewsModel.count == 0) {
                [weakSelf freshShowState:CNRefreshFooterStateEmptyData];
            }else{
                if (_loadMore) {
                    [weakSelf freshShowState:CNRefreshFooterStateNoMoreData];
                }else{
                    [weakSelf freshShowState:CNRefreshFooterStateIdle];
                }
            }
        }
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
//        [weakSelf.refreshHeader endRefreshing];
        [weakSelf.refreshFooter endRefreshing];
        _currentNetPage -= 1;
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.tableView reloadData];
            if (weakSelf.arrNewsModel.count == 0) {
                [weakSelf.refreshFooter setTitle:@"" forState:MJRefreshStateNoMoreData];
                weakSelf.refreshFooter.state = MJRefreshStateNoMoreData;
                //                [weakSelf.contentView addSubview:weakSelf.statusMask];
                [weakSelf.tableView addSubview:weakSelf.statusMask];
            }
            // todo mac 启动VPN代理，将导致@"NSLocalizedDescription" : @"The network connection was lost."	，
            if ([CNHttpRequest shareHttpRequest].netStatus == AFNetworkReachabilityStatusNotReachable)
            {
                [weakSelf.headerStatus showFrom:weakSelf.view hint:networknotAvailable hide:delay() offSetY:NAVBAROFFSETY];
            }else if (error.userInfo && [[error.userInfo objectForKey:@"NSLocalizedDescription"] hasPrefix:@"Could not connect to the server"]){
                [weakSelf.headerStatus showFrom:weakSelf.view hint:networknotAvailable hide:delay() offSetY:NAVBAROFFSETY];
            }
        });
        
    }];
}

- (void)netCancelColletion:(NSArray *)idList;
{
    NSString *collectionCancelAPi = [CNApiManager apiNewsCollecionsCancel];
    NSDictionary *param = @{@"newsId" :[idList componentsJoinedByString:@","] };
    NSLog(@" param: %@",param);
    weakSelf();
    [[CNHttpRequest shareHttpRequest] POST:collectionCancelAPi parameters:param success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        CNNetInfo *netInfo = [[CNNetInfo alloc]init];
        [netInfo yy_modelSetWithJSON:responseObject];
        if (netInfo.success)
        {
            [weakSelf showHint:@"Bookmark removed" hide:TIMER_HIDE_DELAY];
            // 处理刷新的机制。
            [weakSelf delCollectionWithSignSuc:YES];
            
        }else{
            [weakSelf showHint:netInfo.errorMsg hide:TIMER_HIDE_DELAY];
            [weakSelf delCollectionWithSignSuc:NO];
        }
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        if (error.userInfo) {
            NSString *errMsg = [error.userInfo objectForKey:@"NSLocalizedDescription"];
            if (errMsg) {
                [weakSelf showHint:errMsg hide:TIMER_HIDE_DELAY];
            }
        }
    }];
}


- (void)dealloc {
    NSLog(@"dealloc [FavouriteVC]");
    
}


@end
