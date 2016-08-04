//
//  CNThemeCollectionReusableView.m
//  CrispyNews
//
//  Created by xuewu.long on 16/8/4.
//  Copyright © 2016年 letv. All rights reserved.
//

#import "CNThemeCollectionReusableView.h"

@implementation CNThemeCollectionReusableView


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.labelTitle];
        [self addSubview:self.btnRight];
        
        self.labelTitle.x       = 15;
        self.labelTitle.centerY = frame.size.height * 0.5;
        
        self.btnRight.right     = frame.size.width - 10;
        self.btnRight.centerY   = frame.size.height * 0.5;
        
        [self.btnRight setHidden:YES];
        self.themeState = CNThemeBarStateNormal;
    }
    return self;
}

- (void)setBarType:(CNThemeBarType)barType {
    [self.labelTitle setHidden:NO];
    
    if (barType == CNThemeBarTypeHeaderMyChannels) {
        [self.btnRight setHidden:NO];
        self.labelTitle.text = @"My channels";
    }else if (barType ==  CNThemeBarTypeHeaderRecommended) {
        [self.btnRight setHidden:YES];
        self.labelTitle.text = @"Recommended";
    }
    
    if (barType == CNThemeBarTypeFooter){
        [self.btnRight setHidden:YES];
        [self.labelTitle setHidden:YES];
    }
    
}


- (UILabel *)labelTitle {
    if (!_labelTitle) {
        _labelTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREENW * 0.5, 30)];
//        _labelTitle.backgroundColor = [UIColor grayColor];
        _labelTitle.text = @"My channels";
    }
    return _labelTitle;
}

- (UIButton *)btnRight {
    if (!_btnRight) {
        _btnRight = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [_btnRight setTitle:@"Edit" forState:UIControlStateNormal];
        CGSize fitSize = [self sizeOfBtn:_btnRight];
        [_btnRight setFrame:CGRectMake(0, 0, fitSize.width, fitSize.height)];
        [_btnRight addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btnRight;
}

- (CGSize)sizeOfBtn:(UIButton *)btn
{
    CGSize sizeBtn = [btn.titleLabel sizeThatFits:CGSizeMake(100,30)];
    CGSize sizeReal    = CGSizeMake(sizeBtn.width + 10, 40);
    CGSize minSize     = CGSizeMake(40, 40);
    CGSize lastSize    = sizeBtn.width + 10  > 40 ? sizeReal : minSize;
    return lastSize;
}


- (void)btnClick:(UIButton *)btn {
    if (self.themeState == CNThemeBarStateEditing) {
        _themeState = CNThemeBarStateNormal;
        [self.btnRight setTitle:@"Edit" forState:UIControlStateNormal];
    }else if (self.themeState == CNThemeBarStateNormal){
        _themeState = CNThemeBarStateEditing;
        [self.btnRight setTitle:@"Done" forState:UIControlStateNormal];
    }
    if (_themeBlock) {
        _themeBlock(_themeState);
    }
}

- (void)setThemeState:(CNThemeBarState)themeState {
    _themeState = themeState;
    if (_themeState == CNThemeBarStateEditing) {
        [self.btnRight setTitle:@"Done" forState:UIControlStateNormal];
    }else if (_themeState == CNThemeBarStateNormal){
        [self.btnRight setTitle:@"Edit" forState:UIControlStateNormal];
    }
}

- (void)themeBar:(ThemeBarBlock)thisBlock {
    _themeBlock = thisBlock;
}

@end





