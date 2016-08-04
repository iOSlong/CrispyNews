//
//  CNThemeCollectionReusableView.h
//  CrispyNews
//
//  Created by xuewu.long on 16/8/4.
//  Copyright © 2016年 letv. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, CNThemeBarType) {
    CNThemeBarTypeHeaderMyChannels,
    CNThemeBarTypeHeaderRecommended,
    CNThemeBarTypeFooter,
};

typedef NS_ENUM(NSUInteger, CNThemeBarState) {
    CNThemeBarStateEditing,
    CNThemeBarStateNormal,
};

typedef void(^ThemeBarBlock)(CNThemeBarState themeState);

@interface CNThemeCollectionReusableView : UICollectionReusableView

@property (nonatomic, copy) ThemeBarBlock themeBlock;
@property (nonatomic, assign) CNThemeBarState    themeState;
@property (nonatomic, assign) CNThemeBarType     barType;
@property (nonatomic, strong) UILabel     *labelTitle;
@property (nonatomic, strong) UIButton    *btnRight;
- (void)themeBar:(ThemeBarBlock)thisBlock;




@end
