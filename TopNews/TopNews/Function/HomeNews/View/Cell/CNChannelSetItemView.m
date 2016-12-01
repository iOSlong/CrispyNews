//
//  CNChannelSetItemView.m
//  CrispyNews
//
//  Created by xuewu.long on 16/8/29.
//  Copyright © 2016年 letv. All rights reserved.
//

#import "CNChannelSetItemView.h"

static NSString *kShakeAnimationKey = @"ERTYJKL:";

@interface CNChannelSetItemView ()
@property (nonatomic, strong) UIButton *btnTitle;
@property (nonatomic, strong) UIButton *btnDel;
@end

@implementation CNChannelSetItemView

#define k_spanFix   8

CGFloat channelSetItemHeigh() {
    return 33 + k_spanFix;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self.contentView addSubview:self.btnTitle];
        [self.contentView addSubview:self.btnDel];
        self.btnDel.right   = self.width;
        self.btnDel.top     = 0;
    }
    return self;
}

- (instancetype)initWithChannel:(CNChannel *)channel {
    _channel = channel;
    self = [self init];
    if (self) {
        CGSize fitSize = [_channel.englishName sizeWithFont:[UIFont systemFontOfSize:[CNUtils fontSizePreference:15]]];
        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, fitSize.width + 20, channelSetItemHeigh());
        self.title = _channel.englishName;
        self.btnTitle.size  = CGSizeMake(self.width - k_spanFix, self.height-k_spanFix);
        self.btnDel.right   = self.width;
    }
    return self;
}

- (UIButton *)btnTitle {
    if (!_btnTitle) {
        _btnTitle = [UIButton buttonWithType:UIButtonTypeCustom];
        [_btnTitle addTarget:self action:@selector(btnTitleClick:) forControlEvents:UIControlEventTouchUpInside];
        [_btnTitle.layer setBorderColor:CNCOLOR_ITEM_BORDER.CGColor];
        [_btnTitle.layer setBorderWidth:1];
        [_btnTitle.layer setCornerRadius:2];
        [_btnTitle setTitleColor:CNCOLOR_ITEM forState:UIControlStateNormal];
        [_btnTitle.titleLabel setFont:[CNUtils fontPreference:FONT_Helvetica size:15]];
        [_btnTitle setBackgroundColor:CNCOLOR_ITEM_FILL];
        [_btnTitle setFrame:CGRectMake(0, k_spanFix, self.width - k_spanFix, self.height - k_spanFix)];
        
    }
    return _btnTitle;
}
- (UIButton *)btnDel {
    if (!_btnDel) {
        _btnDel = [UIButton buttonWithType:UIButtonTypeCustom];
        [_btnDel setImage:[UIImage imageNamed:@"ic_chanenelsdelete"] forState:UIControlStateNormal];
        [_btnDel setImageEdgeInsets:UIEdgeInsetsMake(5, 5, 5, 5)];
        [_btnDel addTarget:self action:@selector(btnDelClick:) forControlEvents:UIControlEventTouchUpInside];
        [_btnDel setFrame:CGRectMake(0, 0, 24, 24)];
    }
    return _btnDel;
}

- (void)setTitle:(NSString *)title {
    [super setTitle:title];
    if (title) {
        [self.btnTitle setTitle:title forState:UIControlStateNormal];
    }
}
- (void)setThemeState:(CNThemeItemState)themeState {
    _themeState = themeState;
    if (themeState == CNThemeItemStateChannelsNormal)
    {
        [self.btnDel setHidden:YES];
        self.dragble = NO;
    }
    else if (themeState == CNThemeItemStateRecommended)
    {
        [self.btnDel setHidden:YES];
        self.dragble = NO;
    }
    else if (themeState == CNThemeItemStateDelete)
    {
        [self.btnDel setHidden:NO];
        self.dragble = YES;
    }
}

- (void)btnTitleClick:(UIButton *)btn {
    if (self.themeState == CNThemeItemStateDelete) {
        return;
    }
    if (self.TCBlock) {
        self.TCBlock(CNThemeEventItemClick);
    }
}
- (void)btnDelClick:(UIButton *)btn {
    if (self.TCBlock) {
        self.TCBlock(CNThemeEventDelete);
    }
}
- (void)themeBlock:(ThemeItemBlock)thisBlock {
    self.TCBlock = thisBlock;
}

- (void)themeCellBlock:(ThemeItemBlock)thisBlock {
    self.TCBlock = thisBlock;
}




- (void)startShake {
    CGPoint point = self.center;
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animation];
    animation.keyPath = @"position";
    NSValue *value1=[NSValue valueWithCGPoint:CGPointMake(point.x - 1, point.y+1)];
    NSValue *value2=[NSValue valueWithCGPoint:CGPointMake(point.x + 1, point.y+1)];
    NSValue *value3=[NSValue valueWithCGPoint:CGPointMake(point.x - 1, point.y+1)];
    NSValue *value4=[NSValue valueWithCGPoint:CGPointMake(point.x + 1, point.y-1)];
    NSValue *value5=[NSValue valueWithCGPoint:CGPointMake(point.x - 1, point.y-1)];
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
    [self.layer addAnimation:animation forKey:kShakeAnimationKey];
    
    self.themeState = CNThemeItemStateDelete;
//    self.themeBtn.longPressGesture.enabled = NO;
    
}

- (void)stopShake {
    [self.layer removeAnimationForKey:kShakeAnimationKey];
    self.themeState = CNThemeItemStateChannelsNormal;
//    self.themeBtn.longPressGesture.enabled = YES;
}


@end
