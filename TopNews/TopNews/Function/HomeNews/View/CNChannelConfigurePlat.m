//
//  CNChannelConfigurePlat.m
//  TopNews
//
//  Created by xuewu.long on 16/10/18.
//  Copyright © 2016年 levt. All rights reserved.
//

#import "CNChannelConfigurePlat.h"
#import "CNChannelCell.h"
#import "CNDataManager.h"
#import "CNChannelSetBar.h"

@interface CNChannelConfigurePlat ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, assign) BOOL              isModified;
@property (nonatomic, assign) int               hiddenIndex;
@property (nonatomic, strong) UIView            *viewHeader;
@property (nonatomic, strong) UIView            *viewFooter;
@property (nonatomic, strong) UIView            *viewSectionHeader;
@property (nonatomic, strong) UIButton          *btnX;
@property (nonatomic, strong) UIButton          *btnEditing;
@property (nonatomic, strong) UIImageView       *imgvBackground;
@property (nonatomic, strong) UITableView       *tableView;
@property (nonatomic, strong) NSMutableArray    *arrChannels;

@property (nonatomic, strong) CNChannelSetBar   *choosedBar;

@end

@implementation CNChannelConfigurePlat

- (UIButton *)btnX{
    if (!_btnX) {
        _btnX = [UIButton buttonWithType:UIButtonTypeCustom];
        [_btnX setSize:CGSizeMake(40, 40)];
        //        [_btnX setBackgroundColor:[UIColor redColor]];
        [_btnX setImage:[UIImage imageNamed:@"btn_x"] forState:UIControlStateNormal];
        [_btnX setImageEdgeInsets:UIEdgeInsetsMake(13, 13, 13, 13)];
        [_btnX addTarget:self action:@selector(exitBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        _btnX.top   = 30 * kRATIO;
        _btnX.right = self.width - 5 * kRATIO;
    }
    return _btnX;
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


- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 60, self.width, self.height - 60) style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.backgroundColor = [UIColor clearColor];
    }
    return _tableView;
}

- (NSMutableArray *)arrChannels {
    if (!_arrChannels) {
        _arrChannels= [NSMutableArray array];
    }
    return _arrChannels;
}

- (UIView *)viewHeader {
    if (!_viewHeader) {
        _viewHeader = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, 5)];
    }
    return _viewHeader;
}

- (UIView *)viewFooter {
    if (!_viewFooter) {
        _viewFooter = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, 10)];
    }
    return _viewFooter;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.imgvBackground];
        [self addSubview:self.btnX];
        [self addSubview:self.tableView];
        self.tableView.tableHeaderView = self.viewHeader;
        self.tableView.tableFooterView = self.viewFooter;
        self.tableView.editing = YES;
        self.hiddenIndex    = 1;

        [self.tableView reloadData];
    }
    return self;
}


- (void)reloadChannelsData {
    NSArray *arrChannels  = [[CNDataManager shareDataController] getChannelAllByASC:YES];
    [self.arrChannels removeAllObjects];
    [self.arrChannels addObjectsFromArray:[arrChannels subarrayWithRange:NSMakeRange(self.hiddenIndex, arrChannels.count - self.hiddenIndex)]];
    
}




- (CNChannelSetPlatEvent)setPlatEventJudge {
    CNChannelSetPlatEvent event = CNChannelSetPlatEventNone;
    NSArray *originArr = [[CNDataManager shareDataController] getChannelAllByASC:YES];
    NSArray *modifyArr = [originArr subarrayWithRange:NSMakeRange(self.hiddenIndex, self.arrChannels.count)];
    for (int j = 0; j < modifyArr.count; j++) {
        CNChannel *temChannel = modifyArr[j];
        CNChannel *newChannel = self.arrChannels[j];
        if ([newChannel.channelState boolValue]) {
            newChannel.sortLoc = [NSNumber numberWithInt:j+self.hiddenIndex];
        }else{
            newChannel.sortLoc = [NSNumber numberWithInt:j+100+self.hiddenIndex];
        }
        if ([newChannel.englishName isEqualToString:temChannel.englishName]) {
            if ([newChannel.channelState boolValue] == [temChannel.channelState boolValue] == YES) {
                continue;
            }else{
                event = CNChannelSetPlatEventMemberChange;
            }
        }else{
            event = CNChannelSetPlatEventSortChange;
        }
    }
    if (event != CNChannelSetPlatEventNone) {
        [[CNDataManager shareDataController] clearChannelList];
        NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, self.hiddenIndex)];
        NSArray *holdArr = [originArr subarrayWithRange:NSMakeRange(0, self.hiddenIndex)];
        [self.arrChannels insertObjects:holdArr atIndexes:indexSet];
        [[CNDataManager shareDataController] addChannels:self.arrChannels];
    }
    return event;
}


- (void)exitBtnClick:(UIButton *)btn {
    __block CNChannelSetPlatEvent event = [self setPlatEventJudge];
    if (self.ChannelSetBlock)
    {
        self.ChannelSetBlock (event);
    }
}


#pragma mark - TableView DataSource & Delegate
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.arrChannels.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"channelSetCell";
    CNChannelCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[CNChannelCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    CNChannel *channel = self.arrChannels[indexPath.row];
    cell.channel = channel;
    return cell;
}


- (UIView *)viewSectionHeader {
    if (!_viewSectionHeader) {
        _viewSectionHeader = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, 40)];
        self.choosedBar     = [[CNChannelSetBar alloc] initWithFrame:CGRectMake(0, 5, self.width, 30)];
        self.choosedBar.barType = CNChannelSetBarTypeHeaderNoEditing;
        [_viewSectionHeader addSubview:self.choosedBar];
    }
    return _viewSectionHeader;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return self.viewSectionHeader.height;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return self.viewSectionHeader;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleNone;
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    [self.arrChannels exchangeObjectAtIndex:sourceIndexPath.row withObjectAtIndex:destinationIndexPath.row];
}



- (void)channelSet:(void (^)(CNChannelSetPlatEvent))thisBLock {
    self.ChannelSetBlock = thisBLock;
}

- (void)freshChannelState {
    [self reloadChannelsData];
    [self.tableView reloadData];
}

- (void)show {
    [self setHidden:NO];
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





/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
