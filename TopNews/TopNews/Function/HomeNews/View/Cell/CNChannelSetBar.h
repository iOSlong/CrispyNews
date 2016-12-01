//
//  CNChannelSetBar.h
//  CrispyNews
//
//  Created by xuewu.long on 16/8/29.
//  Copyright © 2016年 letv. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef NS_ENUM(NSUInteger, CNChannelSetBarType) {
    CNChannelSetBarTypeHeaderMyChannels,
    CNChannelSetBarTypeHeaderRecommended,
    CNChannelSetBarTypeHeaderNoEditing,
    CNChannelSetBarTypeFooter,
};

typedef NS_ENUM(NSUInteger, CNChannelSetBarState) {
    CNChannelSetBarStateEditing,
    CNChannelSetBarStateNormal,
};

typedef void(^ChannelSetBarBlock)(CNChannelSetBarState setState);

@interface CNChannelSetBar : UIView


@property (nonatomic, copy)   ChannelSetBarBlock channelSetBlock;
@property (nonatomic, assign) CNChannelSetBarState    setState;
@property (nonatomic, assign) CNChannelSetBarType     barType;
@property (nonatomic, strong) UILabel     *labelTitle;
@property (nonatomic, strong) UILabel     *labelDesc;
@property (nonatomic, strong) UIButton    *btnRight;

- (void)channelSetBar:(ChannelSetBarBlock)thisBlock;


@end
