//
//  CNSettingsViewController.m
//  CrispyNews
//
//  Created by xuewu.long on 16/8/8.
//  Copyright © 2016年 letv. All rights reserved.
//

#import "CNSettingsViewController.h"
#import "CNSerringsGroup.h"
#import "CNSettingsCell.h"



@interface CNSettingsViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray<CNSerringsGroup *> *groups;
@property (nonatomic, strong) UIButton *logoutBT;

@end


@implementation CNSettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Settings";
    self.view.backgroundColor = RGB(237, 237, 238);
    self.tableView.tableFooterView = self.logoutBT;
    [self.view addSubview:self.tableView];

}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView reloadData];
    if ([[CNDefult shareDefult].userState integerValue] == 1) {
        self.tableView.tableFooterView.hidden = NO;
    }else {
        self.tableView.tableFooterView.hidden = YES;
    }
    
    weakSelf();
    [CNUtils file:NSHomeDirectory() size:^(NSString *fileSize) {
        for (CNSettingsItem *item in self.groups[1].items) {
            if ([item.title isEqualToString:@"Clear cache"]) {
                item.text = fileSize;
                [weakSelf.tableView reloadData];
                break;
            }
        }
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.groups.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.groups[section].items.count;
}

- (CNSettingsCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CNSettingsCell *cell = [CNSettingsCell cellWithTableView:tableView];
    if (indexPath.row == 0 && indexPath.section == 0) {

    }else if (indexPath.section == 2) {

    }else {
        cell.imageView.image = nil;
        if (indexPath.row == 1) {
            cell.selectionStyle= UITableViewCellSelectionStyleDefault;
        }
    }
    cell.item = self.groups[indexPath.section].items[indexPath.row];
    return cell;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    CNSettingsCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    CNSettingsItem *item = cell.item;
    
    !item.operate?:item.operate();

    if ([item isKindOfClass:[CNSettingsItem class]]) {
        CNSettingsItem *arrow = (CNSettingsItem *)item;
        if (arrow.destvc) {
            UIViewController *vc = [[arrow.destvc alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }else if ([item.title isEqualToString:@"Clear cache"]){
            [CNUtils showHint:@"Cache cleared" hide:TIMER_HIDE_DELAY];
            [CNUtils fileCNIMGClear];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(TIMER_HIDE_DELAY * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                item.text = @"0 B";
                [self.tableView reloadData];
                
                [CNUtils postNotificationName:NOTI_SOURCE_DETAIL_NEEDLOAD object:nil];
            });
        }
    }
}

#pragma mark setter & getter

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, -10, SCREENW, SCREENH) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.sectionHeaderHeight = 0;
        _tableView.sectionFooterHeight = 25;
        
        _tableView.scrollEnabled = NO;
    }
    return _tableView;
}

- (NSArray<CNSerringsGroup *> *)groups {
    
    if (!_groups) {
        
        CNSerringsGroup *group0 = [[CNSerringsGroup alloc] init];
        group0.items = @[[CNSettingsItem itemWithTitle:MSG_NOTIFICATIONS operate:^{
        } destvc:nil text:nil type:CNSettingItemTypeSwitchPush]];
        
        CNSerringsGroup *group1 = [[CNSerringsGroup alloc] init];
        group1.items = @[[CNSettingsItem itemWithTitle:MSG_NEKWORK_CELLUAR operate:^{
            
        } destvc:nil text:nil type:CNSettingItemTypeSwitch],
                         [CNSettingsItem itemWithTitle:MSG_CLEAR_CACHE operate:^{
                             
                             
                         } destvc:nil text:@"50.58M" type:CNSettingItemTypeText]];
        
        CNSerringsGroup *group2 = [[CNSerringsGroup alloc] init];
        group2.items = @[[CNSettingsItem itemWithTitle:MSG_APPSTORE_COMMENT operate:^{
            
            NSString *url = @"http://www.apple.com/cn//?afid=p238%7C1wM6yQbQJ-dc_mtid_18707vxu38484_pcrid_7528694023_&cid=aos-cn-kwba-brand";
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url] options:@{} completionHandler:^(BOOL success) {
                
            }];
            
        } destvc:nil text:nil type:CNSettingItemTypeArrow],
                         
                         [CNSettingsItem itemWithTitle:MSG_VERSION operate:nil destvc:nil text:[NSString stringWithFormat:@"%@", APPVERSION] type:CNSettingItemTypeText]];
        
        _groups = @[group0, group1, group2];
    }
    
    return _groups;
}

-(UIButton *)logoutBT{
    if(!_logoutBT){
        _logoutBT = [UIButton buttonWithType:UIButtonTypeCustom];
        [_logoutBT setTitle:MSG_LOGOUT forState:UIControlStateNormal];
        _logoutBT.titleLabel.font = [UIFont boldSystemFontOfSize:17.0];
        [_logoutBT setTitleColor:RGB(252, 111, 51) forState:UIControlStateNormal];
        _logoutBT.backgroundColor = [UIColor whiteColor];
        _logoutBT.size = CGSizeMake(SCREENW, 44);
        [_logoutBT addTarget:self action:@selector(logout) forControlEvents:UIControlEventTouchUpInside];
    }
    return _logoutBT;
}

- (void)logout {
    //初始化提示框；
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:MSG_LOGOUT_FLIP preferredStyle:  UIAlertControllerStyleAlert];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //点击按钮的响应事件；
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"Logout" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //点击按钮的响应事件；
        [self logoutClick];

    }]];
   
    //弹出提示框；
    [self presentViewController:alert animated:true completion:nil];
}

- (void)logoutClick {
        NSString *loginURL = [CNApiManager apiNewsLogOut];
//    NSLog(@"%@",loginURL);
    //封装参数
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters [@"token"] = [CNDefult shareDefult].account.token;
//    NSLog(@" %@",[CNDefult shareDefult].account.token);
    
        weakSelf();
    [[CNHttpRequest shareHttpRequest] POST:loginURL parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
//        NSLog(@"===%@",responseObject);
        weakSelf.tableView.tableFooterView.hidden = YES;
        
        [weakSelf.tableView reloadData];
        
        [CNDefult shareDefult].account = nil;
        
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        NSDictionary *userInfo =  error.userInfo;
        NSData *errorData = [userInfo objectForKey:@"com.alamofire.serialization.response.error.data"];
        NSString *errorStr = [[NSString alloc] initWithData:errorData encoding:NSUTF8StringEncoding];
        NSLog(@"%@",errorStr);
        weakSelf.tableView.tableFooterView.hidden = YES;
    }];
}

@end
