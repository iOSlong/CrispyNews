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

//#import "CNDownloadViewController.h"
//#import "CNNotificationViewController.h"
#import "CNFavouriteViewController.h"
#import "CNSettingsViewController.h"
#import "CNFeedbackViewController.h"
#import "CNChangeServerViewController.h"

#import "CNMenuDrawerTableViewCell.h"

#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKShareKit/FBSDKShareKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>

#import "CNAccount.h"
#import <SDWebImage/UIImageView+WebCache.h>


//#import <LTLSUserManager.h>

@interface CNMenuDrawerTableViewController ()

@property (nonatomic, strong) UIImageView   *imgviewHeader;
@property (nonatomic, strong) UIImageView   *imgvIcon;
@property (nonatomic, strong) UIButton      *btnUserIcon;
@property (nonatomic, strong) UILabel       *labelUser;
@property (nonatomic, strong) NSArray<NSDictionary *>         *arrItem;

//@property (nonatomic, strong) CNNotificationViewController    *notificationVC;
//@property (nonatomic, strong) CNViewController                *downloadVC;
@property (nonatomic, strong) CNViewController                *favouriteVC;
@property (nonatomic, strong) CNViewController                *settingsVC;
@property (nonatomic, strong) CNFeedbackViewController        *feedbackVC;
@property (nonatomic, strong) CNViewController                *changeserverVC;

@property (nonatomic, strong) CNAccount *account;

@property (assign) BOOL useHTML;

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
        _labelUser.font         = [UIFont boldSystemFontOfSize:[CNUtils fontSizePreference:17]];
        _labelUser.text         = @"Log in";
    }
    return _labelUser;
}

- (UIButton *)btnUserIcon {
    if (!_btnUserIcon) {
        _btnUserIcon = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        _btnUserIcon.frame = CGRectMake(0, 0, SCREENW * (156.0/720.0), SCREENW * (156.0/720.0));
        [_btnUserIcon addTarget:self action:@selector(faceIconBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_btnUserIcon setBackgroundImage:[UIImage imageNamed:@"Facebook"] forState:UIControlStateNormal];
    }
    return _btnUserIcon;
}

- (UIImageView *)imgvIcon {
    if (!_imgvIcon) {
        _imgvIcon = [[UIImageView alloc] initWithFrame:self.btnUserIcon.bounds];
        _imgvIcon.layer.cornerRadius = _btnUserIcon.width * 0.5;
        _imgvIcon.clipsToBounds = YES;
        _imgvIcon.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _imgvIcon;
}

- (UIImageView *)imgviewHeader {
    if (!_imgviewHeader) {
        CGImageRef imgCover = [UIImage imageNamed:@"cover2"].CGImage;
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
        
        
        [self.btnUserIcon addSubview:self.imgvIcon];
        
    }
    return _imgviewHeader;
}

- (NSArray *)arrItem {
    if (!_arrItem) {
        _arrItem = [NSArray arrayWithObjects:
                    @{@"imgName":@"ic_markless_bold",@"itemName":@"Bookmarks",      @"VC":self.favouriteVC},
//                    @{@"imgName":@"ic_download",@"itemName":@"Cache",       @"VC":self.downloadVC},
//                    @{@"imgName":@"ic_bell"    ,@"itemName":@"Notification",   @"VC":self.notificationVC},
                    @{@"imgName":@"ic_gear"    ,@"itemName":@"Settings",       @"VC":self.settingsVC},
                    @{@"imgName":@"ic_feedback",@"itemName":@"Feedback"},
                    nil];
    }
    return _arrItem;
}




- (void)reloadUserAccount:(CNAccount *)accout {
    CNAccount *account = [CNDefult shareDefult].account;
    // 判断登录状态
    if (account && [account.status boolValue] == NO) {
        self.labelUser.text         = @"Log in";
        [self.imgvIcon sd_setImageWithURL:nil placeholderImage:[UIImage imageNamed:@"Facebook"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        }];
    }else {
        NSString *imageUrl = [[accout.fbAvatar componentsSeparatedByString:@","] firstObject];
        NSLog(@"%@",imageUrl);
        [self.imgvIcon sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"Facebook"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        }];
        self.labelUser.text = accout.nickname ? accout.nickname : @"Log in";
    }
}

- (void) faceIconBtnClick:(UIButton *)btn {
    CNAccount *account = [CNDefult shareDefult].account;
    // 判断登录状态
    if (account && [account.status boolValue] == YES) {
        return;
    }
    [self faceBookLogin];
}


#pragma mark - NetWorking
- (void)faceBookLogin {
    FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
    weakSelf();
    NSArray *readPermissions =  @[@"public_profile",@"email",@"user_friends"];
    //在这里要把 Facebook 登出了,不然下次不能登录(需要等上次登录 token 失效)
    [login logOut];
    [login logInWithReadPermissions:readPermissions
     
                 fromViewController:self
                            handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
                                if (error) {
//                                    NSLog(@"============Process error = %@",error.localizedDescription);
                                    
                                    [CNUtils showHint:MSG_LOGIN_FAILED hide:TIMER_HIDE_DELAY];
                                } else if (result.isCancelled) {
//                                    NSLog(@"============Cancelled");

                                    [CNUtils showHint:MSG_LOGIN_CAMCELED hide:TIMER_HIDE_DELAY];
                                } else {
//                                    NSLog(@"============Logged in");
                                    NSLog(@" %@",result.token.tokenString);
                                    NSLog(@" %@",result.token.userID);
                                    NSString *accessToken = result.token.tokenString;
                                    NSString *fbUserId = result.token.userID;
                                    [CNDefult shareDefult].fbToken = accessToken;

                                    [weakSelf netLoginFromFBTOKEN:accessToken fbUserId:fbUserId];
                                }
                            }];
    
}

