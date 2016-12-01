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
typedef NS_ENUM(NSUInteger, CNBarItemState) {
    CNBarItemStateDownLoad,
    CNBarItemStateDownLoading,
    CNBarItemStateDownOver,
    CNBarItemStateBack,
    CNBarItemStateNormal,
    CNBarItemStateEdit,
    CNBarItemStateCancel,
};

@interface CNBarButtonItem : UIBarButtonItem


- (instancetype)barMenuButtomItem;

- (instancetype)barButtomItem:(NSString *)title;

- (instancetype)barLoadButtomItem;



- (void)barBlock:(BBIBlock )thisBlock;

@property (nonatomic, assign) CNBarItemState barState;
@property (nonatomic, assign) CGFloat progress;



@end
