//
//  CNViewController.m
//  CrispyNews
//
//  Created by xuewu.long on 16/8/8.
//  Copyright © 2016年 letv. All rights reserved.
//

#import "CNViewController.h"

@interface CNViewController ()

@end

@implementation CNViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}

- (void)setArrowBack:(BOOL)arrowBack {
    _arrowBack = arrowBack;
    if (arrowBack) {
        [self setNavigationBarItem];
    }else{
        self.navigationItem.leftBarButtonItems = nil;
    }
}

- (void)setNavigationBarItem {
    
    CNBarButtonItem *editItem = [[CNBarButtonItem alloc] barMenuButtomItem];
    [editItem barBlock:^(CNBarButtonItem *barBItem) {
        NSLog(@"Edit Click");
        [self.navigationController popViewControllerAnimated:YES];
    }];
    UIBarButtonItem *rightSpaceItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    rightSpaceItem.width =  iPhone6Plus? -10:-5;
    self.navigationItem.leftBarButtonItems = @[rightSpaceItem,editItem];
    
}

@end
