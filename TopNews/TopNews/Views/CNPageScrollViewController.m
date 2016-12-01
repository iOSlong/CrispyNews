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


typedef struct CNPageScroll {
    NSInteger currentPageIndex;
    NSInteger offsetLocation;
    NSInteger starPageIndex;
    NSInteger endPageIndex;
}CNPageScroll;

typedef NS_ENUM(NSUInteger, CNOffSetPreference) {
    CNOffSetPreferenceLeft      = 0,
    CNOffSetPreferenceCenter    = 1,
    CNOffSetPreferenceRight     = 2,
    CNOffSetPreferenceKeep      = 4,
};

@interface CNPageScrollViewController ()<UIScrollViewDelegate>

@property (nonatomic, strong) CNScrollView      *scrollView;
@property (nonatomic, strong) NSMutableArray <UIViewController *> *muViewControllers;
@property (nonatomic, strong) NSMutableArray <UIViewController *> *activeViewControllers;
@property (nonatomic, strong) UIViewController  *currentViewController;
@end

@implementation CNPageScrollViewController {
    NSInteger           _minFixCount;
    CNPageScroll        _pageScroll;
    CNOffSetPreference  _offSetPre;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.muViewControllers      = [NSMutableArray array];
        self.activeViewControllers  = [NSMutableArray array];
        _pageIndex                  = 0;
        _pageCount                  = 0;
    }
    return self;
}
- (CNScrollView *)scrollView {
    if (!_scrollView) {
        CGFloat scrollH = self.view.height - 64 - [CNSegmentView segmentHeight];
        _scrollView = [[CNScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREENW, scrollH)];
        [_scrollView setContentSize:CGSizeMake(SCREENW * 3, scrollH)];
        _scrollView.backgroundColor = [UIColor clearColor];
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
        [self.activeViewControllers removeAllObjects];

        [self.muViewControllers addObjectsFromArray:viewControllers];
        
    }
    [self displayChildViewControllers];
}

- (void)displayChildViewControllers {
    _pageCount = self.muViewControllers.count;
    _minFixCount = self.muViewControllers.count >=3 ? 3 : self.muViewControllers.count;
    
    for (UIViewController *activeVC in self.muViewControllers) {
        [self.activeViewControllers addObject:activeVC];
        if (self.activeViewControllers.count == _minFixCount) {
            break;
        }
    }
    
    [self.scrollView setContentSize:CGSizeMake(self.scrollView.width * self.activeViewControllers.count, self.scrollView.height)];
    
    
    _pageScroll.endPageIndex        = _minFixCount -1;
    _pageScroll.starPageIndex       = 0;
    _pageScroll.currentPageIndex    = 0;
    _pageScroll.offsetLocation      = 0;
    
    [self reloadChildViewControllersOffSetPre:CNOffSetPreferenceLeft animation:NO];
}

- (void)addViewController:(UIViewController *)viewController {
    if (viewController) {
        [self.muViewControllers addObject:viewController];
        if (self.activeViewControllers.count == 3)
        {
            
        }
        else
        {
            if (self.activeViewControllers.count)
            {
                _pageScroll.endPageIndex        = self.activeViewControllers.count;
            }
            else
            {
                _pageScroll.starPageIndex       = 0;
                _pageScroll.endPageIndex        = 0;
                _pageScroll.currentPageIndex    = 0;
                _pageScroll.offsetLocation      = 0;
                _pageIndex                      = 0;
                self.currentViewController      = viewController;
            }
            [self.activeViewControllers addObject:viewController];
            _minFixCount = self.activeViewControllers.count;
            
            [self.scrollView setContentSize:CGSizeMake(self.scrollView.width * self.activeViewControllers.count, self.scrollView.height)];
            [self reloadChildViewControllersOffSetPre:CNOffSetPreferenceKeep animation:NO];
        }
    }
}

- (void)insertViewController:(UIViewController *)viewController atIndex:(NSInteger)index {
    if (viewController && index <= self.muViewControllers.count) {
        [self.muViewControllers insertObject:viewController atIndex:index];
        [self displayChildViewControllers];
        [self setSelectedIndex:_pageIndex animation:NO];
    }
}

- (void)insertViewControllers:(NSArray<UIViewController *> *)viewControllers atIndex:(NSInteger)index {
    if (viewControllers && index <= self.muViewControllers.count) {
        NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(index, viewControllers.count)];
        if (self.muViewControllers.count) {
            [self.muViewControllers insertObjects:viewControllers atIndexes:indexSet];

        }else{
            [self.muViewControllers insertObjects:viewControllers atIndexes:indexSet];
            [self displayChildViewControllers];
            [self setSelectedIndex:0 animation:NO];
        }
    }
}


