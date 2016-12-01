//
//  CNPageViewController.m
//  CrispyNews
//
//  Created by xuewu.long on 16/8/9.
//  Copyright © 2016年 letv. All rights reserved.
//

#import "CNPageViewController.h"
#import "CNHomeNewsViewController.h"
#import "CNViewController.h"


@interface CNPageViewController ()<UIGestureRecognizerDelegate>

@property (nonatomic, strong) NSMutableArray *arrViewController;
@property (nonatomic, strong) CNViewController *currentVC;

@end

@implementation CNPageViewController

- (NSMutableArray *)arrViewController {
    if (!_arrViewController) {
        _arrViewController = [NSMutableArray array];
        [_arrViewController addObject:[[CNViewController alloc]init]];
        [_arrViewController addObject:[[CNViewController alloc]init]];
        [_arrViewController addObject:[[CNViewController alloc]init]];
        [_arrViewController addObject:[[CNViewController alloc]init]];
    }
    return  _arrViewController;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.delegate   = self;
    self.dataSource = self;
    
    [self setViewControllers:@[[self.arrViewController objectAtIndex:1]] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:NULL];

    
    for (UIGestureRecognizer *recognizer in self.gestureRecognizers) {
        NSLog(@"recognizer = %@",recognizer);
    }
    for (UIView *view in self.view.subviews ) {
        if ([view isKindOfClass:[UIScrollView class]]) {
            UIScrollView *scroll = (UIScrollView *)view;
            for (UIGestureRecognizer *gest in scroll.gestureRecognizers) {
                if ([gest isKindOfClass:[UIPanGestureRecognizer class]]) {
                    gest.delegate = self;
                }
            }
//            scroll.panGestureRecognizer.delegate = self;
//            scroll.delegate = self;
//            scroll.bounces = NO;
        }
    }
}

//- 

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    int index = (int)[self.arrViewController indexOfObject:viewController];
    if (index<[self.arrViewController count]-1) {
        _currentVC = [self.arrViewController objectAtIndex:index+1];
        return _currentVC;
    }else{
        return nil;
    }
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    int index = (int)[self.arrViewController indexOfObject:viewController];
    
    if (index>0) {
        return [self.arrViewController objectAtIndex:index-1];
    }else{
        return nil;
    }
}



@end
