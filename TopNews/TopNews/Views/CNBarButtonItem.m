
//
//  CNBarButtonItem.m
//  CrispyNews
//
//  Created by xuewu.long on 16/8/3.
//  Copyright © 2016年 letv. All rights reserved.
//

#import "CNBarButtonItem.h"
#import "CNBezierView.h"


@interface CNBarButtonItem ()
@property (nonatomic, strong) CNBezierView *progressBezierView;
@property (nonatomic, strong) NSTimer *timer;
@end

@implementation CNBarButtonItem{
    BBIBlock _bbiBlock;
    UIButton *_btnImg;
}

- (CNBezierView *)progressBezierView {
    if (!_progressBezierView) {
        _progressBezierView = [[CNBezierView alloc] initWithFrame:CGRectMake(0, 0, 20, 20) andType:CNBezierViewTypeProgressItem];
    }
    return _progressBezierView;
}

- (instancetype)barMenuButtomItem {
    UIImage *image  = [UIImage imageNamed:@"ic_list"];
//    CGFloat img_W   = CGImageGetWidth(image.CGImage)/2;
//    CGFloat img_H   = CGImageGetHeight(image.CGImage)/2;
    UIButton *menuButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    [menuButton addTarget:self action:@selector(barItemEvent:) forControlEvents:UIControlEventTouchUpInside];
    [menuButton setImage:image forState:UIControlStateNormal];
    [menuButton setImageEdgeInsets:UIEdgeInsetsMake(1, 1, 1, 1)];
    return  [self initWithCustomView:menuButton];
}

- (instancetype)barButtomItem:(NSString *)title {
    UIButton *itemButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 40)];
    [itemButton addTarget:self action:@selector(barItemEvent:) forControlEvents:UIControlEventTouchUpInside];
    [itemButton setTitle:title forState:UIControlStateNormal];
    [itemButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    itemButton.size = [self sizeOfBtn:itemButton];
    _btnImg = itemButton;
    return  [self initWithCustomView:itemButton];
}

- (instancetype)barLoadButtomItem {
    UIImage *imgLoad_w  = [UIImage imageNamed:@"load_w"];
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    [button addTarget:self action:@selector(barItemEvent:) forControlEvents:UIControlEventTouchUpInside];
    [button setImageEdgeInsets:UIEdgeInsetsMake(1, 1, 1, 1)];
    _btnImg = button;
    
    [button setImage:imgLoad_w forState:UIControlStateNormal];
    
    return  [self initWithCustomView:button];
}

- (void)setBarState:(CNBarItemState)barState {
    _barState = barState;
    switch (barState) {
        case CNBarItemStateDownLoad:
        {
            [_btnImg setImage:[UIImage imageNamed:@"load_w"] forState:UIControlStateNormal];
            [self.progressBezierView setHidden:YES];
            [self.timer setFireDate:[NSDate distantFuture]];
        }
            break;
        case CNBarItemStateDownLoading:
        {
            [_btnImg setImage:[UIImage imageNamed:@"nil"] forState:UIControlStateNormal];
            if (_progressBezierView == nil) {
                if ([[_btnImg subviews] containsObject:_progressBezierView] == NO) {
                    [_btnImg addSubview:self.progressBezierView];
                }
                self.progressBezierView.center = CGPointMake(_btnImg.width/2, _btnImg.height/2);
                [self.progressBezierView setHidden:NO];
            }else{
                [self.progressBezierView setHidden:NO];
            }
        }
            break;
        case CNBarItemStateDownOver:
        {
            [_btnImg setImage:[UIImage imageNamed:@"loaded"] forState:UIControlStateNormal];
            [self.progressBezierView setHidden:YES];
            [self.timer setFireDate:[NSDate distantFuture]];
        }
            break;
        case CNBarItemStateEdit:
        {
            [_btnImg setTitle:@"Cancel" forState:UIControlStateNormal];
            _btnImg.width = 70;
        }
            break;
        case CNBarItemStateCancel:
        {
            [_btnImg setTitle:@"Edit" forState:UIControlStateNormal];
            _btnImg.width = 60;
        }
            break;
        default:
            break;
    }
}

- (void)proChange:(NSTimer *)timer {
    static CGFloat pro = 0;
    pro += 0.01;
    if (pro >= 1.0) {
        self.barState = CNBarItemStateDownOver;
        pro = 0;
    }
    self.progressBezierView.progress = pro;
}

- (void)setProgress:(CGFloat)progress {
    _progress = progress;
    if (_progressBezierView) {
        _progressBezierView.progress = progress;
    }
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




