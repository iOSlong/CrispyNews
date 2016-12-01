//
//  CNNotificationViewController.m
//  CrispyNews
//
//  Created by xuewu.long on 16/8/8.
//  Copyright © 2016年 letv. All rights reserved.
//

#import "CNNotificationViewController.h"
#import "CNImageView+CN.h"

@interface CNNotificationViewController ()
@property (nonatomic, strong) CNImageView *fmyImageView;

@end

@implementation CNNotificationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Notification";
    self.arrowBack = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.fmyImageView = [[CNImageView alloc] initWithFrame:CGRectMake(100, 250, 100, 100)];
    self.fmyImageView.backgroundColor = [UIColor blueColor];
    [self.view addSubview:self.fmyImageView];

    NSURL *url = [NSURL URLWithString:@"http://difang.kaiwind.com/tianjin/kpydsy/201404/04/W020140404408118575474.jpg"];
    [self.fmyImageView cn_setImageWithURL:url completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        NSLog(@"");
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
