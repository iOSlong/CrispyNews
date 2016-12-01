//
//  CNCollectionViewCell.h
//  CrispyNews
//
//  Created by xuewu.long on 16/8/22.
//  Copyright © 2016年 letv. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CNViewController.h"

@interface CNCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) CNViewController *destViewController;

- (void)showHint:(NSString *)hint hide:(CGFloat)delay;
- (void)showHint:(NSString *)hint hide:(CGFloat)delay enableBackgroundUserAction:(BOOL)enable;


@end
