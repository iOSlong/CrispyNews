//
//  CNMenuDrawerTableViewController.m
//  CrispyNews
//
//  Created by 陈肖坤 on 16/8/2.
//  Copyright © 2016年 陈肖坤. All rights reserved.
//

#import "CNMenuDrawerTableViewController.h"
#import "UIViewController+MMDrawerController.h"
#import "CNNavigationController.h"

#import "CNFavouriteViewController.h"
#import "CNDownloadViewController.h"
#import "CNNotificationViewController.h"
#import "CNSettingsViewController.h"
#import "CNFeedbackViewController.h"


@interface CNMenuDrawerTableViewController ()

@property (nonatomic, strong) UIImageView   *imgviewHeader;
@property (nonatomic, strong) UIButton      *btnUserIcon;
@property (nonatomic, strong) UILabel       *labelUser;
@property (nonatomic, strong) NSArray<NSDictionary *>   *arrItem;

@property (nonatomic, strong) CNNotificationViewController    *notificationVC;
@property (nonatomic, strong) CNFavouriteViewController       *favouriteVC;
@property (nonatomic, strong) CNDownloadViewController        *downloadVC;
@property (nonatomic, strong) CNSettingsViewController        *settingsVC;
@property (nonatomic, strong) CNFeedbackViewController        *feedbackVC;


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
                    @{@"imgName":@"ic_redheart",@"itemName":@"Favourite",      @"VC":self.favouriteVC},
                    @{@"imgName":@"ic_download",@"itemName":@"Download",       @"VC":self.downloadVC},
                    @{@"imgName":@"ic_bell"    ,@"itemName":@"Notification",   @"VC":self.notificationVC},
                    @{@"imgName":@"ic_gear"    ,@"itemName":@"Settings",       @"VC":self.settingsVC},
                    @{@"imgName":@"ic_feedback",@"itemName":@"Feedback",       @"VC":self.feedbackVC},
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
    NSDictionary *dict = self.arrItem[indexPath.row];
    cell.imageView.image = [UIImage imageNamed:[dict objectForKey:@"imgName"]];
    
    [cell.imageView.layer setNeedsDisplayInRect:CGRectMake(5, 5, cell.imageView.width - 10, cell.imageView.height -10)];
    cell.textLabel.text =[dict objectForKey:@"itemName"];
    
    
    // Configure the cell...
    
    return cell;
}

#pragma mark - Table view delegate
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 45;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *dict = self.arrItem[indexPath.row];
    
    CNViewController *destVC = [dict objectForKey:@"VC"];
    
    [self.mm_drawerController closeDrawerAnimated:YES completion:^(BOOL finished) {
        
    }];
    CNNavigationController *nav = (CNNavigationController *)self.mm_drawerController.centerViewController;
    [nav pushViewController:destVC animated:YES];
}


- (CNFavouriteViewController *)favouriteVC {
    if (!_favouriteVC) {
        _favouriteVC = [[CNFavouriteViewController alloc] init];
    }
    return _favouriteVC;
}
- (CNDownloadViewController *)downloadVC {
    if (!_downloadVC) {
        _downloadVC = [[CNDownloadViewController alloc] init];
    }
    return _downloadVC;
}
- (CNNotificationViewController *)notificationVC {
    if (!_notificationVC) {
        _notificationVC = [[CNNotificationViewController alloc] init];
    }
    return _notificationVC;
}
- (CNSettingsViewController *)settingsVC {
    if (!_settingsVC) {
        _settingsVC = [[CNSettingsViewController alloc] init];
    }
    return _settingsVC;
}
- (CNFeedbackViewController *)feedbackVC {
    if (!_feedbackVC) {
        _feedbackVC = [[CNFeedbackViewController alloc] init];
    }
    return _feedbackVC;
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
