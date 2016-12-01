//
//  CNTestInfoViewController.m
//  TopNews
//
//  Created by xuewu.long on 16/9/29.
//  Copyright © 2016年 levt. All rights reserved.
//

#import "CNTestInfoViewController.h"

@interface CNTestInfoViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, strong) UIButton *btnNewsId;        //
@property (nonatomic, strong) UIButton *btnUIID;        //
@property (nonatomic, strong) UIButton *btnDeviceToken;     // 

@property (nonatomic, strong) UIView *footerView;
@property (nonatomic, strong) NSMutableArray *arrayChoosed;

@end

@implementation CNTestInfoViewController

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.backgroundColor = [UIColor whiteColor];
    }
    return  _tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"TestInfo";
    
    
        self.dataArray = [NSMutableArray array];
    self.arrayChoosed  = [NSMutableArray array];
    
    
    [self.dataArray addObject:@{@"UIID:" : [CNUtils getDeviceUIID]}];
    [self.dataArray addObject:@{@"apnsToken:" :[CNDefult shareDefult].deviceToken ? :@""}];
    [self.dataArray addObject:@{@"newsId:" : self.newsId}];
    
    
    _btnNewsId    = [UIButton xk_buttonWithFrame:CGRectMake(0, 0, 50, 50) imageNormal:@"market_unselected_button" selectedImage:@"market_selected_button" target:self action:@selector(btnClick:)];
    _btnUIID  = [UIButton xk_buttonWithFrame:CGRectMake(0, 0, 50, 50) imageNormal:@"market_unselected_button" selectedImage:@"market_selected_button" target:self action:@selector(btnClick:)];
    _btnDeviceToken = [UIButton xk_buttonWithFrame:CGRectMake(0, 0, 50, 50) imageNormal:@"market_unselected_button" selectedImage:@"market_selected_button" target:self action:@selector(btnClick:)];

    
    [self.view addSubview:self.tableView];
    [self.tableView reloadData];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREENW, 30)];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = @"选中张贴选项！";
    titleLabel.textColor = CNCOLOR_THEME_EDIT;
    titleLabel.font = [UIFont systemFontOfSize:14];
    
    self.tableView.tableHeaderView = titleLabel;
    
    self.tableView.tableFooterView = self.footerView;
    
    [self.arrayChoosed addObject:@{@"letvimg":self.news.letvImgUrl}];

}

- (UIView *)footerView {
    if (!_footerView) {
        _footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENW, 40)];
        
        UIButton *btnFooter = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [btnFooter setFrame:CGRectMake(0, 0, SCREENW/2, 30)];
        btnFooter.center = CGPointMake(SCREENW * 0.5 , _footerView.height * 0.5);
        [btnFooter setTitle:@"点击复制到粘贴板" forState:UIControlStateNormal];
        btnFooter.layer.cornerRadius = 10;
        [btnFooter setTitleColor:CNCOLOR_THEME_EDIT forState:UIControlStateNormal];
        [btnFooter.titleLabel setFont:[UIFont systemFontOfSize:15]];
        btnFooter.layer.borderColor = CNCOLOR_THEME_EDIT.CGColor;
        btnFooter.layer.borderWidth = 1;
        [btnFooter addTarget:self action:@selector(copyClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [_footerView addSubview:btnFooter];
    }
    return _footerView;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"testInfo_ID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell ) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    NSDictionary *dict = [self.dataArray objectAtIndex:indexPath.row];
    cell.textLabel.text = [[dict allKeys] lastObject];
    cell.detailTextLabel.text = [dict objectForKey:[[dict allKeys] lastObject]];
    
    if (indexPath.row == 0) {
        cell.accessoryView = _btnUIID;
    }else if (indexPath.row == 1){
        cell.accessoryView = _btnDeviceToken;
    }else if (indexPath.row == 2){
        cell.accessoryView = _btnNewsId;
    }
    return cell;
}

- (void)btnClick:(UIButton *)btn {
    btn.selected = !btn.selected;
    [self.arrayChoosed removeAllObjects];
    if (_btnNewsId.selected) {
        [self.arrayChoosed addObject:@{@"newsId:" : self.newsId}];
    }
    if (_btnUIID.selected){
        [self.arrayChoosed addObject:@{@"UIID:" : [CNUtils getDeviceUIID]}];
    }
    if (_btnDeviceToken.selected){
        [self.arrayChoosed addObject:@{@"apnsToken:" :[CNDefult shareDefult].deviceToken ? :@""}];
    }
    [self.arrayChoosed addObject:@{@"letvimg":self.news.letvImgUrl}];
}

- (void)copyClick:(UIButton *)btn {
    NSLog(@"%@",[self.arrayChoosed yy_modelToJSONString]);
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string =[self.arrayChoosed yy_modelToJSONString];
    [self showHint:pasteboard.string hide:1.5f];

}

@end
