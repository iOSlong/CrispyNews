//
//  CNCellBar.m
//  CrispyNews
//
//  Created by xuewu.long on 16/8/20.
//  Copyright © 2016年 letv. All rights reserved.
//

#import "CNCellBar.h"

@implementation CNCellBar

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        CGFloat icon_W      = 10 * kRATIO;
        
        self.butOffline   = [UIButton xk_buttonWithTitle:@" offline " fontSize:[CNUtils fontSizePreference:9] textColor:CNCOLOR_TEXT_SLIGHT];
        self.butOffline.backgroundColor = CNCOLOR_OFFLINE_BACKGROUND;
        self.labelTitle     = [UILabel xk_labelWithText:nil fontSize:[CNUtils fontSizePreference:10] textColor:CNCOLOR_TEXT_SLIGHT];
        self.labelTitle.numberOfLines = 1;
        self.labelTime      = [UILabel xk_labelWithText:nil fontSize:[CNUtils fontSizePreference:9] textColor:CNCOLOR_TEXT_SLIGHT];
        self.labelTime.numberOfLines = 1;
        
        self.butOffline.titleLabel.font = [CNUtils fontPreference:FONT_Helvetica size:10];
        self.labelTitle.font   = [CNUtils fontPreference:FONT_Helvetica size:10];
        self.labelTime.font    = [CNUtils fontPreference:FONT_Helvetica size:9];
        
        self.imgvLineV      = [UIImageView imgvWithFrame:CGRectMake(0, 0, 1, 10 *kRATIO) color:CNCOLOR_GRAY_SLIGHT];
        
        self.imgvIconX      = [UIImageView imgvWithFrame:CGRectMake(0, 0, icon_W, icon_W) imgName:@"ic_delete"];
        self.imgvIconTime   = [UIImageView imgvWithFrame:CGRectMake(0, 0, icon_W, icon_W) imgName:@"ic_clock"];
        [self.imgvIconTime setHidden:YES];
        
        
        self.butOffline.centerY = self.labelTitle.centerY = self.labelTime.centerY = self.imgvIconTime.centerY = self.imgvLineV.centerY = self.imgvIconX.centerY = self.height * 0.4;
        self.butOffline.left = k_SpanLeft;
        self.labelTime.left    = k_SpanLeft;
        self.imgvIconX.right   = self.width - k_SpanLeft;
        
        
        [self addSubview:self.butOffline];
        [self addSubview:self.labelTitle];
        [self addSubview:self.labelTime];
        [self addSubview:self.imgvLineV];
//        [self addSubview:self.imgvIconTime];
//        [self addSubview:self.imgvIconX];
        
        
    }
    return self;
}

- (void)setTime:(NSString *)time {
    _time = time;
    if (TextValid(time)) {
        [self.imgvLineV setHidden:!TextValid(_title)];
        [self.labelTime setHidden:NO];
        [self.imgvIconTime setHidden:NO];
    }else{
        [self.imgvLineV setHidden:YES];
        [self.labelTime setHidden:YES];
        [self.imgvIconTime setHidden:YES];
    }
    self.labelTime.text = time;
    [self reloadFrame];
}
- (void)setTitle:(NSString *)title {
    _title = title;
    if (TextValid(title)) {
        [self.imgvLineV setHidden:NO];
        [self.labelTitle setHidden:NO];
    }else{
        [self.imgvLineV setHidden:YES];
        [self.labelTitle setHidden:YES];
    }
    self.labelTitle.text   = title;
    [self reloadFrame];
}

- (void)reloadFrame {
    self.butOffline.frame = CGRectMake(0, 0, 35 * kRATIO, 12 * kRATIO);
    self.butOffline.layer.cornerRadius = 1 * kRATIO;
    [self.labelTitle sizeToFit];
    [self.labelTime sizeToFit];
    self.butOffline.centerY = self.labelTitle.centerY = self.labelTime.centerY = self.imgvIconTime.centerY = self.imgvLineV.centerY = self.imgvIconX.centerY = self.height * 0.4;

    self.butOffline.left  = 0;
    if ([self.offline integerValue] == 0) {
        self.labelTitle.left = 0;
        [self.butOffline setHidden:YES];
    }else {
        self.labelTitle.left    = self.butOffline.right + k_SpanIn;
        [self.butOffline setHidden:NO];
    }
    if (TextValid(_title)) {
        self.imgvLineV.left     = self.labelTitle.right + k_SpanIn;
        self.labelTime.left     = self.imgvLineV.right + k_SpanIn;
    }else {
        [self.imgvLineV setHidden:YES];
        self.labelTime.left     = TextValid(_title)?(self.butOffline.right + k_SpanIn) : 0;
    }
//    self.imgvIconTime.left  = self.imgvLineV.right + k_SpanIn;
//    self.labelTime.left     = self.imgvIconTime.right + k_SpanIn;
    
    self.labelTime.left     = self.imgvLineV.hidden ? (self.butOffline.hidden ? 0 : self.butOffline.right + k_SpanIn) : (self.imgvLineV.right + k_SpanIn);
    
    self.imgvIconX.right    = self.width;
    
}


@end
