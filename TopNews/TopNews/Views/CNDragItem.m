//
//  CNDragItem.m
//  DragLayout
//
//  Created by xuewu.long on 16/8/26.
//  Copyright © 2016年 letv. All rights reserved.
//

#import "CNDragItem.h"




#pragma mark - CNDragItem


@interface CNDragItem ()
@property (nonatomic, strong) UILabel *labelTitle;
@end

@implementation CNDragItem {
    DragItemBlock _DIBlock;
}

- (void)dragEvent:(DragItemBlock)thisBlock {
    _DIBlock = thisBlock;
}

+ (CGFloat)heigh {
    return 30;
}


- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    self.contentView.frame  = self.bounds;
    self.labelTitle.frame   = self.bounds;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        self.contentView = [[UIView alloc] initWithFrame:self.bounds];
        [self addSubview:self.contentView];
        
        self.frame = CGRectMake(0, 0, 40 + arc4random()%50, [CNDragItem heigh]);
        UILongPressGestureRecognizer *longPressG = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(gestureEvent:)];
        [self addGestureRecognizer:longPressG];
        self.longPressG = longPressG;
        
        _labelTitle = [[UILabel alloc] initWithFrame:self.bounds];
        [_labelTitle setTextAlignment: NSTextAlignmentCenter];
        [self.contentView addSubview:_labelTitle];
        
//        self.backgroundColor = [UIColor colorWithWhite:arc4random()%255/255.0 + 0.2 alpha:arc4random()%255/255.0+0.2];
    }
    return self;
}


- (instancetype)initItemDefault {
    self = [self init];
    if (self) {

    }
    return self;
}

- (void)setTitle:(NSString *)title {
    _title = title;
//    [_labelTitle setText:title];
}

- (void)gestureEvent:(UILongPressGestureRecognizer *)longG {
    switch (longG.state) {
        case UIGestureRecognizerStateBegan:
        {
            self.dragble = YES;
            if (_DIBlock)
            {
                _DIBlock(CNDragItemEventLongPressBegan);
            }
        }
            break;
        case UIGestureRecognizerStateEnded:
        {
            self.dragble = NO;
            if (_DIBlock)
            {
                _DIBlock(CNDragItemEventLongPressEnd);
            }
        }
            break;
        default:
            break;
    }
}

@end
