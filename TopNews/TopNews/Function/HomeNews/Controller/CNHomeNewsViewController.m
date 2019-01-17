//
//  HomeNewsViewController.m
//  CrispyNews
//
//  Created by 陈肖坤 on 16/7/25.
//  Copyright © 2016年 陈肖坤. All rights reserved.
//

#import "CNHomeNewsViewController.h"
#import "CNSegmentView.h"
#import "AppDelegate.h"
#import "CNChannelManager.h"
#import "CNChannelSetPlat.h"
#import "CNChannelConfigurePlat.h"
#import "CNNewsCollectionView.h"
#import "CNNewsCollectionCell.h"
#import "CNNewsDetailViewController.h"
#import "CNNewsDetailUIWebViewController.h"
#import "CNChannelConfigureViewController.h"
#import "CNDataLoad.h"
#import "CNTestInfoViewController.h"

@interface CNHomeNewsViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,CNDataLoadDelegate>

@property (nonatomic, strong) CNDataManager         *cnDM;
@property (nonatomic, strong) CNChannel             *currentChannel;
@property (nonatomic, strong) CNSegmentView         *segmentView;
@property (nonatomic, strong) CNBarButtonItem       *loadItem;
@property (nonatomic, strong) CNChannelManager      *channelManager;
@property (nonatomic, strong) CNChannelSetPlat      *channelSetPlat;
@property (nonatomic, strong) CNNewsCollectionView  *newsCollectionView;
@property (nonatomic, strong) CNChannelConfigurePlat*channelConfigurePlat;

@end

static NSString * const reuseIdentifier = @"newsCellViewID";


@implementation CNHomeNewsViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.channelManager = [CNChannelManager shareChannelManager];
    }
    return self;
}


