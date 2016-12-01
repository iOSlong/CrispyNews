//
//  CNImageView.m
//  TopNews
//
//  Created by xuewu.long on 16/11/23.
//  Copyright © 2016年 levt. All rights reserved.
//

#import "CNImageView.h"

@implementation CNImageView


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self.label sizeToFit];
        [self addSubview:self.label];
        self.label.center = CGPointMake(self.width * 0.5 , self.height * 0.5);
//        [self.label setHidden:YES];
    }
    return self;
}

- (UILabel *)label{
    if (!_label) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.width, 30)];
        label.text = @"TopNews";
        label.textColor = RGBCOLOR_HEX(0xFFFFFF);
        if (self.width > SCREENW * 0.5) {
            label.font = [CNUtils fontPreference:FONT_Helvetica size:25];
        }
        label.font = [CNUtils fontPreference:FONT_Helvetica size:17];
        
        _label = label;
    }
    return _label;
}

@end
