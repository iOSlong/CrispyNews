//
//  CNChannelCell.h
//  TopNews
//
//  Created by xuewu.long on 16/10/18.
//  Copyright © 2016年 levt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CNChannel.h"

typedef void(^ChannelCellBlock)(CNChannel *channel);

@interface CNChannelCell : UITableViewCell

@property (nonatomic, strong) UIButton      *btnCheck;
@property (nonatomic, strong) UILabel       *labelTitile;
@property (nonatomic, strong) CNChannel     *channel;
@property (nonatomic, assign) ChannelCellBlock cellBlock;

- (void)cellBlock:(ChannelCellBlock)thisBlock;



@end
