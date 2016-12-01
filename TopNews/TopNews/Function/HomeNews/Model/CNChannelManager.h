//
//  CNChannelManager.h
//  CrispyNews
//
//  Created by xuewu.long on 16/8/22.
//  Copyright © 2016年 letv. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CNChannel.h"
#import "CNNews.h"
#import "CNDataManager.h"


@interface CNChannelManager : NSObject

+ (instancetype)shareChannelManager;

@property (nonatomic, strong, readonly) NSMutableArray  <CNChannel *> *arrChannel;
@property (nonatomic, strong, readonly) NSMutableArray  <NSMutableArray<CNNews *> *> *channelNewsArray;
@property (nonatomic, strong, readonly) CNDataManager   *dataManager;


- (void)addChannel:(CNChannel *)channel;
- (void)addChannels:(NSArray <CNChannel *> *)channels;
- (void)insertChannel:(CNChannel *)channel atIndex:(NSInteger)index;
- (void)removeAllChannel;
- (void)deleteChannelAtIndex:(NSInteger)index;
- (void)deleteChannelAtRange:(NSRange)range;
- (NSInteger)indexOfChannel:(NSString *)channelName;


@end
