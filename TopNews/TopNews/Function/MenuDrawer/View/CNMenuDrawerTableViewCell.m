//
//  CNDrawerMenuTableViewCell.m
//  CrispyNews
//
//  Created by xuewu.long on 16/8/15.
//  Copyright © 2016年 letv. All rights reserved.
//

#import "CNMenuDrawerTableViewCell.h"

@implementation CNMenuDrawerTableViewCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        _imgvHead       = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 18 * kRATIO, 18 * kRATIO)];
        _imgvHead.contentMode = UIViewContentModeScaleAspectFit;
        _imgvAccossory  = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 13 * kRATIO, 13 * kRATIO)];
        
        _labelTitle     = [[UILabel alloc] initWithFrame:CGRectMake(100, 10, 200, 25)];
        
        [_labelTitle setFont:[UIFont systemFontOfSize:[CNUtils fontSizePreference:17]]];
        [_labelTitle setTextColor:RGBCOLOR_HEX(0x131313)];
        [_labelTitle setTextAlignment:NSTextAlignmentLeft];
        
        [self.contentView addSubview:_imgvHead];
        [self.contentView addSubview:_imgvAccossory];
        [self.contentView addSubview:_labelTitle];
        
        _imgvHead.left      = k_SpanLeft;
        _imgvHead.centerY   = self.height * 0.5;
        
        _labelTitle.left    = 46 * kRATIO;
        _labelTitle.centerY = self.height * 0.5;
        

    }
    return self;
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
