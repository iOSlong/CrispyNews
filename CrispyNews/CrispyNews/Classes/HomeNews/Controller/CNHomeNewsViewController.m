//
//  HomeNewsViewController.m
//  CrispyNews
//
//  Created by 陈肖坤 on 16/7/25.
//  Copyright © 2016年 陈肖坤. All rights reserved.
//

#import "CNHomeNewsViewController.h"
#import "CNSegmentView.h"
#import "CNBarButtonItem.h"
#import "AppDelegate.h"

@interface CNHomeNewsViewController ()

@property (nonatomic, strong) CNSegmentView *segmentView;

@end

@implementation CNHomeNewsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    self.view.backgroundColor = RGBCOLOR_HEX(0xfefefe);
    
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.segmentView = [[CNSegmentView alloc] initWithFrame:CGRectMake(0, 64, SCREENW, 44)];
    self.segmentView.arrItem = @[@"American",@"two",@"American",@"English",@"India",@"Chinese",@"more"];
    [self.view addSubview:self.segmentView];

    
    [self setNavigationBarItem];
    
}

- (void)setNavigationBarItem {
    
    self.title = @"CrispyNews";
    
    CNBarButtonItem *menuItem = [[CNBarButtonItem alloc] barMenuButtomItem];
    [menuItem barBlock:^(CNBarButtonItem *barBItem) {
        NSLog(@"menu click");
        AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        if (appDelegate.crispyMenu.openSide == MMDrawerSideNone) {
            [appDelegate.crispyMenu openDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
        }else{
            [appDelegate.crispyMenu closeDrawerAnimated:YES completion:nil];
        }
    }];
    UIBarButtonItem *leftSpaceItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    leftSpaceItem.width =  iPhone6Plus? -15:-8;
    self.navigationItem.leftBarButtonItems = @[leftSpaceItem,menuItem];
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
