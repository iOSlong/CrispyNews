//
//  CNSettingsItem.h
//  TopNews
//
//  Created by 陈肖坤 on 16/10/31.
//  Copyright © 2016年 levt. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSInteger{
    CNSettingItemTypeText,
    CNSettingItemTypeArrow, // 箭头
    CNSettingItemTypeSwitchPush,
    CNSettingItemTypeSwitch// 开关
} CNSettingItemType;

typedef  void(^Operate)();

@interface CNSettingsItem : NSObject

@property (nonatomic, assign) CNSettingItemType type;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) Operate operate;

@property (nonatomic, assign) Class destvc;

@property (nonatomic, copy) NSString *text;


+ (instancetype)itemWithTitle:(NSString *)title operate:(Operate)operate destvc:(Class)destvc text:(NSString *)text type:(CNSettingItemType)type;
@end
