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
    
    
    /// 1. 设置背景颜色
    [self.navigationBar setBarTintColor:RGBCOLOR_HEX(0xf95900)];
    
    
    /// 2. 设置导航条上的字体颜色
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName, nil];
    [self.navigationBar setTitleTextAttributes:attributes];
    [self.navigationBar setTranslucent:YES];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
