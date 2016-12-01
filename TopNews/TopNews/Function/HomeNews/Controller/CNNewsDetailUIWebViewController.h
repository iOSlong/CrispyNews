//
//  CNNewsDetailUIWebViewController.h
//  TopNews
//
//  Created by xuewu.long on 16/10/9.
//  Copyright © 2016年 levt. All rights reserved.
//

#import "CNViewController.h"
#import "CNNews.h"
#import "CNChannel.h"
#import "CNNewsDetail.h"
#import "CNNewsDetailViewController.h"

typedef void(^DetailBlock)(NSDictionary *eventInfo);
@interface CNNewsDetailUIWebViewController : CNViewController

@property (nonatomic, strong) CNNews        *news;
@property (nonatomic, strong) NSString      *channelName;
@property (nonatomic, strong) CNNewsDetail  *newsDetail;
@property (nonatomic, strong) UIImage       *imgShare;
@property (nonatomic, copy)   DetailBlock    dBlock;
@property (nonatomic, strong) NSString      *newsFrom;
- (void)detailBlock:(DetailBlock)thisBlock;
@end
