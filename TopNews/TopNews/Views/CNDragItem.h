//
//  CNDragItem.h
//  DragLayout
//
//  Created by xuewu.long on 16/8/26.
//  Copyright © 2016年 letv. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, CNDragItemEvent) {
    CNDragItemEventDragBegan,
    CNDragItemEventDragEnd,
    CNDragItemEventDragCancel,
    CNDragItemEventLongPressBegan,
    CNDragItemEventLongPressEnd,
    
    CNDragItemEventPlatHeighChange,
    CNDragItemEventPlatSortChange,
    CNDragItemEventPlatTaped,
};

typedef void(^DragItemBlock)(CNDragItemEvent event);


@interface CNDragItem : UIButton
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, assign) BOOL dragble; // 处理拖拽效果，必须长按启动之后才能拖拽。
@property (nonatomic, strong) UILongPressGestureRecognizer *longPressG;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, assign) CGRect fixRect;


-(instancetype)initItemDefault;


- (void)dragEvent:(DragItemBlock)thisBlock;



@end
