//
//  CNCollectionViewCell.m
//  CrispyNews
//
//  Created by 陈肖坤 on 16/8/3.
//  Copyright © 2016年 陈肖坤. All rights reserved.
//

#import "CNContentCollectionViewCell.h"
#import "CNContentTableView.h"

@interface CNContentCollectionViewCell ()

@property (nonatomic, strong) CNContentTableView *contentTableView;

@end

@implementation CNContentCollectionViewCell


- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        
        self.backgroundColor = RandomColor;
        
        CNContentTableView *contentTableView = [[CNContentTableView alloc] initWithFrame:self.bounds];
        
        [self.contentView addSubview:contentTableView];
        
        self.contentTableView = contentTableView;
        
    }
    
    return self;
}



@end
