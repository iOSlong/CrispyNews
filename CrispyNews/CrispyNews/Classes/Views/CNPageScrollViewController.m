//
//  CNPageScrollViewController.m
//  CrispyNews
//
//  Created by xuewu.long on 16/8/9.
//  Copyright © 2016年 letv. All rights reserved.
//

#import "CNPageScrollViewController.h"
#import "CNScrollView.h"
#import "CNSegmentView.h"

@interface CNPageScrollViewController ()<UIScrollViewDelegate>

@property (nonatomic, strong) CNScrollView  *scrollView;
@property (nonatomic, strong) NSMutableArray *muViewControllers;

@end

@implementation CNPageScrollViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.muViewControllers  = [NSMutableArray array];
        _pageIndex              = 0;
    }
    return self;
}
- (CNScrollView *)scrollView {
    if (!_scrollView) {
        CGFloat scrollH = self.view.height - 64 - [CNSegmentView segmentHeight];
        _scrollView = [[CNScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREENW, scrollH)];
        [_scrollView setContentSize:CGSizeMake(SCREENW * 3, scrollH)];
        _scrollView.backgroundColor = [UIColor blueColor];
        _scrollView.pagingEnabled   = YES;
        _scrollView.delegate        = self;
    }
    return _scrollView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.scrollView];
}

- (void)setViewControllers:(NSArray *)viewControllers {
    _viewControllers = viewControllers;
    if (viewControllers && viewControllers.count) {
        [self.muViewControllers removeAllObjects];
        [self.muViewControllers addObjectsFromArray:viewControllers];
        [self reloadViewControllers];
    }
}


- (void)addViewController:(UIViewController *)viewController {
    if (viewController) {
        [self.muViewControllers addObject:viewController];
        [self addChildViewController:viewController];
        viewController.view.size    = self.scrollView.size;
        viewController.view.x       = self.scrollView.width * ([self.muViewControllers count]-1);
        [self.scrollView addSubview:viewController.view];
        [self.scrollView setContentSize:CGSizeMake(self.scrollView.width * self.muViewControllers.count, self.scrollView.height)];
    }
}

- (void)insertViewController:(UIViewController *)viewController atIndex:(NSInteger)index {
    if (viewController && index <= self.muViewControllers.count) {
        for (NSInteger i = index; i<self.muViewControllers.count; i++) {
            UIViewController *locVC = self.muViewControllers[i];
            locVC.view.x += self.scrollView.width;
        }
        [self.muViewControllers insertObject:viewController atIndex:index];
        [self addViewController:viewController];
        viewController.view.size    = self.scrollView.size;
        viewController.view.x       = index * self.scrollView.width;
        [self.scrollView addSubview:viewController.view];
    }
}

- (void)insertViewControllers:(NSArray<UIViewController *> *)viewControllers atIndex:(NSInteger)index {
    if (viewControllers && index <= self.muViewControllers.count) {
        for (NSInteger i = index; i<self.muViewControllers.count; i++) {
            UIViewController *locVC = self.muViewControllers[i];
            locVC.view.x += self.scrollView.width * viewControllers.count;
        }
    }
    for (NSInteger i = 0; i<viewControllers.count; i++) {
        UIViewController *activeVC = viewControllers[i];
        [self.muViewControllers insertObject:activeVC atIndex:index];
        [self addViewController:activeVC];
        activeVC.view.size    = self.scrollView.size;
        activeVC.view.x       = (index+i)* self.scrollView.width;
        [self.scrollView addSubview:activeVC.view];
    }
}

- (void)reloadViewControllers {
    for (UIViewController *childVC in self.childViewControllers) {
        [childVC removeFromParentViewController];
    }
    
    for (int i = 0; i < self.muViewControllers.count; i++) {
        UIViewController *childVC = self.muViewControllers[i];
        [self addChildViewController:childVC];
        
        childVC.view.size   = self.scrollView.size;
        childVC.view.x      = self.scrollView.width * i;
        [self.scrollView addSubview:childVC.view];
    }
    [self.scrollView setContentSize:CGSizeMake(self.scrollView.width * self.muViewControllers.count, self.scrollView.height)];
}




- (void)setSelectedIndex:(NSInteger)pageIndex animation:(BOOL)animation {
    if (pageIndex < self.muViewControllers.count) {
        [self.scrollView setContentOffset:CGPointMake(self.scrollView.width * pageIndex, 0) animated:animation];
        _pageIndex = pageIndex;
    }
}

#pragma mark ScrollView Delegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSInteger index = scrollView.contentOffset.x/scrollView.width;
    _pageIndex = index;
    if ([self.pageScrollDelegate respondsToSelector:@selector(pageScrollViewController:page:)]) {
        [self.pageScrollDelegate pageScrollViewController:self.muViewControllers[index] page:index];
    }
}

@end
