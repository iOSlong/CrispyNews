//
//  HomeNewsViewController.m
//  CrispyNews
//
//  Created by 陈肖坤 on 16/7/25.
//  Copyright © 2016年 陈肖坤. All rights reserved.
//

#import "CNHomeNewsViewController.h"
#import "CNSegmentView.h"
#import "AppDelegate.h"
#import "CNNewsThemeSetViewController.h"
#import "CNPageScrollViewController.h"
#import "CNNewsListViewController.h"
#import "CNNewsDetailViewController.h"


@interface CNHomeNewsViewController ()<UICollectionViewDelegate,CNPageScrollViewControllerDelegate>

@property (nonatomic, strong) CNDataManager *cnDM;
@property (nonatomic, strong) CNSegmentView *segmentView;
@property (nonatomic, strong) CNPageScrollViewController  *pageScrollViewController;
@property (nonatomic, strong) NSMutableArray<CNTheme *> *muArrChannelTheme;
@property (nonatomic, strong) NSMutableArray<CNTheme *> *muArrRecommend;
@property (nonatomic, strong) NSArray <CNTheme *> *arrAllTheme;


@end

@implementation CNHomeNewsViewController
- (NSArray<CNTheme *> *)arrAllTheme {
    if (!_arrAllTheme) {
        _arrAllTheme =  _cnDM.arrOfThemeModel;
        if (_arrAllTheme.count == 0) {
            NSArray *titleArr = @[@"American",@"two",@"American",@"English",@"India",@"Chinese",@"more"];
            for (int i = 1; i <= titleArr.count; i++) {
                CNTheme *theme = [NSEntityDescription insertNewObjectForEntityForName:@"CNTheme" inManagedObjectContext:_cnDM.managedObjectContext];
                theme.themeId   = [NSNumber numberWithInt:arc4random()%titleArr.count];
                theme.themeName = titleArr[i-1];
                theme.themeChannel = [NSNumber numberWithBool:YES];
            }
            
            titleArr = @[@"banana",@"apple",@"pease",@"unbremna",@"peak",@"tortate",@"new money",@"helloMan",@"spider",@"pig",@"dog",@"elephant",@"lion",@"big cat",@"showman",@"superPob",@"healer"];
            
            for (int i = 1; i <= titleArr.count; i++) {
                CNTheme *theme = [NSEntityDescription insertNewObjectForEntityForName:@"CNTheme" inManagedObjectContext:_cnDM.managedObjectContext];
                theme.themeId   = [NSNumber numberWithInt:arc4random()%titleArr.count];
                theme.themeName = titleArr[i-1];
                theme.themeChannel = [NSNumber numberWithBool:NO];
            }
            NSError *error = nil;
            [_cnDM.managedObjectContext save:&error];
            if (error) {
                NSLog(@"fail storn charModel  :%@",error);
            }else{
                NSLog(@"success storne");
            }
        }
        _arrAllTheme =  _cnDM.arrOfThemeModel;
    }
    return _arrAllTheme;
}

- (NSMutableArray<CNTheme *> *)muArrChannelTheme {
    if (!_muArrChannelTheme) {
        _muArrChannelTheme = [NSMutableArray array];
        for (CNTheme *theme in self.arrAllTheme) {
            if ([theme.themeChannel boolValue]) {
                [_muArrChannelTheme addObject:theme];
            }
        }
    }
    return _muArrChannelTheme;
}

- (NSMutableArray<CNTheme *> *)muArrRecommend {
    if (!_muArrRecommend) {
        _muArrRecommend = [NSMutableArray array];
        for (CNTheme *theme in self.arrAllTheme) {
            if ([theme.themeChannel boolValue] == NO) {
                [_muArrRecommend addObject:theme];
            }
        }
    }
    return _muArrRecommend;
}


