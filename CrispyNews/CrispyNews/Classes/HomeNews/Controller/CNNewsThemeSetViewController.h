//
//  CNNewsThemeSetViewController.h
//  CrispyNews
//
//  Created by xuewu.long on 16/8/3.
//  Copyright © 2016年 letv. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CNDataManager.h"

@interface CNNewsThemeSetViewController : UIViewController

@property (nonatomic, strong) NSMutableArray<CNTheme *> *muArrChannelTheme;
@property (nonatomic, strong) NSMutableArray<CNTheme *> *muArrRecommend;

@end