- (void)netLoginFromFBTOKEN:(NSString *)accessToken fbUserId:(NSString *)fbUserId {
    [CNUtils showHODAnimation:YES toView:nil];
    NSString *loginURL = [CNApiManager apiNewsLogin];
    NSLog(@"%@",loginURL);
    //封装参数
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters [@"accessToken"] = accessToken;
    parameters [@"fbUserId"] = fbUserId;
    weakSelf();
    [[CNHttpRequest shareHttpRequest] POST:loginURL parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        NSLog(@"===%@",responseObject);

        
        CNAccount *account = [[CNAccount alloc] init];
        [account yy_modelSetWithJSON:[responseObject objectForKey:@"result"]];
        [CNDefult shareDefult].account = account;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf reloadUserAccount:account];
        });
        [CNUtils removeHOD];
        [CNUtils showHint:MSG_LOGIN_SUCCESS hide:TIMER_HIDE_DELAY];

    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        NSLog(@"en = %@",error);
        NSDictionary *userInfo =  error.userInfo;
        NSData *errorData = [userInfo objectForKey:@"com.alamofire.serialization.response.error.data"];
        NSString *errorStr = [[NSString alloc] initWithData:errorData encoding:NSUTF8StringEncoding];
        NSLog(@"%@",errorStr);
        [CNUtils removeHOD];
        [CNUtils showHint:MSG_LOGIN_FAILED hide:TIMER_HIDE_DELAY];

    }];
}




#pragma mark - -


- (void)viewDidLoad {
    [super viewDidLoad];
    //刷新tableView
    [self.tableView reloadData];
    self.view.backgroundColor = RGB(255, 255, 255);
    
    [self.view addSubview:self.imgviewHeader];
    [self.view sendSubviewToBack:self.imgviewHeader];
    [self.tableView setContentInset:UIEdgeInsetsMake(realImg_h, 0, 0, 0)];
    [self.tableView setSeparatorColor:RGBCOLOR_HEX(0xe0e0e0)];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    _imgviewHeader.top = -realImg_h;
    
    self.tableView.scrollEnabled = NO;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(faceBookLogin) name:NOTI_NEEDLOGIN_POST object:nil];
    CNAccount *accout = [CNDefult shareDefult].account;
    [self reloadUserAccount:accout];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    CNAccount *account = [CNDefult shareDefult].account;
    [self reloadUserAccount:account];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    

}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}


#pragma mark - Table view data source
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return BUILD_MODE == 1 ? 1 : 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return section? 1 : self.arrItem.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"menuCellIdentifer";
    CNMenuDrawerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (!cell) {
        cell = [[CNMenuDrawerTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
//    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    if (indexPath.section == 0) {
        NSDictionary *dict = self.arrItem[indexPath.row];
        [cell setSeparatorInset:UIEdgeInsetsMake(-1, 44 * kRATIO, 1, 40 * kRATIO)];
        cell.imgvHead.image = [UIImage imageNamed:[dict objectForKey:@"imgName"]];
        cell.labelTitle.text =[dict objectForKey:@"itemName"];
    }else if (indexPath.section == 1){
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"serverSettingsCell"];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.text = @"ServerSettins";
        return cell;
    }
    return cell;
}

