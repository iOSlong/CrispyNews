//
//  CNCollectionView.m
//  CrispyNews
//
//  Created by 陈肖坤 on 16/8/3.
//  Copyright © 2016年 陈肖坤. All rights reserved.
//

#import "CNContentCollectionView.h"
#import "CNContentCollectionViewCell.h"


#define contentView @"CNContentCollectionViewCell"

@interface CNContentCollectionView ()<UICollectionViewDataSource>

@property (nonatomic, strong) NSMutableArray *channel;

@end


@implementation CNContentCollectionView

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout
{
    if (self = [super initWithFrame:frame collectionViewLayout:layout]) {
    
    self.showsHorizontalScrollIndicator = NO;
    
    self.backgroundColor = RGB(250, 250, 250);
    
    self.pagingEnabled = YES;
    
    self.dataSource = self;
    
    [self registerClass:[CNContentCollectionViewCell class] forCellWithReuseIdentifier:contentView];
    }
    return self;
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.frame = CGRectMake(0, 108, SCREENW, SCREENH - 108);
    
    
}


#pragma CollectionView 的数据源
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 20;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CNContentCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:contentView forIndexPath:indexPath];
    
    
    return cell;
}



- (NSMutableArray *)channel
{
    if (!_channel) {
        _channel = [NSMutableArray array];
    }
    return _channel;
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
            if (point.x > 0 && location.x < self.bounds.size.width && self.contentOffset.x <= 0) {
                return YES;
                
            }
        }
    }
    return NO;
}

@end
