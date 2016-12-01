//
//  CNChannelConfigurePlat.h
//  TopNews
//
//  Created by xuewu.long on 16/10/18.
//  Copyright © 2016年 levt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CNChannelSetPlat.h"

@interface CNChannelConfigurePlat : UIView


@property (nonatomic, copy) void(^ChannelSetBlock)(CNChannelSetPlatEvent event);
@property (nonatomic, copy) NSArray<NSString *> *arrSortRefer; // 参考数组，传入原有首页频道排序。
@property (nonatomic, strong) UIViewController *baseVC;


- (void)show;
- (void)hidden;
- (void)channelSet:(void(^)(CNChannelSetPlatEvent event))thisBLock;



@end
