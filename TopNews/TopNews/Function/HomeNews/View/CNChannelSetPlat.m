//
//  CNChannelSetPlat.m
//  CrispyNews
//
//  Created by xuewu.long on 16/8/29.
//  Copyright © 2016年 letv. All rights reserved.
//

#import "CNChannelSetPlat.h"
#import "CNViewDragPlat.h"
#import "CNChannelSetBar.h"
#import "CNChannelSetItemView.h"
#import "CNChannelManager.h"



@interface CNChannelSetPlat ()
@property (nonatomic, strong) UIButton *btnX;
@property (nonatomic, strong) UIImageView *imgvBackground;
@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) CNChannelSetBar   *choosedBar;
@property (nonatomic, strong) CNViewDragPlat    *choosedPlat;
@property (nonatomic, strong) CNChannelSetBar   *recommendBar;
@property (nonatomic, strong) CNViewDragPlat    *recommendPlat;

@property (nonatomic, strong) NSMutableArray<CNChannel *> *channelsChoosed;
@property (nonatomic, strong) NSMutableArray<CNChannel *> *channelsRecomented;

@property (nonatomic, strong) NSMutableArray<CNDragItem *> *choosedDragItems;
@property (nonatomic, strong) NSMutableArray<CNDragItem *> *recommentedDragItems;

@property (nonatomic, assign) BOOL isCellShouldShake;
@end

@implementation CNChannelSetPlat {
    BOOL _stateChangeChoosed;
    BOOL _stateChangeRecommend;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self reloadData];
        
        [self loadViews];
        
        [self freshPlatMembers];
    }
    return self;
}
- (UIImageView *)imgvBackground {
    if (!_imgvBackground) {
        _imgvBackground = [[UIImageView alloc] initWithFrame:self.bounds];
        [_imgvBackground setImage:[UIImage imageNamed:@"channelMask"]];
        _imgvBackground.backgroundColor = RGBACOLOR_HEX(0xffffff, 0.65);
        //        _imgvBackground.alpha = 0.8;
    }
    return _imgvBackground;
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    }
    return _scrollView;
}

- (UIButton *)btnX{
    if (!_btnX) {
        _btnX = [UIButton buttonWithType:UIButtonTypeCustom];
        [_btnX setSize:CGSizeMake(40, 40)];
        //        [_btnX setBackgroundColor:[UIColor redColor]];
        [_btnX setImage:[UIImage imageNamed:@"btn_alphaX"] forState:UIControlStateNormal];
        [_btnX setImageEdgeInsets:UIEdgeInsetsMake(13, 13, 13, 13)];
        [_btnX addTarget:self action:@selector(alphaXBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        _btnX.top   = 25 * kRATIO;
        _btnX.right = self.width - 5 * kRATIO;
    }
    return _btnX;
}
- (void)alphaXBtnClick:(UIButton *)btn {
    __block CNChannelSetPlatEvent event = [self setPlatEventJudge];
    if (self.isCellShouldShake == YES)
    {
        if (event != CNChannelSetPlatEventNone)
        {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Do you want to save the Settings ？" message:@"" preferredStyle:UIAlertControllerStyleAlert];
            [self.baseVC presentViewController:alert animated:YES completion:nil];
            [alert addAction:[UIAlertAction actionWithTitle:@"Save" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
                [self editingSave];
                
                if (self.ChannelSetBlock)
                {
                    self.ChannelSetBlock (event);
                }
            }]];
            [alert addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
               
                [self editingCancel];
                
                if (self.ChannelSetBlock)
                {
                    self.ChannelSetBlock (event);
                }
            }]];
        }
    }
    else
    {
        if (event != CNChannelSetPlatEventNone)
        {
            [self editingSave];
        }
        
        if (self.ChannelSetBlock)
        {
            self.ChannelSetBlock (event);
        }
    }
    
}

- (void)channelSet:(void (^)(CNChannelSetPlatEvent))thisBLock {
    self.ChannelSetBlock = thisBLock;
}

- (void)configureHeaderBar {
    [self.scrollView addSubview:self.btnX];
}




