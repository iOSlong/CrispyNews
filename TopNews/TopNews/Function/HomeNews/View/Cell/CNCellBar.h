//
//  CNCellBar.h
//  CrispyNews
//
//  Created by xuewu.long on 16/8/20.
//  Copyright © 2016年 letv. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface CNCellBar : UIView

@property (nonatomic, strong) UIImageView   *imgvIconTime;
@property (nonatomic, strong) UIImageView   *imgvIconX;
@property (nonatomic, strong) UIImageView   *imgvLineV;
@property (nonatomic, strong) UILabel       *labelTitle;
@property (nonatomic, strong) UILabel       *labelTime;
@property (nonatomic, strong) UIButton      *butOffline;

@property (nonatomic, strong) NSString      *title;
@property (nonatomic, strong) NSString      *time;
@property (nonatomic, strong) NSNumber      *offline;


- (void)reloadFrame;

@end
