//
//  CNSettingsCell.m
//  TopNews
//
//  Created by 陈肖坤 on 16/10/31.
//  Copyright © 2016年 levt. All rights reserved.
//

#import "CNSettingsCell.h"


@interface CNSettingsCell ()
@property (nonatomic, strong) UISwitch *switchView;
@property (nonatomic, strong) UIImageView *arrowView;
@property (nonatomic, strong) UILabel *labelView;

@end

@implementation CNSettingsCell


+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *reuse_id = @"setting_reuseId";
    CNSettingsCell *cell = [tableView dequeueReusableCellWithIdentifier:reuse_id];
    if (!cell) {
        cell = [[self alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuse_id];
        CAShapeLayer *layer = [CAShapeLayer layer];
        layer.path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(4, 4, 32, 32)].CGPath;
        cell.imageView.layer.mask = layer;
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    return cell;
}

- (void)setItem:(CNSettingsItem *)item {
    _item =item;
    self.textLabel.text = item.title;

    if (item.type == CNSettingItemTypeArrow) {
        self.accessoryView = self.arrowView;
    }else if (item.type == CNSettingItemTypeSwitch) {
        self.accessoryView = self.switchView;
        if ([[CNDefult shareDefult].imgShowControl boolValue]) {
            [self.switchView setOn:YES];
        }else{
            [self.switchView setOn:NO];
        }
    }else if (item.type == CNSettingItemTypeSwitchPush) {
        self.accessoryView = self.switchViewPush;
        //存开关状态
        if ([[CNDefult shareDefult].notificationsType boolValue]) {
            [_switchViewPush setOn:NO];
        }else{
            [_switchViewPush setOn:YES];
        }
        //判断系统的推送开关状态
        if( [[UIApplication sharedApplication] currentUserNotificationSettings].types == 0 ) {
            [_switchViewPush setOn:NO];
            self.detailTextLabel.textColor = RGB(252, 111, 51);
            self.detailTextLabel.text = MSG_NOTIFICATIONS_CLOSE;
        }else {
            [self.switchViewPush setOn:YES];
            self.detailTextLabel.text = @"";
        }

    }else {
        self.accessoryView = self.labelView;
        CNSettingsItem *item = (CNSettingsItem *)self.item;
        self.labelView.text = item.text;
    }
    
}

- (UIImageView *)arrowView {
    if (!_arrowView) {
        //ic_arrow_rgray
        _arrowView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@""]];
    }
    return _arrowView;
}

- (UISwitch *)switchView {
    if (!_switchView) {
        _switchView = [[UISwitch alloc]init];
        _switchView.onTintColor = RGB(252, 111, 51);
        [_switchView addTarget:self action:@selector(clickSwitch:) forControlEvents:UIControlEventValueChanged];
    }
    return _switchView;
}
- (UISwitch *)switchViewPush {
    if (!_switchViewPush) {
        _switchViewPush = [[UISwitch alloc]init];
        _switchViewPush.onTintColor = RGB(252, 111, 51);
        [_switchViewPush addTarget:self action:@selector(clickSwitch:) forControlEvents:UIControlEventValueChanged];
    }
    return _switchViewPush;
}

- (void)clickSwitch:(UISwitch *)sender {
    if (sender == _switchViewPush) {
        
        if (sender.isOn) {
            self.detailTextLabel.text = @"";
            //判断系统的推送开关状态
            if ([[UIApplication sharedApplication] currentUserNotificationSettings].types == 0) {
                //跳到设置页
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString] options:@{} completionHandler:^(BOOL success) {
                    
                }];
            }
        }else {
            self.detailTextLabel.textColor = RGB(252, 111, 51);
            self.detailTextLabel.text = MSG_NOTIFICATIONS_CLOSE;
            //判断系统的推送开关状态
            if ([[UIApplication sharedApplication] currentUserNotificationSettings].types != 0) {
                //跳到设置页
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString] options:@{} completionHandler:^(BOOL success) {
                    
                }];
            }
        }
    }else if (sender == _switchView){
        if (sender.isOn) {
            [CNDefult shareDefult].imgShowControl = @1;
        }else {
            [CNDefult shareDefult].imgShowControl = @0;
        }
    }
}


- (UILabel *)labelView {
    if (_labelView == nil) {
        _labelView = [UILabel labelFrame:CGRectMake(0, 0, 80, 16) fontSize:[CNUtils fontSizePreference:13] textColor:RGB(153, 153, 153)];
        _labelView.textAlignment = NSTextAlignmentRight;
    }
    return _labelView;
}


@end