- (CNPageScrollViewController *)pageScrollViewController {
    if (!_pageScrollViewController) {
        _pageScrollViewController = [[CNPageScrollViewController alloc] init];
        _pageScrollViewController.pageScrollDelegate = self;
    }
    return _pageScrollViewController;
}

- (void)pageScrollViewController:(UIViewController *)currentViewController page:(NSInteger)pageIndex {
    self.segmentView.selectedIndex = pageIndex;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configureNavBar];
    self.view.backgroundColor = RGBCOLOR_HEX(0xfefefe);
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    _cnDM = [CNDataManager shareDataController];
    if (self.arrAllTheme.count) {
        NSLog(@"self.arrALL.cout = %lu",(unsigned long)self.arrAllTheme.count);
    }
    
    
    NSMutableArray *themeNameArr = [NSMutableArray array];
    for (CNTheme *theme in self.muArrChannelTheme) {
        [themeNameArr addObject:theme.themeName];
    }
    self.segmentView = [[CNSegmentView alloc] initWithFrame:CGRectMake(0, 64, SCREENW, [CNSegmentView segmentHeight])];
    [self.segmentView cn_segBlock:^(NSInteger selectedIndex, CNSegmentEvent segEvent) {
        if (segEvent == CNSegmentEventAddClick) {
            [self showChannelSetView];
        }else if (segEvent == CNSegmentEventItemClick){
            [self.pageScrollViewController setSelectedIndex:selectedIndex animation:YES];
        }
    }];
    self.segmentView.arrItem = themeNameArr;
    [self.view addSubview:self.segmentView];
    
    //    [self.view addSubview:self.scrollView];
    
    [self addChildViewController:self.pageScrollViewController];
    [self.view addSubview:self.pageScrollViewController.view];
    self.pageScrollViewController.view.top = 64 + self.segmentView.height;
    [self.view bringSubviewToFront:self.segmentView];
    
    for (int i = 0; i< self.muArrChannelTheme.count; i ++) {
        CNNewsListViewController *textVC = [[CNNewsListViewController alloc] init];
        [self.pageScrollViewController addViewController:textVC];
    }
}

- (void)showChannelSetView {
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    
    CNNewsThemeSetViewController *newsThemeSetVC = [[CNNewsThemeSetViewController alloc] init];
    newsThemeSetVC.muArrChannelTheme    = self.muArrChannelTheme;
    newsThemeSetVC.muArrRecommend       = self.muArrRecommend;
    [self.navigationController pushViewController:newsThemeSetVC animated:YES];
    
}

- (void)configureNavBar
{
    self.title = @"CrispyNews";
    CNBarButtonItem *menuItem = [[CNBarButtonItem alloc] barButtomItem:@"menu"];
    [menuItem barBlock:^(CNBarButtonItem *barBItem) {
        NSLog(@"menu click");
        AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        if (appDelegate.crispyMenu.openSide == MMDrawerSideNone) {
            [appDelegate.crispyMenu openDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
        }else{
            [appDelegate.crispyMenu closeDrawerAnimated:YES completion:nil];
        }
    }];
    UIBarButtonItem *leftSpaceItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    leftSpaceItem.width =  iPhone6Plus? -15:-8;
    self.navigationItem.leftBarButtonItems = @[leftSpaceItem,menuItem];
    
    
    CNBarButtonItem *editItem = [[CNBarButtonItem alloc] barButtomItem:@"Edit"];
    [editItem barBlock:^(CNBarButtonItem *barBItem) {
        NSLog(@"Edit Click");
        //        [self showChannelSetView];
        self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
        CNNewsDetailViewController *_newsDetail = [[CNNewsDetailViewController alloc] init];
        [self.navigationController pushViewController:_newsDetail animated:YES];
    }];
    UIBarButtonItem *rightSpaceItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    rightSpaceItem.width =  iPhone6Plus? -15:-8;
    self.navigationItem.rightBarButtonItems = @[rightSpaceItem,editItem];
    
    
}




@end