- (BOOL)isChildViewController:(UIViewController *)sourceVC {
    for (UIViewController *childVC in self.childViewControllers) {
        if (childVC == sourceVC) {
            return YES;
        }
    }
    return NO;
}

- (BOOL)isBelongToActiveViewController:(UIView *)subView {
    for (UIViewController *activeVC in self.activeViewControllers) {
        if (activeVC.view == subView) {
            return YES;
        }
    }
    return NO;
}

- (void)setSelectedIndex:(NSInteger)pageIndex animation:(BOOL)animation {
    if (pageIndex < self.muViewControllers.count)
    {
        if (pageIndex == self.pageIndex+1)
        {
            [self.scrollView setContentOffset:CGPointMake(self.scrollView.contentOffset.x + self.scrollView.width, 0) animated:animation];
            _pageIndex = pageIndex;
        }
        else if (pageIndex == self.pageIndex - 1)
        {
            [self.scrollView setContentOffset:CGPointMake(self.scrollView.contentOffset.x - self.scrollView.width, 0) animated:animation];
            _pageIndex = pageIndex;
        }
        else
        {
            [self.activeViewControllers removeAllObjects];
            
            if (pageIndex == self.muViewControllers.count - 1)
            {
                [self.activeViewControllers addObjectsFromArray:[self.muViewControllers subarrayWithRange:NSMakeRange(self.muViewControllers.count - _minFixCount, _minFixCount)]];
                
                _pageScroll.endPageIndex        = pageIndex;
                _pageScroll.starPageIndex       = pageIndex - (_minFixCount - 1);
                _pageScroll.currentPageIndex    = pageIndex; //- (self.muViewControllers.count > 1 ? 1 : 0);
                _pageScroll.offsetLocation      = _minFixCount - 1;
                _pageIndex                      = pageIndex;
                [self reloadChildViewControllersOffSetPre:CNOffSetPreferenceRight animation:NO];
                
            }
            else if (pageIndex == 0)
            {
                [self.activeViewControllers addObjectsFromArray:[self.muViewControllers subarrayWithRange:NSMakeRange(0, _minFixCount)]];
                
                _pageScroll.endPageIndex        = _minFixCount - 1;
                _pageScroll.starPageIndex       = 0;
                _pageScroll.currentPageIndex    = pageIndex;
                _pageScroll.offsetLocation      = 0;
                _pageIndex                      = 0;
                [self reloadChildViewControllersOffSetPre:CNOffSetPreferenceLeft animation:NO];
                
            }
            else
            {
                [self.activeViewControllers addObjectsFromArray:[self.muViewControllers subarrayWithRange:NSMakeRange(pageIndex-1, _minFixCount)]];
                
                _pageScroll.endPageIndex        = pageIndex + 1;
                _pageScroll.starPageIndex       = pageIndex - 1;
                _pageScroll.currentPageIndex    = pageIndex;
                _pageScroll.offsetLocation      = 1;
                _pageIndex                      = pageIndex;
                [self reloadChildViewControllersOffSetPre:CNOffSetPreferenceCenter animation:NO];
            }
        }
    }
}

- (void)reloadChildViewControllersOffSetPre:(CNOffSetPreference)offSetPre animation:(BOOL)animation {
    self.scrollView.userInteractionEnabled = NO;
    for (UIView *subView in self.scrollView.subviews) {
        if (![self isBelongToActiveViewController:subView]) {
            [subView removeFromSuperview];
        }
    }
    
    for (int i = 0; i < self.activeViewControllers.count; i++) {
        UIViewController *activeVC = self.activeViewControllers[i];
        if (![self isChildViewController:activeVC])
        {
            [self addChildViewController:activeVC];
        }
        activeVC.view.size   = self.scrollView.size;
        activeVC.view.x      = self.scrollView.width * i;
        /// TODO  视图控制器的周期函数，从addSubView开始，而不是View显示在设备上见着！  need make some research！
        [self.scrollView addSubview:activeVC.view];
    }
    
    NSInteger locIndex = 0;
    if (offSetPre == CNOffSetPreferenceLeft) {
        self.currentViewController  = [self.activeViewControllers firstObject];
        locIndex = 0;

    }else if (offSetPre == CNOffSetPreferenceCenter) {
        self.currentViewController  = [self.activeViewControllers objectAtIndex:1];
        locIndex = 1;

    }else if (offSetPre == CNOffSetPreferenceRight) {
        self.currentViewController  = [self.activeViewControllers lastObject];
        locIndex = _minFixCount - 1;
    }
    
    if (offSetPre == CNOffSetPreferenceKeep) {
        
    }else{
        [self.scrollView setContentOffset:CGPointMake(self.scrollView.width * locIndex, 0) animated:animation];
    }
    
    self.scrollView.userInteractionEnabled = YES;
//    [self.scrollView addSubview:self.currentViewController.view];
    
}



