//
//  CNChannelConfigureViewController.m
//  TopNews
//
//  Created by xuewu.long on 16/10/17.
//  Copyright © 2016年 levt. All rights reserved.
//

#import "CNChannelConfigureViewController.h"

@interface CNChannelConfigureViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *arrChannels;

@end

@implementation CNChannelConfigureViewController

- (NSMutableArray *)arrChannels {
    if (!_arrChannels) {
        _arrChannels = [NSMutableArray array];
        for (NSInteger i = 0; i < 10; i++) {
              [_arrChannels addObject:[NSString stringWithFormat:@"%ld",i]];
        }
    }
    return _arrChannels;
}
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
    }
    return _tableView;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [CNUtils postNotificationName:@"MMDrawerControllerNoti" object:[NSNumber numberWithBool:NO]];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [CNUtils postNotificationName:@"MMDrawerControllerNoti" object:[NSNumber numberWithBool:YES]];
    
    [self.view addSubview:self.tableView];
    [self.tableView setEditing:YES animated:NO];
    
}

#pragma mark - TableView DataSource&Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.arrChannels.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellReuseId = @"cellReId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellReuseId];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellReuseId];
    }
    cell.textLabel.text = self.arrChannels[indexPath.row];
//    cell.accessoryType = UITableViewCellAccessoryDetailButton;
    
    return cell;
}

//打开编辑模式后，默认情况下每行左边会出现红的删除按钮，这个方法就是关闭这些按钮的
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView
           editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleNone;
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

//这个方法就是执行移动操作的
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
//    NSUInteger fromRow = [sourceIndexPath row];
//    NSUInteger toRow = [destinationIndexPath row];
//    
//    id object = [self.arrChannels objectAtIndex:fromRow];
//    [self.arrChannels removeObjectAtIndex:fromRow];
//    [self.arrChannels insertObject:object atIndex:toRow];
    
    [self.arrChannels exchangeObjectAtIndex:sourceIndexPath.row withObjectAtIndex:destinationIndexPath.row];

}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"%@",indexPath);
}

@end