- (void)setArrChannel:(NSArray<CNChannel *> *)arrChannel {
    _arrChannel = arrChannel;
        NSMutableArray *themeNameArr = [NSMutableArray array];
    for (CNChannel *channel in self.arrChannel) {
        [themeNameArr addObject:channel.englishName];
    }
    self.segmentView.arrItem = themeNameArr;
    NSInteger index = 0;
    if (_currentChannel) {
        for (int i = 0; i < arrChannel.count; i ++) {
            if ([_currentChannel.englishName isEqualToString:arrChannel[i].englishName]) {
                index = i;
                break;
            }
        }
    }
    self.segmentView.selectedIndex = index;
    self.currentChannel = [self.arrChannel objectAtIndex:self.segmentView.selectedIndex];
    [self.newsCollectionView reloadData];
    [self.newsCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
}

- (CNSegmentView *)segmentView {
    if (!_segmentView) {
        _segmentView = [[CNSegmentView alloc] initWithFrame:CGRectMake(0, 64, SCREENW, [CNSegmentView segmentHeight])];
        weakSelf();
        [_segmentView cn_segBlock:^(NSInteger selectedIndex, CNSegmentEvent segEvent) {
            if (segEvent == CNSegmentEventAddClick) {
                [weakSelf showChannelSetView];
                NSDictionary *info = @{@"eid":[CNUtils myRandomUUID]};
                [CNUtils reportInfo:info widget:WIDGET_HOMEVIEW_MENU_CLICK Evt:evt_click];
            }else if (segEvent == CNSegmentEventItemClick){
                NSIndexPath *indexPath  = [NSIndexPath indexPathForRow:selectedIndex inSection:0];
                weakSelf.currentChannel = [weakSelf.arrChannel objectAtIndex:selectedIndex];
                [weakSelf.newsCollectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
            }
        }];
    }
    return _segmentView;
}


#pragma mark 显示频道设置页面
- (CNChannelSetPlat *)channelSetPlat {
    if (!_channelSetPlat) {
        _channelSetPlat = [[CNChannelSetPlat alloc] initWithFrame:self.view.bounds];
        _channelSetPlat.baseVC = self;
        [self.navigationController.view addSubview:_channelSetPlat];
        _channelSetPlat.top = - self.view.height;
        weakSelf();
        [_channelSetPlat channelSet:^(CNChannelSetPlatEvent event) {
            if (event == CNChannelSetPlatEventSortChange || event == CNChannelSetPlatEventMemberChange)
            {
                NSLog(@"TODO!,需要调整channel排序");
                NSArray *newChannels = [[CNDataManager shareDataController] getChannelAllByASC_StateOn:YES];
                [weakSelf setArrChannel:newChannels];
            }
            [weakSelf.channelSetPlat hidden];
            // 恢复抽屉滑动功能。
            AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
            [delegate.crispyMenu  setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
        }];
    }
    return  _channelSetPlat;
}

- (CNChannelConfigurePlat *)channelConfigurePlat {
    if (!_channelConfigurePlat) {
        _channelConfigurePlat = [[CNChannelConfigurePlat alloc] initWithFrame:self.view.bounds];
        _channelConfigurePlat.baseVC = self;
        [self.navigationController.view addSubview:_channelConfigurePlat];
        weakSelf();
        [_channelConfigurePlat channelSet:^(CNChannelSetPlatEvent event) {
            if (event == CNChannelSetPlatEventSortChange || event == CNChannelSetPlatEventMemberChange)
            {
                NSLog(@"TODO!,需要调整channel排序");
                NSArray *newChannels = [[CNDataManager shareDataController] getChannelAllByASC_StateOn:YES];
                [weakSelf setArrChannel:newChannels];
            }
            [weakSelf.channelConfigurePlat hidden];
            // 恢复抽屉滑动功能。
            AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
            [delegate.crispyMenu  setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
        }];
    }
    return _channelConfigurePlat;
}

- (void)showChannelSetView {
    
#if 1
    
    // 提供数据参考，
    self.channelSetPlat.arrSortRefer = self.segmentView.arrItem;
    [self.channelSetPlat show];
    // 禁掉抽屉滑动出现功能。
#else
        //    CNChannelConfigureViewController *_configureVC = [[CNChannelConfigureViewController alloc] init];
        //    [self.navigationController pushViewController:_configureVC animated:YES];
        //
    
    self.channelConfigurePlat.arrSortRefer = self.segmentView.arrItem;
    [self.channelConfigurePlat show];
    
    
        //    [CNUtils reportWgt_WidgetId:@"testOne"];

#endif
    
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [delegate.crispyMenu  setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeCustom];

}


- (CNNewsCollectionView *)newsCollectionView {
    if (!_newsCollectionView) {
        _newsCollectionView = [[CNNewsCollectionView alloc] initWithFrame:CGRectMake(0, 64 + self.segmentView.height, SCREENW, SCREENH - 64 - [CNSegmentView segmentHeight])];
        _newsCollectionView.backgroundColor = [UIColor clearColor];
        _newsCollectionView.delegate        = self;
        _newsCollectionView.dataSource      = self;
        _newsCollectionView.pagingEnabled   = YES;
        
        [_newsCollectionView registerClass:[CNNewsCollectionCell class] forCellWithReuseIdentifier:reuseIdentifier];
    }
    return _newsCollectionView;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offsetX = scrollView.contentOffset.x;
    self.segmentView.mapOffsetX = offsetX;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configureNavBar];
    
    [self configureNotifications];
    self.view.backgroundColor = RGBCOLOR_HEX(0xfefefe);
    self.automaticallyAdjustsScrollViewInsets = NO;

    [self.view addSubview:self.segmentView];

    [self.view addSubview:self.newsCollectionView];
    
    [self.view bringSubviewToFront:self.segmentView];
    
    [self monitorNetReachability];
    
}


#pragma mark PageScrollView
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.arrChannel.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CNNewsCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    cell.destViewController = self;
    
    if (!cell) {
        cell = [[CNNewsCollectionCell alloc] init];
    }
    
    cell.labelIndex.text = [NSString stringWithFormat:@"index=%ld",(long)indexPath.row];

    CNChannel *channel = self.arrChannel[indexPath.row];
    cell.channel = channel;
    
    cell.backgroundColor = [UIColor redColor];
#pragma mark 新闻点击
    weakSelf();
    [cell cellPage:^(CNPageCellEvent event, CNNews *news, NSIndexPath *cellIndexPath) {
        if (event == CNPageCellEventNewsListClick)
        {
            NSDictionary *info = @{@"vid"   :news.ID,
                                   @"cid"   :weakSelf.currentChannel.englishName,
                                   @"url"   :news.url,
                                   @"eid"   :[CNUtils myRandomUUID],
                                   @"name"  :news.title,
                                   };
            [CNUtils reportInfo:info widget:WIDGET_NEWS_CLICK Evt:evt_click];
            
            if ([[CNDefult shareDefult].webType integerValue] == 1)
            {
                CNNewsDetailUIWebViewController *_newsweb = [[CNNewsDetailUIWebViewController alloc] init];
                _newsweb.news = news;
                _newsweb.channelName = weakSelf.currentChannel.englishName;
                _newsweb.newsFrom = NSStringFromClass([self class]);
                [_newsweb detailBlock:^(NSDictionary *eventInfo) {
                    [weakSelf.newsCollectionView reloadData];
                }];
                [weakSelf.navigationController pushViewController:_newsweb animated:YES];
            }else{
                CNNewsDetailViewController *_newsDetail = [[CNNewsDetailViewController alloc] init];
                _newsDetail.news = news;
                _newsDetail.channelName = weakSelf.currentChannel.englishName;
                [_newsDetail detailBlock:^(NSDictionary *eventInfo)
                 {
                     [weakSelf.newsCollectionView reloadData];
                 }];
                [weakSelf.navigationController pushViewController:_newsDetail animated:YES];
            }
        }
        else if (event == CNPageCellEventNewsLongPress)
        {
            CNTestInfoViewController *_testInfoVC = [[CNTestInfoViewController alloc] init];
            _testInfoVC.newsId  = news.ID;
            _testInfoVC.news    = news;
            [weakSelf.navigationController pushViewController:_testInfoVC animated:YES];
        }
    }];
    return cell;
}



- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSInteger pageIndex = scrollView.contentOffset.x / SCREENW;
    self.currentChannel = [self.arrChannel objectAtIndex:pageIndex];
    [self.segmentView setSelectedIndex:pageIndex];
}





- (void)monitorNetReachability {
    [[CNHttpRequest shareHttpRequest] starMonitoringNetReachability:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusNotReachable:
            {
                NSLog(@"Monitoring> NotReachable");
                [CNUtils postNotificationName:NOTI_NETWORKSTATUSCHAGNE object:nil];
                //                [CNUtils showHint:@"链接不上网络，请检查网络链接！" hide:2.0f];
            }
                break;
                
            case AFNetworkReachabilityStatusReachableViaWWAN:{
                NSLog(@"Monitoring> ViaWWan");
                
            }
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:{
                NSLog(@"Monitoring> ViaWiFi");
                
            }
                break;
            case AFNetworkReachabilityStatusUnknown:{
                NSLog(@"Monitoring> Unknown");
                
            }
                break;
            default:
                break;
        }
    }];
}