#pragma mark ScrollView 自由滚动介绍之后调用（非手动拖拽动画）
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    _pageScroll.offsetLocation = scrollView.contentOffset.x/scrollView.width;
    if (_pageScroll.offsetLocation == 0)
    {
        if (_pageIndex == 0)
        {
            _pageScroll.currentPageIndex    = _pageIndex;
            self.currentViewController      = self.activeViewControllers[0];
        }
        else
        {
            _pageScroll.currentPageIndex    = _pageIndex;
            _pageScroll.starPageIndex       = _pageIndex - 1;
            _pageScroll.endPageIndex        = _pageIndex + 1;
            
            UIViewController *headVC = self.muViewControllers[_pageScroll.starPageIndex];

            [self.activeViewControllers insertObject:headVC atIndex:0];
            [self.activeViewControllers removeLastObject];

            
            [self reloadChildViewControllersOffSetPre:CNOffSetPreferenceCenter animation:NO];
        }
    }
    else if (_pageScroll.offsetLocation == 1)
    {
        _pageScroll.currentPageIndex    = _pageIndex;
        self.currentViewController      = self.activeViewControllers[1];
    }
    else if (_pageScroll.offsetLocation == 2)
    {
        if (_pageIndex + 1 >= self.muViewControllers.count) {
            _pageScroll.currentPageIndex    = _pageIndex;
            _pageScroll.starPageIndex       = _pageIndex - 2;
            _pageScroll.endPageIndex        = _pageIndex;
            self.currentViewController      = [self.activeViewControllers lastObject];
        }
        else
        {
            _pageScroll.currentPageIndex    = _pageIndex;
            _pageScroll.endPageIndex        = _pageIndex + 1;
            _pageScroll.starPageIndex       = _pageIndex - 1;
            
            UIViewController *tailVC = self.muViewControllers[_pageScroll.endPageIndex];
            
            [self.activeViewControllers addObject:tailVC];
            
            [self.activeViewControllers removeObjectAtIndex:0];
            
            [self reloadChildViewControllersOffSetPre:CNOffSetPreferenceCenter animation:NO];
        }
    }
}


#pragma mark 拖动ScrollView ， 滚动停止时候的代理函数
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    _pageScroll.offsetLocation = scrollView.contentOffset.x/scrollView.width;

    if (_pageScroll.offsetLocation == 0)
    {
        if (_pageScroll.starPageIndex == 0)
        {
            _pageScroll.currentPageIndex = 0;
            self.currentViewController   = self.muViewControllers[0];
            
        }
        else
        {
            _pageScroll.currentPageIndex --;
            _pageScroll.starPageIndex --;
            _pageScroll.endPageIndex --;
            
            UIViewController *headVC = self.muViewControllers[_pageScroll.starPageIndex];
            
            [self.activeViewControllers insertObject:headVC atIndex:0];
            [self.activeViewControllers removeLastObject];
            
            [self reloadChildViewControllersOffSetPre:CNOffSetPreferenceCenter animation:NO];

        }
        
        _pageIndex = _pageScroll.currentPageIndex;
    }
    else if (_pageScroll.offsetLocation == 1)
    {
        _pageScroll.currentPageIndex    = _pageScroll.starPageIndex + 1;
        self.currentViewController      = self.activeViewControllers[1];
        _pageIndex = _pageScroll.currentPageIndex;

    }
    else if (_pageScroll.offsetLocation == 2)
    {
        if (_pageScroll.endPageIndex + 1 >= self.muViewControllers.count) {
            _pageIndex = _pageScroll.endPageIndex;
        }
        else
        {
            _pageScroll.endPageIndex ++     ;
            _pageScroll.starPageIndex ++    ;
            _pageScroll.currentPageIndex ++ ;
            
            UIViewController *tailVC = self.muViewControllers[_pageScroll.endPageIndex];

            [self.activeViewControllers addObject:tailVC];
            
            [self.activeViewControllers removeObjectAtIndex:0];
            
            [self reloadChildViewControllersOffSetPre:CNOffSetPreferenceCenter animation:NO];
            
            _pageIndex = _pageScroll.currentPageIndex;

        }
    }
    
    if ([self.pageScrollDelegate respondsToSelector:@selector(pageScrollViewController:page:)]) {
        [self.pageScrollDelegate pageScrollViewController:self.muViewControllers[_pageIndex] page:_pageIndex];
    }
}

@end
