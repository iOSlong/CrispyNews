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
    
    
//    NSLayoutConstraint *leadCons =  [NSLayoutConstraint constraintsWithVisualFormat:@"" options:NSLayoutFormatAlignAllTop metrics:@{} views:self.view];
//    leadCons.active = YES;
//    
//    [NSLayoutConstraint constraintWithItem:<#(nonnull id)#> attribute:<#(NSLayoutAttribute)#> relatedBy:<#(NSLayoutRelation)#> toItem:<#(nullable id)#> attribute:<#(NSLayoutAttribute)#> multiplier:<#(CGFloat)#> constant:<#(CGFloat)#>]
    
    
    // 设置空显系统push返回 barItem上的标题
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];

}

- (void)setArrowBack:(BOOL)arrowBack {
    _arrowBack = arrowBack;
    if (arrowBack) {
//        [self setNavigationBarItem];
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

#pragma mark - MBProgressHUD Sets
// 这个方法，只在 debug 模式下才会调用弹框 ~
- (void)showHint:(NSString *)hint hide:(CGFloat)delay debug:(BOOL)configure;
{
    NSLog(@"%d",DEBUG_FLAG);
    if (configure && DEBUG_FLAG) {
        [self showHint:hint hide:delay];
    }
}
// 默认不允许操作背景下面的view.
- (void)showHint:(NSString *)hint hide:(CGFloat)delay
{
    BOOL enableBackgroundUserAction = NO;
    // 需要改的地方有点多先在这里拦截.
    if ([hint hasPrefix:@"到底啦"]) {
        enableBackgroundUserAction = YES;
    }
    [self showHint:hint hide:delay enableBackgroundUserAction:enableBackgroundUserAction];
}

- (void)showHint:(NSString *)hint hide:(CGFloat)delay enableBackgroundUserAction:(BOOL)enable
{
    if (!hint || !hint.length) {
        return;
    }
    __block NSString *hintBlock = hint;
    __block BOOL blockEnableBackgroundInteraction = enable;
    dispatch_async(dispatch_get_main_queue(), ^{
        //TBLog(@"show hint loading");
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        // 如果允许操作下面的view, 需要禁用 mb 本身的userInteraction.
        hud.userInteractionEnabled = !blockEnableBackgroundInteraction;
        [hud.detailsLabel setFont:[UIFont systemFontOfSize:15 * kRATIO]];
        [hud setRemoveFromSuperViewOnHide:YES];
        [hud setMode:MBProgressHUDModeText];
        [hud.detailsLabel setText:hintBlock];
        [hud hideAnimated:YES afterDelay:delay];
    });
}



@end
