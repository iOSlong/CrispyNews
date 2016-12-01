//
//  CNNewsViewCell.h
//  CrispyNews
//
//  Created by 陈肖坤 on 16/8/17.
//  Copyright © 2016年 letv. All rights reserved.
//

#import "CNCollectionViewCell.h"
#import "CNChannelManager.h"


typedef NS_ENUM(NSUInteger, CNPageCellEvent) {
    CNPageCellEventNewsListClick,
    CNPageCellEventNetWorkFinish,
    CNPageCellEventNewsLongPress,
    CNPageCellEventNone,
};
typedef void(^PageCellBlock)(CNPageCellEvent event, CNNews *news, NSIndexPath *indexPath);

@interface CNNewsCollectionCell : CNCollectionViewCell


@property (nonatomic, strong) UILabel *labelIndex;
@property (nonatomic, strong) CNChannel *channel;// 频道

- (void)cellPage:(PageCellBlock)thislock;

@end

