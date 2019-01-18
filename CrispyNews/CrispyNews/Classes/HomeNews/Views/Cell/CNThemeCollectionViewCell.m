//
//  CNThemeCollectionViewCell.m
//  CrispyNews
//
//  Created by xuewu.long on 16/8/4.
//  Copyright © 2016年 letv. All rights reserved.
//

#import "CNThemeCollectionViewCell.h"

@interface CNThemeBtnItem ()
@property (nonatomic, strong) UIButton  *btnTitle;
@property (nonatomic, strong) UIButton  *btnDel;
@end

@implementation CNThemeBtnItem
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.btnTitle];
        [self addSubview:self.btnDel];
        self.btnDel.right   = self.width;
        self.btnDel.top     = 0;
    
        self.backgroundColor= [UIColor lightGrayColor];
    }
    return self;
}
- (UIButton *)btnTitle {
    if (!_btnTitle) {
        _btnTitle = [UIButton buttonWithType:UIButtonTypeCustom];
        [_btnTitle addTarget:self action:@selector(btnTitleClick:) forControlEvents:UIControlEventTouchUpInside];
        [_btnTitle setFrame:self.bounds];
        [_btnTitle.titleLabel setFont:[UIFont systemFontOfSize:17]];
    }
    return _btnTitle;
}
- (UIButton *)btnDel {
    if (!_btnDel) {
        _btnDel = [UIButton buttonWithType:UIButtonTypeCustom];
        [_btnDel setTitle:@"x" forState:UIControlStateNormal];
        [_btnDel addTarget:self action:@selector(btnDelClick:) forControlEvents:UIControlEventTouchUpInside];
        [_btnDel setFrame:CGRectMake(0, 0, 15, 15)];
    }
    return _btnDel;
}
- (void)setThemeTitle:(NSString *)themeTitle {
    _themeTitle = themeTitle;
    if (themeTitle) {
        [self.btnTitle setTitle:themeTitle forState:UIControlStateNormal];
    }
}
- (void)setThemeState:(CNThemeItemState)themeState {
    _themeState = themeState;
    if (themeState == CNThemeItemStateChannelsNormal)
    {
        [self.btnDel setHidden:YES];
    }
    else if (themeState == CNThemeItemStateRecommended)
    {
        [self.btnDel setHidden:YES];
    }
    else if (themeState == CNThemeItemStateDelete)
    {
        [self.btnDel setHidden:NO];
    }
}

- (void)btnTitleClick:(UIButton *)btn {
    if (self.themeState == CNThemeItemStateDelete) {
        return;
    }
    if (self.TIBlock) {
        self.TIBlock(CNThemeEventItemClick);
    }
}
- (void)btnDelClick:(UIButton *)btn {
    if (self.TIBlock) {
        self.TIBlock(CNThemeEventDelete);
    }
}
- (void)themeBlock:(ThemeItemBlock)thisBlock {
    self.TIBlock = thisBlock;
}

@end





@implementation CNThemeCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.themeBtn = [[CNThemeBtnItem alloc] initWithFrame:self.bounds];
        self.themeBtn.themeTitle = @"For You";
        [self.themeBtn themeBlock:^(CNThemeEvent themeEvent) {
            if (self.TCBlock) {
                self.TCBlock (themeEvent);
            }
        }];
        [self.contentView addSubview:self.themeBtn];
    }
    return self;
}

- (void)startShake {
    CGPoint point = self.contentView.center;
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animation];
    animation.keyPath = @"position";
    NSValue *value1=[NSValue valueWithCGPoint:CGPointMake(point.x - 1, point.y+1)];
    NSValue *value2=[NSValue valueWithCGPoint:CGPointMake(point.x + 2, point.y+2)];
    NSValue *value3=[NSValue valueWithCGPoint:CGPointMake(point.x - 1, point.y+1)];
    NSValue *value4=[NSValue valueWithCGPoint:CGPointMake(point.x + 1, point.y-1)];
    NSValue *value5=[NSValue valueWithCGPoint:CGPointMake(point.x - 2, point.y-1)];
    NSMutableArray *arrValue = [NSMutableArray arrayWithObjects:value1,value2,value3,value4,value5, nil];
    [arrValue exchangeObjectAtIndex:arc4random()%4 withObjectAtIndex:arc4random()%4];
    [arrValue exchangeObjectAtIndex:arc4random()%4 withObjectAtIndex:arc4random()%4];
    [arrValue exchangeObjectAtIndex:arc4random()%4 withObjectAtIndex:arc4random()%4];
    [arrValue exchangeObjectAtIndex:arc4random()%4 withObjectAtIndex:arc4random()%4];

    animation.values=arrValue;

//    animation.values=@[value1,value2,value3,value4,value5];
    animation.repeatCount = MAXFLOAT;
    //    animation.removedOnCompletion = NO;
    //    animation.fillMode = kCAFillModeRemoved;
    animation.duration = 0.25;
    animation.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    //    animation.delegate=self;
    [self.contentView.layer addAnimation:animation forKey:kShakeAnimationKey];
    
    self.themeState = CNThemeItemStateDelete;

}

- (void)stopShake {
    [self.contentView.layer removeAnimationForKey:kShakeAnimationKey];
    self.themeState = CNThemeItemStateChannelsNormal;
}

- (void)themeCellBlock:(ThemeItemBlock)thisBlock {
    self.TCBlock = thisBlock;
}

- (void)setThemeState:(CNThemeItemState)themeState {
    self.themeBtn.themeState = themeState;
}


- (UICollectionViewLayoutAttributes *)preferredLayoutAttributesFittingAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes {
    UICollectionViewLayoutAttributes *attributes = [super preferredLayoutAttributesFittingAttributes:layoutAttributes];
    NSString *title = self.themeBtn.themeTitle;
    CGRect rect = [title boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, 30) options:NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17]} context:nil];
    
    rect.size.width +=0;
    rect.size.height+=0;

    attributes.frame = rect;
    return attributes;
}

@end
