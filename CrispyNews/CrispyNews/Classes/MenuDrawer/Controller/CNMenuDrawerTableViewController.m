//
//  CNMenuDrawerTableViewController.m
//  CrispyNews
//
//  Created by 陈肖坤 on 16/8/2.
//  Copyright © 2016年 陈肖坤. All rights reserved.
//

#import "CNMenuDrawerTableViewController.h"

@interface CNMenuDrawerTableViewController ()

@property (nonatomic, strong) UIImageView   *imgviewHeader;
@property (nonatomic, strong) UIButton      *btnUserIcon;
@property (nonatomic, strong) UILabel       *labelUser;
@property (nonatomic, strong) NSArray<NSDictionary *>   *arrItem;
@end

@implementation CNMenuDrawerTableViewController{
    CGFloat realImg_w;
    CGFloat realImg_h;
}

- (UILabel *)labelUser {
    if (!_labelUser) {
        _labelUser = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 40)];
        _labelUser.textAlignment= NSTextAlignmentCenter;
        _labelUser.textColor    = [UIColor whiteColor];
        _labelUser.font         = [UIFont boldSystemFontOfSize:20];
        _labelUser.text         = @"Sral Mcheal";
    }
    return _labelUser;
}
- (UIButton *)btnUserIcon {
    if (!_btnUserIcon) {
        _btnUserIcon = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        _btnUserIcon.frame = CGRectMake(0, 0, SCREENW * (156.0/720.0), SCREENW * (156.0/720.0));
        _btnUserIcon.layer.cornerRadius = _btnUserIcon.width * 0.5;
        [_btnUserIcon setBackgroundImage:[UIImage imageNamed:@"ic_ueser1"] forState:UIControlStateNormal];
    }
    return _btnUserIcon;
}

- (UIImageView *)imgviewHeader {
    if (!_imgviewHeader) {
        CGImageRef imgCover = [UIImage imageNamed:@"cover1"].CGImage;
        CGFloat img_w   = CGImageGetWidth(imgCover)/2 ;
        CGFloat img_h   = CGImageGetHeight(imgCover)/2;
        realImg_w       = k_Drawer_W;
        realImg_h       = k_Drawer_W *img_h/img_w;
        _imgviewHeader  = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, realImg_w, realImg_h)];
        _imgviewHeader.layer.contents   = (__bridge id _Nullable)(imgCover);
        _imgviewHeader.backgroundColor  = [UIColor purpleColor];
        _imgviewHeader.userInteractionEnabled = YES;
        
        [_imgviewHeader addSubview:self.btnUserIcon];
        self.btnUserIcon.centerX = _imgviewHeader.width * 0.5;
        self.btnUserIcon.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        self.btnUserIcon.centerY = _imgviewHeader.height * 0.5;
        
        [_imgviewHeader addSubview:self.labelUser];
        self.labelUser.top = self.btnUserIcon.bottom;
        self.labelUser.centerX  = self.btnUserIcon.centerX;
        self.labelUser.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    }
    return _imgviewHeader;
}

- (NSArray *)arrItem {
    if (!_arrItem) {
        _arrItem = [NSArray arrayWithObjects:
                    @{@"ic_redheart":@"Favourite"},
                    @{@"ic_download":@"Download"},
                    @{@"ic_bell"    :@"Notification"},
                    @{@"ic_gear"    :@"Settings"},
                    @{@"ic_feedback":@"Feedback"},
                    nil];
    }
    return _arrItem;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = RGB(255, 255, 255);
    
    NSLog(@"%@",NSStringFromCGSize(self.view.size));
    
    
    
    [self.view addSubview:self.imgviewHeader];
    [self.view sendSubviewToBack:self.imgviewHeader];
    [self.tableView setContentInset:UIEdgeInsetsMake(realImg_h, 0, 0, 0)];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    _imgviewHeader.top = -realImg_h;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}


#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.arrItem.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellID"];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellID"];
    }
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    NSString *itemKey = [[self.arrItem[indexPath.row] allKeys] lastObject];
    cell.imageView.image = [UIImage imageNamed:itemKey];
    [cell.imageView.layer setNeedsDisplayInRect:CGRectMake(5, 5, cell.imageView.width - 10, cell.imageView.height -10)];
    cell.textLabel.text = [self.arrItem[indexPath.row] objectForKey:itemKey];
    
    // Configure the cell...
    
    return cell;
}

#pragma mark - Table view delegate
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 45;
}


#pragma mark - ScrollView Delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offsetY = scrollView.contentOffset.y + realImg_h;
    NSLog(@"offsetY = %f",offsetY);
    if (offsetY < 0) {
        self.imgviewHeader.height   = realImg_h - offsetY;
        self.imgviewHeader.width    = realImg_w - offsetY * (self.imgviewHeader.height/realImg_w);
        self.imgviewHeader.left     = offsetY * (self.imgviewHeader.height/realImg_w)/2;
        self.imgviewHeader.top      = offsetY  - realImg_h ;
        self.btnUserIcon.centerX    = self.imgviewHeader.width * 0.5;
        self.btnUserIcon.centerY    = self.imgviewHeader.height * 0.5;
        self.labelUser.centerX      = self.imgviewHeader.width * 0.5;
        self.labelUser.top          = self.btnUserIcon.bottom;
    }
}

@end
