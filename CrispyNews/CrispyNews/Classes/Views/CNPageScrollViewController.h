//
//  CNPageScrollViewController.h
//  CrispyNews
//
//  Created by xuewu.long on 16/8/9.
//  Copyright © 2016年 letv. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CNPageScrollViewControllerDelegate <NSObject>

@optional

- (void)pageScrollViewController:(UIViewController *)currentViewController page:(NSInteger)pageIndex;

@end





@interface CNPageScrollViewController : UIViewController

@property (nonatomic, strong) NSArray *viewControllers;
@property (nonatomic, assign) id<CNPageScrollViewControllerDelegate>pageScrollDelegate;

@property (nonatomic, assign, readonly)NSInteger pageIndex;

- (void)setSelectedIndex:(NSInteger)pageIndex animation:(BOOL)animation;

- (void)addViewController:(UIViewController *)viewController;

- (void)insertViewController:(UIViewController *)viewController atIndex:(NSInteger)index;

- (void)insertViewControllers:(NSArray<UIViewController *> *)viewControllers atIndex:(NSInteger)index;


@end
