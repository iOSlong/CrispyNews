//
//  CNSettingsCell.h
//  TopNews
//
//  Created by 陈肖坤 on 16/10/31.
//  Copyright © 2016年 levt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CNSettingsItem.h"

@interface CNSettingsCell : UITableViewCell

@property (nonatomic, strong) CNSettingsItem *item;
@property (nonatomic, strong) UISwitch *switchViewPush;

+ (instancetype)cellWithTableView: (UITableView *)tableView;

@end
