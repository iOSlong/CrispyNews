//
//  CNNavigationController.m
//  CrispyNews
//
//  Created by xuewu.long on 16/8/3.
//  Copyright © 2016年 letv. All rights reserved.
//

#import "CNNavigationController.h"

@interface CNNavigationController ()

@end

@implementation CNNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    /// 1. 设置背景颜色  Item图标颜色
    [self.navigationBar setBarTintColor:RGBCOLOR_HEX(0xf95900)];
    [self.navigationBar setTintColor:[UIColor whiteColor]];
    
    
    /// 2. 设置导航条上的字体颜色
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,[UIFont systemFontOfSize:24],NSFontAttributeName, nil];
    [self.navigationBar setTitleTextAttributes:attributes];
    [self.navigationBar setTranslucent:YES];
    
#if 0
    [[UINavigationBar appearance] setBarTintColor:RGBCOLOR_HEX(0xf95900)];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
#endif

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
