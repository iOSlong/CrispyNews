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
    UIImage *image  = [UIImage imageNamed:@"ic_back"];
    CGFloat img_W   = CGImageGetWidth(image.CGImage)/2;
    CGFloat img_H   = CGImageGetHeight(image.CGImage)/2;
    UIButton *menuButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 34, 34 * img_H/img_W)];
    [menuButton addTarget:self action:@selector(barItemEvent:) forControlEvents:UIControlEventTouchUpInside];
    [menuButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [menuButton setBackgroundImage:image forState:UIControlStateNormal];
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
