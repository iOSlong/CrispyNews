//
//  CNTestInfoViewController.h
//  TopNews
//
//  Created by xuewu.long on 16/9/29.
//  Copyright © 2016年 levt. All rights reserved.
//

#import "CNViewController.h"
#import "CNNews.h"

@interface CNTestInfoViewController : CNViewController

@property (nonatomic, strong) NSString *newsId;
@property (nonatomic, strong) CNNews    *news;
@property (nonatomic, strong) NSString *deviceID;
@property (nonatomic, strong) NSString *apnsToken;


@end
