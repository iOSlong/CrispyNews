//
//  CNNewsThemeSetViewController.m
//  CrispyNews
//
//  Created by xuewu.long on 16/8/3.
//  Copyright © 2016年 letv. All rights reserved.
//

#import "CNNewsThemeSetViewController.h"

@interface CNNewsThemeSetViewController ()


@end

@implementation CNNewsThemeSetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = RGBCOLOR_HEX(0xfefefe);
    
    
    /// 2. 设置导航条上的字体颜色
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName, nil];
    [self.navigationController.navigationBar setTitleTextAttributes:attributes];


    [self setNavigationBarItem];
}

- (void)setNavigationBarItem {
    
    self.title = @"CrispyNews";
    
    
    CNBarButtonItem *editItem = [[CNBarButtonItem alloc] barButtomItem:@"<<"];
    [editItem barBlock:^(CNBarButtonItem *barBItem) {
        NSLog(@"Edit Click");
        [self.navigationController popViewControllerAnimated:YES];
    }];
    UIBarButtonItem *rightSpaceItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    rightSpaceItem.width =  iPhone6Plus? -15:-8;
    self.navigationItem.leftBarButtonItems = @[rightSpaceItem,editItem];

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
