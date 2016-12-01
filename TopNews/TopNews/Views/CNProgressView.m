//
//  CNProgressView.m
//  TopNews
//
//  Created by xuewu.long on 16/11/17.
//  Copyright © 2016年 levt. All rights reserved.
//

#import "CNProgressView.h"

@interface CNProgressView ()
@property (nonatomic, strong) NSTimer *timer;
@end

@implementation CNProgressView{
    CGFloat _temprogress;
    CGFloat _step;
}

- (UIProgressView *)progressView{
    if (!_progressView) {
        _progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0,0, self.width, 2)];
        _progressView.center = CGPointMake(self.width * 0.5, self.height * 0.5);
        _progressView.tintColor = [UIColor whiteColor];
        _progressView.progressTintColor = [UIColor greenColor];
        _progressView.trackTintColor = [UIColor whiteColor];
        _progressView.progress = 0.05;
    }
    return _progressView;
}


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.progressView];
        _temprogress = 0;
        
        _timer = [NSTimer scheduledTimerWithTimeInterval:0.003 target:self selector:@selector(timerEvent:) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
        [_timer setFireDate:[NSDate distantFuture]];
        
    }
    return self;
}


- (void)timerEvent:(NSTimer *)timer{
    _temprogress += _step;
    self.progressView.progress = _temprogress;
    if (_step > 0) {
        if (_temprogress >= 1 || _temprogress >= _progress) {
            [timer setFireDate:[NSDate distantFuture]];
            self.progressView.progress = _temprogress >= 1 ? 0 : _temprogress;
        }
    }else {
        if (_temprogress <= 0 || _temprogress <= _progress){
            [timer setFireDate:[NSDate distantFuture]];
        }
    }
}

- (void)setProgress:(CGFloat)progress{
    [self.progressView setHidden:NO];
    _temprogress = _progress;
    if (_progress > progress) {
        _step = (progress - _progress)/80;
    }else if (_progress < progress){
        _step = (progress - _progress)/80;
    }
    _progress = progress;
    if (_timer) {
        [_timer setFireDate:[NSDate distantPast]];
    }
}

- (void)dealloc {
    [self.timer invalidate];
    self.timer = nil;
}

@end















