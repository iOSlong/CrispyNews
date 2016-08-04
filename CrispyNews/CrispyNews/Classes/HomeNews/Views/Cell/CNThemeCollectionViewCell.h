//
//  CNThemeCollectionViewCell.h
//  CrispyNews
//
//  Created by xuewu.long on 16/8/4.
//  Copyright © 2016年 letv. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, CNThemeItemState) {
    CNThemeItemStateDelete,
    CNThemeItemStateChannelsNormal,
    CNThemeItemStateRecommended,
};

typedef NS_ENUM(NSUInteger, CNThemeEvent) {
    CNThemeEventItemClick,
    CNThemeEventLongPress,
    CNThemeEventDelete,
};

typedef void(^ThemeItemBlock)(CNThemeEvent themeEvent);


static NSString * const kShakeAnimationKey = @"kCollectionViewCellShake";


@interface CNThemeBtnItem : UIView
@property (nonatomic, strong) NSString *themeTitle;
@property (nonatomic, assign) CNThemeItemState themeState;

@property (nonatomic, copy) ThemeItemBlock TIBlock;

- (void)themeBlock:(ThemeItemBlock)thisBlock;

@end


@interface CNThemeCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) CNThemeBtnItem *themeBtn;
@property (nonatomic, assign) CNThemeItemState themeState;
@property (nonatomic, copy) ThemeItemBlock TCBlock;

- (void)themeCellBlock:(ThemeItemBlock)thisBlock;

- (void)startShake;
- (void)stopShake ;

@end