- (void)configureChannelChoosed {
    weakSelf();
    self.choosedBar     = [[CNChannelSetBar alloc] initWithFrame:CGRectMake(0, 60, self.width, 30)];
    self.choosedBar.barType = CNChannelSetBarTypeHeaderMyChannels;
    [self.choosedBar channelSetBar:^(CNChannelSetBarState setState) {
        NSLog(@"editing btn click - >");
        if (setState == CNChannelSetBarStateEditing) {
            weakSelf.isCellShouldShake      = YES;
            weakSelf.choosedPlat.canDrag    = YES;
        }else{
            weakSelf.isCellShouldShake      = NO;
            weakSelf.choosedPlat.canDrag    = NO;
        }
        [self freshChannelState];
    }];
    [self.scrollView addSubview:self.choosedBar];
    
    NSMutableArray <CNDragItem *>*muArr = [NSMutableArray array];
    self.choosedDragItems =  muArr;
    for ( int i = 0 ; i < self.channelsChoosed.count ; i ++ ) {
        CNChannel *channel = [self.channelsChoosed objectAtIndex:i];
        CNChannelSetItemView *itemV = [[CNChannelSetItemView alloc] initWithChannel:channel];
        itemV.themeState = CNThemeItemStateChannelsNormal;
        [itemV themeCellBlock:^(CNThemeEvent themeEvent) {
            if (themeEvent == CNThemeEventDelete)
            {
                
                [weakSelf moveChoosed:itemV toRecommentedAtIndex:0];
                
            }
            else if (themeEvent == CNThemeEventItemClick)
            {
                if (itemV.themeState == CNThemeItemStateRecommended)
                {
                    
                    [weakSelf moveRecommented:itemV toChoosedAtIndex:0];
                    
                }
                else if (itemV.themeState == CNThemeItemStateChannelsNormal)
                {
                    
                }
            }
        }];
        
        [muArr addObject:itemV];
    }
    
    self.choosedPlat    = [[CNViewDragPlat alloc] initWithFrame:CGRectMake(0, self.choosedBar.bottom, self.width, 100)];
    self.choosedPlat.canDrag = NO;
    [self.choosedPlat dragEvent:^(CNDragItemEvent event) {
        if (event == CNDragItemEventPlatHeighChange)
        {
            weakSelf.recommendBar.top = weakSelf.choosedPlat.bottom + 20;
            weakSelf.recommendPlat.top = weakSelf.recommendBar.bottom;
            [weakSelf.scrollView setContentSize:CGSizeMake(weakSelf.width, weakSelf.recommendPlat.bottom > weakSelf.height ?weakSelf.recommendPlat.bottom : weakSelf.height)];
        }
        else if (event == CNDragItemEventPlatSortChange)
        {
            // 以muArr 作为新顺序参考， 调整 Sort 顺序调整。
            for (int i = 0 ; i < muArr.count; i ++)
            {
                NSString *title = muArr[i].title;
                for (int j = 0; j < weakSelf.channelsChoosed.count; j ++)
                {
                    CNChannel *channelF = weakSelf.channelsChoosed[j];
                    if ([title isEqualToString:channelF.englishName])
                    {
                        CNChannel *channelS = weakSelf.channelsChoosed[i];
                        NSNumber *tempNum   = channelF.sortLoc;
                        channelF.sortLoc    = channelS.sortLoc;
                        channelS.sortLoc    = tempNum;
                        
                        [weakSelf.channelsChoosed exchangeObjectAtIndex:i withObjectAtIndex:j];
                        
                        // 直接调整数据源
                        //                        CNChannelManager *channelManager = [CNChannelManager shareChannelManager];
                        //                        [channelManager.arrChannel exchangeObjectAtIndex:i withObjectAtIndex:j];
                        //                        [channelManager.channelNewsArray exchangeObjectAtIndex:i withObjectAtIndex:j];
                        
                        break;
                    }
                }
            }
            // 更新存储新的channel_list 顺序。
            //            [[CNDataManager shareDataController] clearChannel_StateOn:YES];
            //            [[CNDataManager shareDataController] addChannels:weakSelf.channelsChoosed];
            _stateChangeChoosed = YES;
        }
        /// 长按已选中常态 频道 按钮，出发编辑状态。
        else if (event == CNDragItemEventLongPressBegan)
        {
            if (weakSelf.isCellShouldShake == NO)
            {
                weakSelf.isCellShouldShake      = YES;
                weakSelf.choosedPlat.canDrag    = YES;
                [weakSelf freshChannelState];
            }
        }
        else if (event == CNDragItemEventPlatTaped)
        {
            if (weakSelf.isCellShouldShake == YES) {
                weakSelf.isCellShouldShake      = NO;
                weakSelf.choosedPlat.canDrag    = NO;
                [weakSelf freshChannelState];
            }
        }
    }];
    //    self.choosedPlat.backgroundColor = [UIColor yellowColor];
//    [self.choosedPlat loadItems:_choosedDragItems];
    [self.scrollView addSubview:self.choosedPlat];
    
}



