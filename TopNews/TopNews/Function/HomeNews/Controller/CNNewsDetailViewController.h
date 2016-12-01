//
//  CNNewsDetailViewController.h
//  CrispyNews
//
//  Created by xuewu.long on 16/8/9.
//  Copyright © 2016年 letv. All rights reserved.
//

#import "CNViewController.h"
#import "CNNews.h"
#import "CNChannel.h"
#import "CNNewsDetail.h"

static NSString *detailFromSavedList        = @"detailFromSavedList";
static NSString *detailFromChannelList      = @"detailFromChannelList";

typedef void(^DetailBlock)(NSDictionary *eventInfo);
@interface CNNewsDetailViewController : CNViewController

@property (nonatomic, strong) CNNews        *news;
@property (nonatomic, strong) NSString      *channelName;
@property (nonatomic, strong) CNNewsDetail  *newsDetail;
@property (nonatomic, strong) UIImage       *imgShare;
@property (nonatomic, copy)   DetailBlock     dBlock;
@property (nonatomic, strong) NSString      *newsFrom;
- (void)detailBlock:(DetailBlock)thisBlock;


@end



