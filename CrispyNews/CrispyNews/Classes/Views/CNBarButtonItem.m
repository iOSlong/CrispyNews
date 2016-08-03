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


- (void)barItemEvent:(UIButton *)btn {
    if (_bbiBlock) {
        _bbiBlock(self);
    }
}

- (void)barBlock:(BBIBlock)thisBlock {
    _bbiBlock = thisBlock;
}

@end