- (void)configureChannelRecommend {
    self.recommendBar       = [[CNChannelSetBar alloc] initWithFrame:CGRectMake(0, self.choosedPlat.bottom + 20, self.width, 30)];
    self.recommendBar.barType = CNChannelSetBarTypeHeaderRecommended;
    [self.scrollView addSubview:self.recommendBar];
    
    weakSelf();
    self.recommendPlat = [[CNViewDragPlat alloc] initWithFrame:CGRectMake(0, self.recommendPlat.bottom, self.width, 100)];
    self.recommendPlat.canDrag = NO;
    NSMutableArray <CNDragItem *>*muArr = [NSMutableArray array];
    self.recommentedDragItems = muArr;
    for ( int i = 0 ; i < self.channelsRecomented.count ; i ++ )
    {
        CNChannelSetItemView *itemV = [[CNChannelSetItemView alloc] initWithChannel:[self.channelsRecomented objectAtIndex:i]];
        itemV.themeState = CNThemeItemStateRecommended;
        [itemV themeCellBlock:^(CNThemeEvent themeEvent) {
            if (themeEvent == CNThemeEventDelete)
            {
                
                [weakSelf moveChoosed:itemV toRecommentedAtIndex:0];
                
            }
            else if (themeEvent == CNThemeEventItemClick)
            {
                if (itemV.themeState == CNThemeItemStateRecommended)
                {
                    
                    [weakSelf moveRecommented:itemV toChoosedAtIndex:0];
                    
                }
                else if (itemV.themeState == CNThemeItemStateChannelsNormal)
                {
                    
                }
            }
        }];
        [muArr addObject:itemV];
    }
    
    [self.recommendPlat dragEvent:^(CNDragItemEvent event) {
        if (event == CNDragItemEventPlatHeighChange)
        {
            weakSelf.recommendBar.top = weakSelf.choosedPlat.bottom + 20;
            weakSelf.recommendPlat.top = weakSelf.recommendBar.bottom;
            [weakSelf.scrollView setContentSize:CGSizeMake(weakSelf.width, weakSelf.recommendPlat.bottom > weakSelf.height ?weakSelf.recommendPlat.bottom : weakSelf.height)];
        }
    }];
    [self.scrollView addSubview:self.recommendPlat];
}


- (void)loadViews {
    [self addSubview:self.imgvBackground];
    [self addSubview:self.scrollView];
    [self configureHeaderBar];
    [self configureChannelChoosed];
    [self configureChannelRecommend];
}


- (void)reloadData {
    if (!_channelsRecomented) {
        _channelsRecomented = [NSMutableArray array];
    }
    if (!_channelsChoosed) {
        _channelsChoosed = [NSMutableArray array];
    }
    [_channelsChoosed removeAllObjects];
    [_channelsRecomented removeAllObjects];
    
    
    NSArray *arrChannel     = [[CNDataManager shareDataController] getChannelAllByASC_StateOn:YES];
    NSArray *arrRecommend   = [[CNDataManager shareDataController] getChannelAllByASC_StateOn:NO];
    [_channelsChoosed addObjectsFromArray:arrChannel];
    [_channelsRecomented addObjectsFromArray:arrRecommend];
}




- (CNChannelSetPlatEvent)setPlatEventJudge {
    CNChannelSetPlatEvent event = CNChannelSetPlatEventNone;
    
    if (self.arrSortRefer.count == self.channelsChoosed.count)
    {
        for (int i = 0; i < self.arrSortRefer.count; i++)
        {
            NSString *refer = self.arrSortRefer[i];
            for (int j = 0; j < self.channelsChoosed.count; j++)
            {
                if (![refer isEqualToString:self.channelsChoosed[i].englishName])
                {
                    event = CNChannelSetPlatEventSortChange;
                    break;
                }
            }
            
            if (event == CNChannelSetPlatEventSortChange)
            {
                NSInteger containT = 0;
                for (int k = 0; k < self.arrSortRefer.count; k ++)
                {
                    NSString *temp  = self.arrSortRefer[k];
                    for (int l = 0; l < self.channelsChoosed.count; l ++)
                    {
                        NSString *channelName = self.channelsChoosed[l].englishName;
                        if ([temp isEqualToString:channelName])
                        {
                            containT ++ ;
                            break;
                        }
                    }
                }
                if (containT < self.arrSortRefer.count) {
                    event = CNChannelSetPlatEventMemberChange;
                }
                break;
            }
        }
    }
    else
    {
        event = CNChannelSetPlatEventMemberChange;
    }
    return event;
}

