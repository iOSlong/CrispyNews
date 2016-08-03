//
//  CNBarButtonItem.m
//  CrispyNews
//
//  Created by xuewu.long on 16/8/3.
//  Copyright © 2016年 letv. All rights reserved.
//

#import "CNBarButtonItem.h"

@implementation CNBarButtonItem{
    BBIBlock _bbiBlock;
}


- (instancetype)barMenuButtomItem {
    UIButton *menuButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 40)];
    
    [menuButton addTarget:self action:@selector(barItemEvent:) forControlEvents:UIControlEventTouchUpInside];
    [menuButton setTitle:@"menu" forState:UIControlStateNormal];
    [menuButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [menuButton setBackgroundImage:[UIImage imageNamed:@"menuBarItem"] forState:UIControlStateNormal];
    return  [self initWithCustomView:menuButton];
}

- (instancetype)barButtomItem:(NSString *)title {
    UIButton *itemButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 40)];
    [itemButton addTarget:self action:@selector(barItemEvent:) forControlEvents:UIControlEventTouchUpInside];
    [itemButton setTitle:title forState:UIControlStateNormal];
    [itemButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    itemButton.size = [self sizeOfBtn:itemButton];
    return  [self initWithCustomView:itemButton];
}


- (CGSize)sizeOfBtn:(UIButton *)btn
{
    CGSize sizeBtn = [btn.titleLabel sizeThatFits:CGSizeMake(100,30)];
    CGSize sizeReal    = CGSizeMake(sizeBtn.width + 10, 40);
    CGSize minSize     = CGSizeMake(40, 40);
    CGSize lastSize    = sizeBtn.width + 10  > 40 ? sizeReal : minSize;
    return lastSize;
}


- (void)barItemEvent:(UIButton *)btn {
    if (_bbiBlock) {
        _bbiBlock(self);
    }
}

- (void)barBlock:(BBIBlock)thisBlock {
    _bbiBlock = thisBlock;
}

@end
