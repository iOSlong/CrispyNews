//
//  CNNoIconCell.m
//  CrispyNews
//
//  Created by 陈肖坤 on 16/8/4.
//  Copyright © 2016年 陈肖坤. All rights reserved.
//

#import "CNNoIconCell.h"

@implementation CNNoIconCell

- (void)awakeFromNib {
    [super awakeFromNib];

    self.selectionStyle = UITableViewCellSelectionStyleNone;

}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