- (void)editingSave {
    for (int i = 0; i < self.channelsChoosed.count; i ++)
    {
        self.channelsChoosed[i].sortLoc = [NSNumber numberWithInteger:i];
        self.channelsChoosed[i].channelState = @1;
    }
    [[CNDataManager shareDataController] clearChannel_StateOn:YES];
    [[CNDataManager shareDataController] addChannels:self.channelsChoosed];
    
    for (int j = 0; j < self.channelsRecomented.count; j ++)
    {
        self.channelsRecomented[j].sortLoc = [NSNumber numberWithInteger:j];
        self.channelsRecomented[j].channelState = @0;
    }
    [[CNDataManager shareDataController] clearChannel_StateOn:NO];
    [[CNDataManager shareDataController] addChannels:self.channelsRecomented];
    
}

- (void)editingCancel {
    [self reloadData];
    [self freshPlatMembers];
}





- (void)moveChoosed:(CNChannelSetItemView *)itemView toRecommentedAtIndex:(NSInteger)index {
    NSInteger delLoc = [self.choosedDragItems indexOfObject:itemView];
    NSLog(@"delete channel :%@ inLocation:%ld",itemView.channel.englishName,delLoc);
    
    [self.recommentedDragItems addObject:itemView];
    [self.choosedDragItems removeObjectAtIndex:delLoc];
    
    [self.channelsRecomented addObject:itemView.channel];
    [self.channelsChoosed removeObjectAtIndex:delLoc];
    
    itemView.themeState = CNThemeItemStateRecommended;
    
    [self freshPlatMembers];
    
}

- (void)moveRecommented:(CNChannelSetItemView *)itemView toChoosedAtIndex:(NSInteger)index {
    if (self.isCellShouldShake == NO) {
        return;    
    }
    NSInteger delLoc = [self.recommentedDragItems indexOfObject:itemView];
    NSLog(@"choose channel :%@ inLocation:%ld",itemView.channel.englishName,delLoc);
    
    [self.choosedDragItems addObject:itemView];
    [self.recommentedDragItems removeObjectAtIndex:delLoc];
    
    [self.channelsChoosed addObject:itemView.channel];
    [self.channelsRecomented removeObjectAtIndex:delLoc];
    
    
    itemView.themeState = CNThemeItemStateDelete;
    
    //    channel.channelState = @1;
    //    // TODO! 界面退出的时候，重置 channel.sortLoc. 进行重存储
    //    //数据库保存编辑设置
    //    [[CNDataManager shareDataController] insertChannel:channel];
    
    [self freshPlatMembers];
    
}

- (void)freshPlatMembers{
    [self.choosedPlat loadItems:_choosedDragItems];
    [self.recommendPlat loadItems:_recommentedDragItems];
}

- (void)freshChannelState {
    if (self.isCellShouldShake == NO) {
        self.choosedBar.setState = CNChannelSetBarStateNormal;
        for (CNChannelSetItemView *setItem in self.choosedDragItems) {
            setItem.themeState = CNThemeItemStateChannelsNormal;
        }
    }else{
        self.choosedBar.setState = CNChannelSetBarStateEditing;
        for (CNChannelSetItemView *setItem in self.choosedDragItems) {
            setItem.themeState = CNThemeItemStateDelete;
        }
    }
}




- (void)show {
    [self setHidden:NO];
    _stateChangeChoosed = NO;
    self.isCellShouldShake = NO;
    [self freshChannelState];
    [UIView animateWithDuration:.5f animations:^{
        self.top = 0;
        self.alpha = 1;
    }];
}

- (void)hidden {
    [UIView animateWithDuration:0.5f animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        self.top = - self.height;
        [self setHidden:YES];
    }];
}

@end
