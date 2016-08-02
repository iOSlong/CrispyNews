//
//  CNSegmentView.h
//  CNMenuDemo
//
//  Created by xuewu.long on 16/8/1.
//  Copyright © 2016年 letv. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface CNSegmentBtn : UIButton

@property (nonatomic, strong) NSValue *valueRect;
@property (nonatomic, assign) CGFloat realW;

- (void)reloadFrame;


@end



//===

typedef void(^CNSegmentBlock)(NSInteger selectedIndex);

@interface CNSegmentView : UIScrollView

@property (nonatomic, strong) NSArray *arrItem;
@property (nonatomic, strong) UIColor *colorSelected;
@property (nonatomic, strong) UIColor *colorNormal;
@property (nonatomic, strong) UIColor *colorHighlight;
@property (nonatomic, assign) NSInteger selectedIndex;

- (void)cn_segBlock:(CNSegmentBlock )thisBlock;
- (void)insertItem:(NSString *)item atIndex:(NSInteger)index;
- (void)addItems:(NSArray *)items;


@end
