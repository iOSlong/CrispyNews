//
//  CNBarButtonItem.h
//  CrispyNews
//
//  Created by xuewu.long on 16/8/3.
//  Copyright © 2016年 letv. All rights reserved.
//

#import <UIKit/UIKit.h>


@class CNBarButtonItem;

typedef void(^BBIBlock)(CNBarButtonItem *barBItem);

@interface CNBarButtonItem : UIBarButtonItem


- (instancetype)barMenuButtomItem;


- (void)barBlock:(BBIBlock )thisBlock;



@end
