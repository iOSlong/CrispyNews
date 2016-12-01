//
//  CNChannelSetItemView.h
//  CrispyNews
//
//  Created by xuewu.long on 16/8/29.
//  Copyright © 2016年 letv. All rights reserved.
//

#import "CNDragItem.h"
#import "CNChannel.h"

typedef NS_ENUM(NSUInteger, CNThemeItemState) {
    CNThemeItemStateDelete,         // 删除状态
    CNThemeItemStateChannelsNormal, // 选中频道正常状态
    CNThemeItemStateRecommended,    // 推荐频道状态
};

typedef NS_ENUM(NSUInteger, CNThemeEvent) {
    CNThemeEventItemClick,
    CNThemeEventLongPress,
    CNThemeEventDelete,
};

typedef void(^ThemeItemBlock)(CNThemeEvent themeEvent);



@interface CNChannelSetItemView : CNDragItem

@property (nonatomic, strong, readonly) CNChannel *channel;
@property (nonatomic, assign) CNThemeItemState themeState;
@property (nonatomic, copy) ThemeItemBlock TCBlock;

- (instancetype)initWithChannel:(CNChannel *)channel;


- (void)themeCellBlock:(ThemeItemBlock)thisBlock;
- (void)startShake;
- (void)stopShake;
CGFloat channelSetItemHeigh();


@end
