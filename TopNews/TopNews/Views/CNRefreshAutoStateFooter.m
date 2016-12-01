//
//  CNRefreshAutoStateFooter.m
//  TopNews
//
//  Created by xuewu.long on 16/9/13.
//  Copyright © 2016年 levt. All rights reserved.
//

#import "CNRefreshAutoStateFooter.h"

@interface CNRefreshAutoStateFooter ()
@property (nonatomic, strong) UIImageView *imgvBar;
@property (nonatomic, strong) UIView *view_footerBar;
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicatorView;

@end

@implementation CNRefreshAutoStateFooter

//-(UIView *)view_footerBar{
//    if (!_view_footerBar) {
//        
//        _view_footerBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.mj_w, self.mj_h)];
//        
//        UIImage *imgTigerBar = [UIImage imageNamed:@"bar_head"];
//        CGFloat img_w = CGImageGetWidth(imgTigerBar.CGImage)/2;
//        CGFloat img_h = CGImageGetHeight(imgTigerBar.CGImage)/2;
//        
//        CGFloat bar_w = 80.0;
//        CGFloat bar_h = bar_w * img_h/img_w;
//        
//        
//        _imgvBar = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, bar_w, bar_h)];
//        _imgvBar.image      = imgTigerBar;
//        _imgvBar.centerY    = _view_footerBar.height * 0.5;
//        
//        [_view_footerBar addSubview:_imgvBar];
//        _view_footerBar.backgroundColor = [UIColor orangeColor];
//        
//    }
//    return _view_footerBar;
//}
//
- (void)prepare{
    [super prepare];
    
//    [self setTitle:MJRefreshAutoFooterNoMoreDataText forState:MJRefreshStateNoMoreData];
    [self setTitle:MJRefreshAutoFooterRefreshingText forState:MJRefreshStateRefreshing];
//    self.stateLabel.textColor = [UIColor whiteColor];
    //    self.backgroundColor = [UIColor purpleColor];
    
    [self setTitle:MSG_NEWSLIST_NOMORENEWS forState:MJRefreshStateNoMoreData];
    [self setTitle:@"loading..." forState:MJRefreshStateRefreshing];
    [self setTitle:@"Tap or pull up to load more" forState:MJRefreshStateIdle];

    
    
    self.mj_h = 50.0;
    /*默认为1，表示底部刷新控件出现时候开始触动刷新，-3表明距离刷新控件3个高度值得时候就开始触动刷新。这里150个高度值。*/
    self.triggerAutomaticallyRefreshPercent = -2.0;
    
//    [self addSubview:self.view_footerBar];
}

- (void)setCnState:(CNRefreshFooterState)cnState {
    CNRefreshFooterState oldState = self.cnState;
    if (cnState == oldState) return;
    switch (cnState) {
        case CNRefreshFooterStateIdle:
        {
            
        }
            break;
        case CNRefreshFooterStateNoMoreData:
        {
            [self setTitle:MSG_NEWSLIST_NOMORENEWS forState:MJRefreshStateNoMoreData];
        }
            break;
        case CNRefreshFooterStateWillRefresh:
        {
            
        }
            break;
        case CNRefreshFooterStateRefreshing:
        {
            
        }
            break;
        case CNRefreshFooterStateEmptyData:
        case CNRefreshFooterStateBlankInfo:
        {
            [self setTitle:@"" forState:MJRefreshStateNoMoreData];
        }
            break;
case CNRefreshFooterStatePulling:
        {
            
        }
            break;
        default:
            break;
    }
    
    if (cnState == CNRefreshFooterStateKeeping) {
        
    }else{
        [super setState:cnState];
    }
}


//
//-(void)placeSubviews{
//    [super placeSubviews];
//    
//    
//    _imgvBar.centerX    = [UIScreen mainScreen].bounds.size.width * 0.5;
//    
//}
//
//-(void)setState:(MJRefreshState)state{
//    MJRefreshCheckState
//
//    switch (state) {
//        case MJRefreshStateIdle:{
//            [self.stateLabel setHidden:NO];
//            [self.view_footerBar setHidden:YES];
//        }
//            break;
//        case MJRefreshStateRefreshing:{
//            [self.stateLabel setHidden:NO];
//            [self.view_footerBar setHidden:YES];
//            
//        }
//            break;
//        case MJRefreshStateNoMoreData:{
//            
//            [self.stateLabel setHidden:YES];
////            [self.view_footerBar setHidden:NO];
////            [self sendSubviewToBack:self.view_footerBar];
//            
////            CGFloat contentSize_h = self.scrollView.contentSize.height;
////            [self.scrollView setContentSize:CGSizeMake(self.scrollView.contentSize.width, contentSize_h-self.mj_h)];
////            self.top = contentSize_h;
//        }
//            break;
//        default:
//            break;
//    }
//}

@end