#pragma mark - 导航
- (void)configureNavBar
{
    self.title = @"TopNews";
    weakSelf();
    CNBarButtonItem *menuItem = [[CNBarButtonItem alloc] barMenuButtomItem];
    [menuItem barBlock:^(CNBarButtonItem *barBItem) {
        NSLog(@"menu click");
        [CNUtils reportInfo:nil widget:WIDGET_HOMEVIEW_MENU_CLICK Evt:evt_click];
        AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        if (appDelegate.crispyMenu.openSide == MMDrawerSideNone) {
            [appDelegate.crispyMenu openDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
            [CNUtils reportInfo:nil widget:WIDGET_MENUVIEW_EXPOSE Evt:evt_click];
        }else{
            [appDelegate.crispyMenu closeDrawerAnimated:YES completion:nil];
        }
    }];
    UIBarButtonItem *leftSpaceItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    leftSpaceItem.width =  iPhone6Plus? -18:-10;
    self.navigationItem.leftBarButtonItems = @[leftSpaceItem,menuItem];
    
//    
    self.loadItem = [[CNBarButtonItem alloc] barLoadButtomItem];
    CNDataLoad *_DL = [CNDataLoad shareDataLoad];
    [self.loadItem barBlock:^(CNBarButtonItem *barBItem) {
        NSLog(@"DownLoad Click channel：%@",self.currentChannel.englishName);
        if (barBItem.barState == CNBarItemStateDownLoad) {
            NSDictionary *dict = @{@"cid":weakSelf.currentChannel.englishName};
            [CNUtils reportInfo:dict widget:WIDGET_DOWNLOAD_CLICK Evt:evt_click];
            
            if ([CNHttpRequest shareHttpRequest].netStatus == AFNetworkReachabilityStatusReachableViaWiFi) {
                weakSelf.loadItem.barState = CNBarItemStateDownLoading;
                _DL.delegate = self;
                if (_DL.isLoading == NO) {
                    [_DL loadNewsZipFromChannel:weakSelf.currentChannel];
                }
            }else{
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"It may incur data charges, Will you continue?" message:nil preferredStyle:UIAlertControllerStyleAlert];
                [self presentViewController:alert animated:YES completion:nil];
                [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                    weakSelf.loadItem.barState = CNBarItemStateDownLoading;
                    _DL.delegate = self;
                    if (_DL.isLoading == NO) {
                        [_DL loadNewsZipFromChannel:weakSelf.currentChannel];
                    }
                }]];
                [alert addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    
                }]];
            }
        }else if (barBItem.barState == CNBarItemStateDownLoading){
            
        }else if (barBItem.barState == CNBarItemStateDownOver){
            
            weakSelf.loadItem.barState = CNBarItemStateDownLoad;
            NSLog(@"newsArr.count = %lu",(unsigned long)_DL.newsArr.count);
        }
        
    }];
    UIBarButtonItem *rightSpaceItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    rightSpaceItem.width =  iPhone6Plus? -15:-8;
    self.navigationItem.rightBarButtonItems = @[rightSpaceItem,self.loadItem];
    
    //
}

