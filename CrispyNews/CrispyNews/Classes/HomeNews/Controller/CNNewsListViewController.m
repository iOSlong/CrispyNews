//
//  CNNewsListViewController.m
//  CrispyNews
//
//  Created by xuewu.long on 16/8/9.
//  Copyright © 2016年 letv. All rights reserved.
//

#import "CNNewsListViewController.h"
#import "CNContentTableView.h"

@interface CNNewsListViewController ()
@property (nonatomic, strong) CNContentTableView *tableView;
@end

@implementation CNNewsListViewController


- (CNContentTableView *)tableView {
    if (!_tableView) {
        _tableView = [[CNContentTableView alloc] initWithFrame:self.view.bounds];
    }
    return _tableView;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSLog(@"viewWillAppear");
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithWhite:arc4random()%255/255.0 alpha:1];
    
    
    
    [self.view addSubview:self.tableView];

    [self netWorkGetNewsList];
}

- (void)netWorkGetNewsList {
    NSArray * array ;
    
    
    [[CNHttpRequest shareHttpRequest] GET:kNet_newsList parameters:nil success:^(NSURLSessionDataTask *task, id  _Nullable responseObject) {
        NSLog(@"%@",responseObject);
        NSDictionary * result = [responseObject objectForKey:@"result"];
        NSLog(@"%@",result);
//        NSDictionary
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError *error) {
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
