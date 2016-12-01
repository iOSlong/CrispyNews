//
//  CNNewsCollectionView.m
//  CrispyNews
//
//  Created by 陈肖坤 on 16/8/17.
//  Copyright © 2016年 letv. All rights reserved.
//

#import "CNNewsCollectionView.h"

#define newsViewCell @"CNNewsViewCell"

@interface CNNewsCollectionView ()


@end

@implementation CNNewsCollectionView

- (instancetype)initWithFrame:(CGRect)frame
{
    
    UICollectionViewFlowLayout *_layout = [[UICollectionViewFlowLayout alloc] init];
    //注意：如果是Vertical的则cell是水平布局排列，如果是Horizontal则cell是垂直布局排列 （这个就叫做流式布局）
    _layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    //设置每一个item的大小
    _layout.itemSize     = CGSizeMake(frame.size.width,frame.size.height);
    //设置分区的EdgeInset
    //        _layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    
    _layout.minimumLineSpacing = 0;
    
    _layout.minimumInteritemSpacing = 0;
    return [self initWithFrame:frame collectionViewLayout:_layout];
}

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout {
    self = [super initWithFrame:frame collectionViewLayout:layout];
    if (self) {
        
    }
    return self;
}


- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if ([self panBack:gestureRecognizer]) {
        return NO;
        
    }
    return YES;
}

- (BOOL)panBack:(UIGestureRecognizer *)gestureRecognizer {
    if (gestureRecognizer == self.panGestureRecognizer) {
        UIPanGestureRecognizer *pan = (UIPanGestureRecognizer *)gestureRecognizer;
        CGPoint point = [pan translationInView:self];
        NSLog(@"point x = %f",point.x);
        
        UIGestureRecognizerState state = gestureRecognizer.state;
        if (UIGestureRecognizerStateBegan == state || UIGestureRecognizerStatePossible == state) {
            CGPoint location = [gestureRecognizer locationInView:self];
            if (point.x > 0 && location.x < self.bounds.size.width/2 && self.contentOffset.x <= 0) {
                return YES;
            }
        }
    }
    return NO;
}



@end