#pragma mark CNDataLoad  Delegate method
- (void)loadNewsProgress:(CGFloat)progress error:(NSError *)error over:(BOOL)over show:(NSString *)showStr{
    NSLog(@"progress --> %.4f", progress);
    self.loadItem.progress = progress;
    if (over && error == nil) {
        self.loadItem.barState = CNBarItemStateDownOver;
        CNDataLoad *_DL = [CNDataLoad shareDataLoad];
        if (_DL.newsArr) {
            if (_DL.newsDetailArray) {
                // TODO 处理刷新界面逻辑， 处理存储逻辑。
                NSLog(@"newsArr.count = %ld",_DL.newsArr.count);
                NSLog(@"details.count = %ld",_DL.newsDetailArray.count);
            }
        }
        if ([_DL.channel.englishName isEqualToString:self.currentChannel.englishName] || 1)
        {
            NSDictionary *info = @{notiSenter:NSStringFromClass([self class]),
                                   notiEvent: [NSNumber numberWithInteger:CNEventTypeNotiDownLoadNewsOver],
                                   @"channel":_DL.channel.englishName};
            [CNUtils postNotificationName:NOTI_NEWSDOWNLOAD_OVER object:nil userInfo:info];
        }
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.loadItem.barState = CNBarItemStateDownLoad;
            self.loadItem.progress = 0;
        });
    }else if (error){
        if (error.userInfo) {
            NSString *hintInfo = [error.userInfo objectForKey:@"NSLocalizedDescription"];
            NSLog(@"%@",hintInfo);
            if ([showStr isEqualToString:MSG_DOWNLOAD_FAILD]) {
                [self showHint:showStr hide:TIMER_HIDE_DELAY];
            }else{
                
            }
        }
        self.loadItem.barState = CNBarItemStateDownLoad;
        NSDictionary *dict = @{@"cid":self.currentChannel.englishName};
        [CNUtils reportInfo:dict widget:WIDGET_DOWNLOAD_FAIL Evt:evt_click];
    }else if(error == nil && over == NO){
        self.loadItem.progress = progress;
    }
}

- (void)configureNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeServerPost:) name:NOTI_CHANGESERVER_POST object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(eventWithNoti:) name:NOTI_USERLOGINSTATE_CHANGE object:nil];
}

- (void)eventWithNoti:(NSNotification *)noti {
    [[CNDataLoad shareDataLoad] loadCancel];
    self.loadItem.barState = CNBarItemStateDownLoad;
}


- (void)changeServerPost:(NSNotification *)noti {
//    NSNumber *serverMode = [CNDefult shareDefult].serverMode;
//    NSLog(@"serverMode = %@",serverMode);
    
    // TODO!  服务器切换，缓存数据源也需要进行切换。
//    方案 ，将原有所有缓存数据清零，重新使用新服务请求数据
//    [[CNDataManager shareDataController] clearNewsListBy:CNDBTableTypeNewsNormal];
//    [[CNDataManager shareDataController] clearNewsListBy:CNDBTableTypeNewsSaved];
    [[CNDataManager shareDataController] clearNewsListBy:CNDBTableTypeNewsChannel];
    [[CNDataManager shareDataController] clearNewsListBy:CNDBTableTypeNewsFaves];
    [[CNDataManager shareDataController] clearNewsDetailList];
    [self.newsCollectionView reloadData];
    
    // TODO 服务器切换的时候，终止所有的网络请求，
    self.loadItem.barState = CNBarItemStateDownLoad;
    [[CNHttpRequest shareHttpRequest] cancelAllOperations];
    [[CNDataLoad shareDataLoad] loadCancel];

}




@end
