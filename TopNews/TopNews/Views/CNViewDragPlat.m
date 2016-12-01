//
//  CNViewDragPlat.m
//  DragLayout
//
//  Created by xuewu.long on 16/8/26.
//  Copyright © 2016年 letv. All rights reserved.
//

#import "CNViewDragPlat.h"

@interface CNViewDragPlat ()<UIGestureRecognizerDelegate>
@property (nonatomic, strong) CNDragItem *dragView;
@property (nonatomic, strong) NSMutableArray *itemArr;


@end
@implementation CNViewDragPlat{
    BOOL        _beginAnimation;
    CGRect      _dragRect;
    CGRect      _beganRect;
    DragItemBlock  _EBlock;
}

- (void)dragEvent:(DragItemBlock)thisBlock;
{
    _EBlock = thisBlock;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _itemArr = [NSMutableArray array];
        _canDrag = YES;
        [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapEvent:)]];
    }
    return self;
}

- (void)tapEvent:(UITapGestureRecognizer *)tapG {
    if (_EBlock && _canDrag) {
        // TODO, 是否考虑需要将拍击手势传递出去
//        _EBlock(CNDragItemEventPlatTaped);
    }
}

- (void)loadItems:(NSMutableArray<CNDragItem *> *)dragItems {
    self.itemArr = dragItems;
    
    for (UIView *subV in self.subviews) {
        [subV removeFromSuperview];
    }
    
    for (int i = 0; i < dragItems.count; i ++ ) {
        CNDragItem *item = dragItems[i];//   [[CNDragItem alloc] initItemDefault];
//        item.title = [NSString stringWithFormat:@"%@",item.title];
        [item dragEvent:^(CNDragItemEvent event) {
            if (event == CNDragItemEventLongPressBegan)
            {
                if (_EBlock) {
                    _EBlock(CNDragItemEventLongPressBegan);
                }
            }
            else if (event == CNDragItemEventLongPressEnd)
            {
                [UIView animateWithDuration:0.15f animations:^{
                    _dragView.frame = _dragRect;
                }];

                if (_EBlock) {
                    _EBlock(CNDragItemEventDragEnd);
                }
                if (CGRectEqualToRect(_dragRect, _beganRect)) {
                    NSLog(@"没有移动");
                }else{
                    if (_EBlock) {
                        _EBlock(CNDragItemEventPlatSortChange);
                    }
                }
            }
        }];

        // 滑动手势处理:
        for (UIGestureRecognizer *gr in item.gestureRecognizers) {
            if ([gr isKindOfClass:[UIPanGestureRecognizer class]]) {
                [item removeGestureRecognizer:gr];
            }
        }
        
        UIPanGestureRecognizer *panG = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(gesturePanEvent:)];
        panG.delegate = self;
        [item addGestureRecognizer:panG];
        
        
        [self addSubview:item];
        
    }
    [self freshFram];
}


