//
//  CNChannelManager.m
//  CrispyNews
//
//  Created by xuewu.long on 16/8/22.
//  Copyright © 2016年 letv. All rights reserved.
//

#import "CNChannelManager.h"

@implementation CNChannelManager

+ (instancetype)shareChannelManager {
    static CNChannelManager *thisObj;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        thisObj = [[CNChannelManager alloc] init];
    });
    return thisObj;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _arrChannel         = [NSMutableArray array];
        _channelNewsArray   = [NSMutableArray array];
        _dataManager        = [CNDataManager shareDataController];
    }
    return self;
}


- (void)addChannel:(CNChannel *)channel {
    if (channel) {
        [_arrChannel addObject:channel];
        NSMutableArray *muArray = [NSMutableArray array];
        [_channelNewsArray addObject:muArray];
    }
}

- (void)addChannels:(NSArray<CNChannel *> *)channels {
    if (channels && channels.count) {
        for (CNChannel *channel in channels) {
            [self addChannel:channel];
        }
    }
}

- (void)insertChannel:(CNChannel *)channel atIndex:(NSInteger)index {
    if (channel && index <= self.arrChannel.count) {
        [_arrChannel insertObject:channel atIndex:index];
        NSMutableArray *muArray = [NSMutableArray array];
        [_channelNewsArray insertObject:muArray atIndex:index];
    }
}

- (void)removeAllChannel {
    [_arrChannel removeAllObjects];
    [_channelNewsArray removeAllObjects];
}

- (void)deleteChannelAtIndex:(NSInteger)index {
    if (_arrChannel.count > index) {
        [_arrChannel removeObjectAtIndex:index];
        [_channelNewsArray removeObjectAtIndex:index];
    }
}

- (void)deleteChannelAtRange:(NSRange)range {
    if (_arrChannel.count > range.location + range.length) {
        [_arrChannel removeObjectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:range]];
        [_channelNewsArray removeObjectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:range]];
    }
}

- (NSInteger)indexOfChannel:(NSString *)channelName {
    for (NSInteger i = 0; i < _arrChannel.count; i ++) {
        if ([channelName isEqualToString:_arrChannel[i].englishName]) {
            return i;
        }
    }
    return 0;
}


@end
