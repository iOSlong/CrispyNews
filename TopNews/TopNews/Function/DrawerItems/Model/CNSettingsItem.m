//
//  CNSettingsItem.m
//  TopNews
//
//  Created by 陈肖坤 on 16/10/31.
//  Copyright © 2016年 levt. All rights reserved.
//

#import "CNSettingsItem.h"

@implementation CNSettingsItem


+ (instancetype)itemWithTitle:(NSString *)title operate:(Operate)operate destvc:(Class)destvc text:(NSString *)text type:(CNSettingItemType)type
{
    CNSettingsItem *item  = [[self alloc] init];
    if (item) {
        item.title = title;
        item.operate = operate;
        item.destvc = destvc;
        item.text = text;
        item.type = type;
    }
    return item;
}


@end
