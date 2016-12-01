//
//  CNChannelCell.m
//  TopNews
//
//  Created by xuewu.long on 16/10/18.
//  Copyright © 2016年 levt. All rights reserved.
//

#import "CNChannelCell.h"

@interface CNChannelCell ()
@property (nonatomic, strong)UIImage *imgCheck;
@end

@implementation CNChannelCell

- (UIImage *)imgCheck {
    if (!_imgCheck) {
        _imgCheck = [UIImage imageNamed:@"icon_check"];
    }
    return _imgCheck;
}

- (UIButton *)btnCheck {
    if (!_btnCheck) {
        _btnCheck = [UIButton buttonFrame:CGRectMake(0, 0, 24, 24) imgSelected:@"icon_check" imgNormal:@"icon_placeholder" target:self action:@selector(checkBtnClick:) mode:UIViewContentModeScaleAspectFill ContentEdgeInsets:UIEdgeInsetsZero];
    }
    return _btnCheck;
}

- (void)tapClick:(UITapGestureRecognizer *)tapG {
    self.btnCheck.selected = !self.btnCheck.selected;
    self.channel.channelState = [NSNumber numberWithBool:self.btnCheck.selected];
    if (self.cellBlock) {
        self.cellBlock(_channel);
    }
}
- (void)checkBtnClick:(UIButton *)btn {
    btn.selected = !btn.selected;
    self.channel.channelState = [NSNumber numberWithBool:self.btnCheck.selected];
    if (self.cellBlock) {
        self.cellBlock(_channel);
    }
}


- (void)cellBlock:(ChannelCellBlock)thisBlock {
    self.cellBlock = thisBlock;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self addSubview:self.btnCheck];
        
        self.labelTitile = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 250, 20)];
        self.labelTitile.userInteractionEnabled = YES;
        [self.labelTitile addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick:)]];
        [self addSubview:self.labelTitile];
        
        self.btnCheck.left         = 15;
        self.btnCheck.centerY      = self.height * 0.5;
        self.labelTitile.left      = self.btnCheck.right + 10.0 * kRATIO;
        self.labelTitile.centerY   = self.height * 0.5;
        
        self.backgroundColor       = [UIColor clearColor];
    }
    return self;
}



- (void)setChannel:(CNChannel *)channel {
    _channel = channel;
    self.labelTitile.text = channel.englishName;
    self.btnCheck.selected = [channel.channelState boolValue];
}


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
