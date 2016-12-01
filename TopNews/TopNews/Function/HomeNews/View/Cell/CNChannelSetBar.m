//
//  CNChannelSetBar.m
//  CrispyNews
//
//  Created by xuewu.long on 16/8/29.
//  Copyright © 2016年 letv. All rights reserved.
//

#import "CNChannelSetBar.h"

@implementation CNChannelSetBar

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.labelTitle];
        [self addSubview:self.labelDesc];
        [self addSubview:self.btnRight];
        
        self.labelTitle.x       = 15;
        self.labelTitle.centerY = frame.size.height * 0.5;
        //        self.labelTitle.backgroundColor = [UIColor yellowColor];
        
        self.labelDesc.x        = self.labelTitle.right;
        self.labelDesc.centerY  = self.labelTitle.centerY;
        
        self.btnRight.right     = frame.size.width - 10;
        self.btnRight.centerY   = frame.size.height * 0.5;
        
        [self.btnRight setHidden:YES];
        self.setState = CNChannelSetBarStateNormal;
        
    }
    return self;
}

- (void)setBarType:(CNChannelSetBarType)barType {
    [self.labelTitle setHidden:NO];
    
    if (barType == CNChannelSetBarTypeHeaderMyChannels) {
        [self.btnRight setHidden:NO];
        [self.labelDesc setHidden:NO];
        self.labelTitle.text = @"My channels";
    }else if (barType ==  CNChannelSetBarTypeHeaderRecommended) {
        [self.btnRight setHidden:YES];
        [self.labelDesc setHidden:YES];
        
        self.labelTitle.text = @"Recommended";
    }else if ( barType == CNChannelSetBarTypeHeaderNoEditing) {
        [self.btnRight setHidden:YES];
        [self.labelDesc setHidden:NO];
        self.labelDesc.text = @"Drag to reorder";
        self.labelDesc.right = self.btnRight.right;
    }
    if (barType == CNChannelSetBarTypeFooter){
        [self.btnRight setHidden:YES];
        [self.labelTitle setHidden:YES];
        [self.labelDesc setHidden:YES];
    }
    
}


- (UILabel *)labelTitle {
    if (!_labelTitle) {
        _labelTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREENW * 0.5, 30)];
        [_labelTitle setFont:[UIFont systemFontOfSize:[CNUtils fontSizePreference:17]]];
        [_labelTitle setTextColor:CNCOLOR_TEXT_TITLE];
        _labelTitle.text = @"My channels";
        CGSize fixtSize = [_labelTitle sizeThatFits:CGSizeMake(SCREENW * 0.5, 30)];
        [_labelTitle setSize:CGSizeMake(fixtSize.width + 5, 30)];
    }
    return _labelTitle;
}

- (UILabel *)labelDesc {
    if (!_labelDesc) {
        _labelDesc = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREENW * 0.5, 30)];
        [_labelDesc setFont:[UIFont systemFontOfSize:[CNUtils fontSizePreference:11]]];
        [_labelDesc setTextColor:CNCOLOR_TEXT_DESC];
        _labelDesc.text = @"Long press to edit";
        CGSize fixtSize = [_labelDesc sizeThatFits:CGSizeMake(SCREENW * 0.5, 30)];
        [_labelDesc setSize:fixtSize];
    }
    return _labelDesc;
}

- (UIButton *)btnRight {
    if (!_btnRight) {
        _btnRight = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [_btnRight setTitle:@"Edit" forState:UIControlStateNormal];
        [_btnRight.titleLabel setFont:[UIFont systemFontOfSize:[CNUtils fontSizePreference:13]]];
        [_btnRight setTitleColor:CNCOLOR_THEME_EDIT forState:UIControlStateNormal];
        CGSize fitSize = [self sizeOfBtn:_btnRight];
        [_btnRight setFrame:CGRectMake(0, 0, fitSize.width, fitSize.height)];
        _btnRight.layer.borderColor     = CNCOLOR_THEME_EDIT.CGColor;
        _btnRight.layer.borderWidth     = 0.5;
        _btnRight.layer.cornerRadius    = 2;
        [_btnRight addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btnRight;
}

- (CGSize)sizeOfBtn:(UIButton *)btn
{
    CGSize sizeBtn = [btn.titleLabel sizeThatFits:CGSizeMake(100,20)];
    CGSize sizeReal    = CGSizeMake(sizeBtn.width + 10, 20);
    CGSize minSize     = CGSizeMake(40, 20);
    CGSize lastSize    = sizeBtn.width + 10  > 40 ? sizeReal : minSize;
    return lastSize;
}


- (void)btnClick:(UIButton *)btn {
    if (self.setState == CNChannelSetBarStateEditing) {
        _setState = CNChannelSetBarStateNormal;
        [self.btnRight setTitle:@"Edit" forState:UIControlStateNormal];
    }else if (self.setState == CNChannelSetBarStateNormal){
        _setState = CNChannelSetBarStateEditing;
        [self.btnRight setTitle:@"Done" forState:UIControlStateNormal];
    }
    if (_channelSetBlock) {
        _channelSetBlock(_setState);
    }
}

- (void)setSetState:(CNChannelSetBarState)setState {
    _setState = setState;
    if (_setState == CNChannelSetBarStateEditing) {
        [self.btnRight setTitle:@"Done" forState:UIControlStateNormal];
    }else if (_setState == CNChannelSetBarStateNormal){
        [self.btnRight setTitle:@"Edit" forState:UIControlStateNormal];
    }
}

- (void)channelSetBar:(ChannelSetBarBlock)thisBlock {
    self.channelSetBlock = thisBlock;
}




@end
