//
//  HomeNewsViewController.m
//  CrispyNews
//
//  Created by 陈肖坤 on 16/7/25.
//  Copyright © 2016年 陈肖坤. All rights reserved.
//

#import "CNHomeNewsViewController.h"


@interface CNHomeNewsViewController ()

@end

@implementation CNHomeNewsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    self.view.backgroundColor = [UIColor colorWithRed:((float)arc4random_uniform(256) / 255.0) green:((float)arc4random_uniform(256) / 255.0) blue:((float)arc4random_uniform(256) / 255.0) alpha:1.0];
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