- (void)gesturePanEvent:(UIPanGestureRecognizer *)panGesture {
    if (self.canDrag == NO) {
        return;
    }
    static CGPoint oriCenter;
    _dragView  = (CNDragItem *)panGesture.view;
    NSInteger fromIndex = [self.itemArr indexOfObject:_dragView];
    NSInteger desIndex = fromIndex;
    if (_dragView.dragble == NO) {
        return;
    }
    
    switch (panGesture.state) {
        case UIGestureRecognizerStateBegan:{
            NSLog(@"began ->");
            oriCenter   = panGesture.view.center;
            _dragRect   = _dragView.frame;
            _beganRect  = _dragRect;
            
            if (_EBlock) {
                _EBlock(CNDragItemEventDragBegan);
            }
        }
            break;
        case UIGestureRecognizerStateChanged:{
            CGPoint point = [panGesture translationInView:self];
            panGesture.view.center = CGPointMake(oriCenter.x + point.x, oriCenter.y + point.y);
//            NSLog(@"point = %@", NSStringFromCGPoint(point));
            
            CGPoint moP = [panGesture locationInView:self];
            
            CNDragItem *desItem = nil;
            
            for (CNDragItem *subV in self.itemArr)
            {
                if (subV != _dragView )
                {
                    CGRect subR = subV.frame;
                    if (CGRectContainsPoint(subR, moP))
                    {
                        desItem = subV;
                        desIndex = [self.itemArr indexOfObject:subV];
                        break;
                    }
                }
            }
            if (desItem != nil && _beginAnimation == NO)
            {
        
                [self scrollFrom:fromIndex to:desIndex inArr:self.itemArr];
                
                [UIView animateWithDuration:0.25f animations:^{
                    _beginAnimation = YES;
                    
                    [self freshFram];

                }completion:^(BOOL finished) {
                    _beginAnimation = NO;
                }];
            }
            
        }
            break;
        case UIGestureRecognizerStateEnded:{
            NSLog(@"ended ->");
            [UIView animateWithDuration:0.15f animations:^{
                _dragView.frame = _dragRect;
            }];
            
            if (_EBlock) {
                _EBlock(CNDragItemEventDragEnd);
            }
            if (CGRectEqualToRect(_dragRect, _beganRect)) {
                NSLog(@"没有移动");
            }else{
                if (_EBlock) {
                    _EBlock(CNDragItemEventPlatSortChange);
                }
            }
        }
            break;
        case UIGestureRecognizerStateCancelled: {
//            NSLog(@"canceled ->");
//            if (_EBlock) {
//                _EBlock(CNDragItemEventDragCancel);
//            }
        }
            break;
        default:
            break;
    }
}

- (void)freshFram {
    CGFloat span_in = 5 * kRATIO;
    CGFloat span_up = 5 * kRATIO;
    CGFloat van_x  = k_SpanLeft;
    CGFloat van_y   = 2 * kRATIO;
    CGFloat content_w = self.frame.size.width - 2 * k_SpanLeft;
    for (int i = 0; i < self.itemArr.count; i++) {
        CNDragItem *item = self.itemArr[i];
        if (item.frame.size.width + van_x > content_w) {
            van_y += span_up + item.frame.size.height;
            van_x = k_SpanLeft;
            if (item != _dragView) {
                item.frame = CGRectMake(van_x, van_y, item.frame.size.width, item.frame.size.height);
            }else{
                _dragRect = CGRectMake(van_x, van_y, item.frame.size.width, item.frame.size.height);
            }
            van_x += item.frame.size.width + span_in;
        }
        else
        {
            if (item != _dragView) {
                item.frame = CGRectMake(van_x, van_y, item.frame.size.width, item.frame.size.height);
            }else{
                _dragRect = CGRectMake(van_x, van_y, item.frame.size.width, item.frame.size.height);
            }
            van_x += item.frame.size.width + span_in;
        }
    }
    CGFloat newH = 100;
    if (van_x == k_SpanLeft) {
        newH = van_y + span_up;
        if (self.height != newH) {
            self.height = newH;
            if (_EBlock) {
                _EBlock(CNDragItemEventPlatHeighChange);
            }
        }
    }else{
        newH = van_y + [[self.itemArr lastObject] height] + span_up;
        if (self.height != newH) {
            self.height = newH;
            if (_EBlock) {
                _EBlock(CNDragItemEventPlatHeighChange);
            }
        }
    }
}

- (void)scrollFrom:(NSInteger)starIndex to:(NSInteger)desIndex inArr:(NSMutableArray *)muArr {
    NSInteger offSet = starIndex - desIndex < 0 ? 1 : -1;
    NSInteger stepALl = labs(desIndex - starIndex);
    for (NSInteger step = 0; step < stepALl; step ++) {
        [muArr exchangeObjectAtIndex:starIndex withObjectAtIndex:starIndex+offSet];
        starIndex += offSet;
    }
}

// 解决手势冲突，返回yes，使得CNDragItem的longPress 和 CNViewDragPlat的tapGesture手势共存。
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    return YES;
}



@end
