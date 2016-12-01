//
//  CNChannelSetPlat.h
//  CrispyNews
//
//  Created by xuewu.long on 16/8/29.
//  Copyright © 2016年 letv. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CNChannelSetItemView.h"


typedef NS_ENUM(NSUInteger, CNChannelSetPlatEvent) {
    CNChannelSetPlatEventNone,
    CNChannelSetPlatEventSortChange,
    CNChannelSetPlatEventMemberChange,
};

@interface CNChannelSetPlat : UIView


@property (nonatomic, copy) void(^ChannelSetBlock)(CNChannelSetPlatEvent event);
@property (nonatomic, copy) NSArray<NSString *> *arrSortRefer; // 参考数组，传入原有首页频道排序。
@property (nonatomic, strong) UIViewController *baseVC;

- (void)show;
- (void)hidden;
- (void)reloadData;
- (void)channelSet:(void(^)(CNChannelSetPlatEvent event))thisBLock;

@end
