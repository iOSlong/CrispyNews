//
//  CNRefreshNormalHeader.m
//  TopNews
//
//  Created by xuewu.long on 16/9/14.
//  Copyright © 2016年 levt. All rights reserved.
//

#import "CNRefreshNormalHeader.h"

@implementation CNRefreshNormalHeader

#pragma mark - 重写父类的方法
- (void)prepare
{
    [super prepare];

    self.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    
    // 初始化文字
    [self setTitle:@"Pull down to refresh" forState:MJRefreshStateIdle];
    [self setTitle:@"Release to refresh" forState:MJRefreshStatePulling];
    [self setTitle:@"Loading..." forState:MJRefreshStateRefreshing];
}


@end