#pragma mark - Table view delegate

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 5 * kRATIO)];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 5 * kRATIO;
}
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 45 * kRATIO;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        NSDictionary *dict = self.arrItem[indexPath.row];
        
        CNViewController *destVC = [dict objectForKey:@"VC"];
        if (destVC == self.favouriteVC) {
            [CNUtils reportInfo:nil widget:WIDGET_MENU_FAVES_CLICK Evt:evt_click];
                }else if (destVC == self.settingsVC){
            [CNUtils reportInfo:nil widget:WIDGET_MENU_SET_CLICK Evt:evt_click];
        }
        
        if (indexPath.row == 2) {
            //present
            [CNUtils reportInfo:nil widget:WIDGET_MENU_FEEDBACK_CLICK Evt:evt_click];
            //可以发送
            if ([MFMailComposeViewController canSendMail]) {
                
                CNFeedbackViewController *controller = [[CNFeedbackViewController alloc] init];
                [controller setToRecipients:@[@"topnews.feedback@gmail.com"]];
                [controller setSubject:[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"]];
                [controller setMessageBody:self.mailBody isHTML:self.useHTML];
                controller.mailComposeDelegate = controller;
//                [self.mm_drawerController closeDrawerAnimated:YES completion:^(BOOL finished) {
//                }];
                [self presentViewController:controller animated:YES completion:^{
                    
                }];
                
            } else {
                //不可发送
                if ([UIAlertController class]) {
                    UIAlertController *alert= [UIAlertController alertControllerWithTitle:CTFBLocalizedString(@"Error")
                                                                                  message:CTFBLocalizedString(@"Mail no configuration")
                                                                           preferredStyle:UIAlertControllerStyleAlert];
                    
                    UIAlertAction *dismiss = [UIAlertAction actionWithTitle:CTFBLocalizedString(@"Dismiss")
                                                                      style:UIAlertActionStyleCancel
                                                                    handler:^(UIAlertAction *action) {
                                                                        [alert dismissViewControllerAnimated:YES completion:nil];
                                                                    }];
                    
                    [alert addAction:dismiss];
                    [self presentViewController:alert animated:YES completion:nil];
                } else {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:CTFBLocalizedString(@"Error")
                                                                    message:CTFBLocalizedString(@"Mail no configuration")
                                                                   delegate:nil
                                                          cancelButtonTitle:CTFBLocalizedString(@"Dismiss")
                                                          otherButtonTitles:nil];
                    [alert show];
                }
            }

        }else {
            //pish
            [self.mm_drawerController closeDrawerAnimated:YES completion:^(BOOL finished) {
                
            }];
            CNNavigationController *nav = (CNNavigationController *)self.mm_drawerController.centerViewController;
            CNViewController *rootVC = [nav.viewControllers firstObject];
            rootVC.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
            [nav pushViewController:destVC animated:YES];
        }
    }else if (indexPath.section == 1){
        [self debugTapEvent];
    }
}


- (CNViewController *)favouriteVC {
    if (!_favouriteVC) {
        _favouriteVC = [[CNFavouriteViewController alloc] init];
        _favouriteVC.title = @"Bookmarks";
    }
    return _favouriteVC;
}
//- (CNViewController *)downloadVC {
//    if (!_downloadVC) {
//        _downloadVC = [[CNDownloadViewController alloc] init];
//        _downloadVC.title = @"Cache";
//    }
//    return _downloadVC;
//}
//- (CNViewController *)notificationVC {
//    if (!_notificationVC) {
//        _notificationVC = [[CNNotificationViewController alloc] init];
//    }
//    return _notificationVC;
//}
- (CNViewController *)settingsVC {
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

- (CNViewController *)changeserverVC {
    if (!_changeserverVC) {
        _changeserverVC = [[CNChangeServerViewController alloc] init];
    }
    return _changeserverVC;
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

- (void)debugTapEvent {
    [self.mm_drawerController closeDrawerAnimated:YES completion:^(BOOL finished) {
        
    }];
    CNNavigationController *nav = (CNNavigationController *)self.mm_drawerController.centerViewController;
    CNViewController *rootVC = [nav.viewControllers firstObject];
    rootVC.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    [nav pushViewController:self.changeserverVC animated:YES];

}

- (NSString *)mailBody
{
    //    NSString *content = @"";
    NSString *body;
    
    if (self.useHTML) {
        body = [NSString stringWithFormat:@"<style>td {padding-right: 20px}</style>\
                <p>%@</p><br />\
                <table cellspacing=0 cellpadding=0>\
                <tr><td>Device Id:</td><td><b>%@</b></td></tr>\
                <tr><td>Device Name:</td><td><b>%@</b></td></tr>\
                <tr><td>System Version:</td><td><b>%@</b></td></tr>\
                <tr><td>App Name:</td><td><b>%@</b></td></tr>\
                <tr><td>App Version:</td><td><b>%@</b></td></tr>\
                <tr><td>App Language:</td><td><b></b></td></tr>\
                <tr><td>App region:</td><td><b></b></td></tr>\
                <tr><td>--- Please leave your comments below ---:</td><td><b></b></td></tr>\
                </table>",
                [[[UIDevice currentDevice] identifierForVendor] UUIDString],
                [[UIDevice currentDevice] model],
                [UIDevice currentDevice].systemVersion,
                [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"],
                APPVERSION,
                [[NSUserDefaults standardUserDefaults] objectForKey:@"AppleLanguages"]];
    } else {
        body = [NSString stringWithFormat:@"\n\n\n\n\nDevice Id: %@\nDevice Name: %@\nSystem Version: %@\nApp Name: %@\nApp Version: %@\nApp Language %@\nApp  region: %@\n%@",
                [[[UIDevice currentDevice] identifierForVendor] UUIDString],
                [[UIDevice currentDevice] model],
                [UIDevice currentDevice].systemVersion,
                [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"],
                APPVERSION,
                [[NSLocale currentLocale] objectForKey:NSLocaleLanguageCode],
                [[NSLocale currentLocale] objectForKey:NSLocaleCountryCode],
                [NSString stringWithFormat:@"--- Please leave your comments below ---"]
                ];
        
    }
    
    return body;
}


@end
