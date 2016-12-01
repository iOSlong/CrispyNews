//
//  CNViewDragPlat.h
//  DragLayout
//
//  Created by xuewu.long on 16/8/26.
//  Copyright © 2016年 letv. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CNDragItem.h"




@interface CNViewDragPlat : UIView

@property (nonatomic, assign) BOOL canDrag;

- (void)loadItems:(NSMutableArray <CNDragItem *> *)dragItems;

- (void)dragEvent:(DragItemBlock)thisBlock;


@end
