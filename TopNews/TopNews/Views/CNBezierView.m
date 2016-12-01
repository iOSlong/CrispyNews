//
//  CNBezierView.m
//  TopNews
//
//  Created by xuewu.long on 16/9/27.
//  Copyright © 2016年 levt. All rights reserved.
//

#import "CNBezierView.h"

@interface CNBezierView ()
@property (nonatomic, strong) CAShapeLayer *bottomLayer;
@property (nonatomic, strong) CAShapeLayer *maskLayer;
@property (nonatomic, strong) UILabel *labelInfo;
@property (nonatomic, strong) NSTimer *timer;

@end

@implementation CNBezierView{
    CGFloat _cornerR;
    CGFloat _halfInW;
    CGFloat _boundsW;
    CGFloat _borderW;
    CGFloat _distance;
    
    CGFloat _latestPro;
    NSTimer *_proTimer;
    BOOL    _inAnimation;
    
    CGFloat _temprogress;
    CGFloat _step;
    
}

- (instancetype)initWithFrame:(CGRect)frame andType:(CNBezierViewType)type {
    _Type = type;
    self = [super initWithFrame:frame];
    if (self) {
        if (_Type == CNBezierViewTypeProgressItem) {
            _labelInfo = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.width,12)];
            _labelInfo.textColor = RGBCOLOR_HEX(0xffffff);
            _labelInfo.font      = [UIFont systemFontOfSize:8];
            _labelInfo.textAlignment = NSTextAlignmentCenter;
            _labelInfo.centerY = self.height * 0.5;
            [self addSubview:_labelInfo];
            [self setProgressItemWithProgress:0];
            
            _timer = [NSTimer scheduledTimerWithTimeInterval:0.003 target:self selector:@selector(tiemrEvent:) userInfo:nil repeats:YES];
            [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
            [_timer setFireDate:[NSDate distantFuture]];

        }
    }
    return self;
}

- (void)tiemrEvent:(NSTimer *)timer {
    _temprogress += _step;
    [self addMaskLayerWithRatio:_temprogress];
    if (_step > 0) {
        if (_temprogress >= 1 || _temprogress >= _progress) {
            [timer setFireDate:[NSDate distantFuture]];
            [self addMaskLayerWithRatio:_temprogress >= 1 ? 0 : _temprogress];
        }
    }else {
        if (_temprogress <= 0 || _temprogress <= _progress){
            [timer setFireDate:[NSDate distantFuture]];
        }
    }
    if (_progress != 0) {
        _labelInfo.text = [NSString stringWithFormat:@"%.0f%%",_progress * 100];
    }else{
        _labelInfo.text = @"";
    }
}

- (void)setProgress:(CGFloat)progress {
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


- (void)setProgressItemWithProgress:(CGFloat)progress{
//    self.backgroundColor = [UIColor yellowColor];
    _cornerR    = self.frame.size.width * 0.25;
    _borderW = 2;
    _boundsW = self.frame.size.width * 0.5;
    _halfInW = _boundsW - _cornerR;
    _distance = 2 * M_PI * _cornerR + 8 * _halfInW;//
    
    
    self.bottomLayer = [CAShapeLayer layer];
    self.bottomLayer.frame = CGRectMake(-1, -1, _boundsW * 2+2, 2 * _boundsW+2);
    self.bottomLayer.cornerRadius   = _cornerR + 0.5;
    self.bottomLayer.borderWidth    = _borderW - 0.5;
    self.bottomLayer.borderColor    = RGBCOLOR_HEX(0xd94b00).CGColor;
    [self.layer addSublayer:self.bottomLayer];
    
    
    
    self.maskLayer = [CAShapeLayer layer];
    self.maskLayer.strokeColor  = [UIColor whiteColor].CGColor;
    self.maskLayer.fillColor    = [UIColor clearColor].CGColor;
    self.maskLayer.lineWidth    = _borderW;
    
    [self.layer addSublayer:self.maskLayer];
    
    [self addMaskLayerWithRatio:progress];
}

- (void)addMaskLayerWithRatio:(CGFloat)ratio {
    UIBezierPath *maskPath = [UIBezierPath new];
    [maskPath moveToPoint:CGPointMake(_boundsW, 0)];
    
    CGFloat passD = ratio * _distance;
    CGFloat surePass;
    CGFloat radialR = _cornerR * M_PI_2;
    
    //    passD = radialR + _halfInW + 10;
    if (passD <= _halfInW)
    {
        [maskPath addLineToPoint:CGPointMake(_boundsW + passD, 0)];
    }
    else if (passD <= _halfInW + radialR)
    {
        [maskPath addLineToPoint:CGPointMake(_boundsW + _halfInW, 0)];
        CGFloat rP = (passD - _halfInW)/(M_PI_2 * _cornerR);
        [maskPath addArcWithCenter:CGPointMake(_boundsW+_halfInW,_cornerR) radius:_cornerR startAngle:-M_PI_2 endAngle:- M_PI_2 + M_PI_2 * rP clockwise:YES];
    }
    else if (passD <= 3 * _halfInW + M_PI_2 * _cornerR)
    {
        [maskPath addLineToPoint:CGPointMake(_boundsW + _halfInW, 0)];
        [maskPath addArcWithCenter:CGPointMake(_boundsW+_halfInW,_cornerR) radius:_cornerR startAngle:-M_PI_2 endAngle:0 clockwise:YES];
        surePass = _halfInW + M_PI_2 * _cornerR;
        
        [maskPath addLineToPoint:CGPointMake(2 * _boundsW, _cornerR + passD - surePass)];
    }
    else if (passD <= 3 * _halfInW + M_PI * _cornerR)
    {
        [maskPath addLineToPoint:CGPointMake(_boundsW + _halfInW, 0)];
        [maskPath addArcWithCenter:CGPointMake(_boundsW+_halfInW,_cornerR) radius:_cornerR startAngle:-M_PI_2 endAngle:0 clockwise:YES];
        [maskPath addLineToPoint:CGPointMake(2 * _boundsW, _cornerR + 2 * _halfInW)];
        
        CGFloat rP = (passD - 3 *_halfInW - M_PI_2 * _cornerR)/(M_PI_2 * _cornerR);
        [maskPath addArcWithCenter:CGPointMake(_boundsW+_halfInW,_boundsW+_halfInW) radius:_cornerR startAngle:0 endAngle:M_PI_2 * rP clockwise:YES];
    }
    else if (passD <= 5 * _halfInW + M_PI * _cornerR)
    {
        [maskPath addLineToPoint:CGPointMake(_boundsW + _halfInW, 0)];
        [maskPath addArcWithCenter:CGPointMake(_boundsW+_halfInW,_cornerR) radius:_cornerR startAngle:-M_PI_2 endAngle:0 clockwise:YES];
        [maskPath addLineToPoint:CGPointMake(2 * _boundsW, _cornerR + 2 * _halfInW)];
        [maskPath addArcWithCenter:CGPointMake(_boundsW+_halfInW,_boundsW+_halfInW) radius:_cornerR startAngle:0 endAngle:M_PI_2 clockwise:YES];
        
        surePass = 3 * _halfInW - _cornerR + M_PI * _cornerR;
        
        [maskPath addLineToPoint:CGPointMake(2 * _boundsW - (passD - surePass), 2 * _boundsW)];
        
    }
    else if (passD <= 5 * _halfInW + M_PI_2 * _cornerR * 3)
    {
        [maskPath addLineToPoint:CGPointMake(_boundsW + _halfInW, 0)];
        [maskPath addArcWithCenter:CGPointMake(_boundsW+_halfInW,_cornerR) radius:_cornerR startAngle:-M_PI_2 endAngle:0 clockwise:YES];
        [maskPath addLineToPoint:CGPointMake(2 * _boundsW, _cornerR + 2 * _halfInW)];
        [maskPath addArcWithCenter:CGPointMake(_boundsW+_halfInW,_boundsW+_halfInW) radius:_cornerR startAngle:0 endAngle:M_PI_2 clockwise:YES];
        
        [maskPath addLineToPoint:CGPointMake(_cornerR, 2 * _boundsW)];
        
        surePass = 5 * _halfInW + M_PI * _cornerR;
        CGFloat rP = (passD - surePass)/(M_PI_2 * _cornerR);
        
        [maskPath addArcWithCenter:CGPointMake(_cornerR,_boundsW+_halfInW) radius:_cornerR startAngle:M_PI_2 endAngle: M_PI_2 + M_PI_2 * rP clockwise:YES];
    }
    else if (passD <= 7 *_halfInW + _cornerR * M_PI_2 * 3)
    {
        [maskPath addLineToPoint:CGPointMake(_boundsW + _halfInW, 0)];
        [maskPath addArcWithCenter:CGPointMake(_boundsW+_halfInW,_cornerR) radius:_cornerR startAngle:-M_PI_2 endAngle:0 clockwise:YES];
        [maskPath addLineToPoint:CGPointMake(2 * _boundsW, _cornerR + 2 * _halfInW)];
        [maskPath addArcWithCenter:CGPointMake(_boundsW+_halfInW,_boundsW+_halfInW) radius:_cornerR startAngle:0 endAngle:M_PI_2 clockwise:YES];
        
        [maskPath addLineToPoint:CGPointMake(_cornerR, 2 * _boundsW)];
        
        [maskPath addArcWithCenter:CGPointMake(_cornerR,_boundsW+_halfInW) radius:_cornerR startAngle:M_PI_2 endAngle: M_PI_2 + M_PI_2 clockwise:YES];
        
        surePass = 5 *_halfInW + _cornerR * M_PI_2 * 3;
        [maskPath addLineToPoint:CGPointMake(0, 2 * _boundsW - _cornerR - (passD - surePass))];
    }
    else if (passD < 7 *_halfInW + _cornerR * M_PI * 2){
        [maskPath addLineToPoint:CGPointMake(_boundsW + _halfInW, 0)];
        [maskPath addArcWithCenter:CGPointMake(_boundsW+_halfInW,_cornerR) radius:_cornerR startAngle:-M_PI_2 endAngle:0 clockwise:YES];
        [maskPath addLineToPoint:CGPointMake(2 * _boundsW, _cornerR + 2 * _halfInW)];
        [maskPath addArcWithCenter:CGPointMake(_boundsW+_halfInW,_boundsW+_halfInW) radius:_cornerR startAngle:0 endAngle:M_PI_2 clockwise:YES];
        
        [maskPath addLineToPoint:CGPointMake(_cornerR, 2 * _boundsW)];
        
        [maskPath addArcWithCenter:CGPointMake(_cornerR,_boundsW+_halfInW) radius:_cornerR startAngle:M_PI_2 endAngle: M_PI_2 + M_PI_2 clockwise:YES];
        
        [maskPath addLineToPoint:CGPointMake(0, _cornerR)];
        
        surePass = 7 *_halfInW + _cornerR * M_PI_2 * 3;
        CGFloat rP = (passD - surePass)/(M_PI_2 * _cornerR);
        [maskPath addArcWithCenter:CGPointMake(_cornerR,_cornerR) radius:_cornerR startAngle:M_PI endAngle:M_PI + M_PI_2 * rP clockwise:YES];
        
    }
    else if (passD <= _distance) {
        [maskPath addLineToPoint:CGPointMake(_boundsW + _halfInW, 0)];
        [maskPath addArcWithCenter:CGPointMake(_boundsW+_halfInW,_cornerR) radius:_cornerR startAngle:-M_PI_2 endAngle:0 clockwise:YES];
        [maskPath addLineToPoint:CGPointMake(2 * _boundsW, _cornerR + 2 * _halfInW)];
        [maskPath addArcWithCenter:CGPointMake(_boundsW+_halfInW,_boundsW+_halfInW) radius:_cornerR startAngle:0 endAngle:M_PI_2 clockwise:YES];
        
        [maskPath addLineToPoint:CGPointMake(_cornerR, 2 * _boundsW)];
        
        [maskPath addArcWithCenter:CGPointMake(_cornerR,_boundsW+_halfInW) radius:_cornerR startAngle:M_PI_2 endAngle: M_PI_2 + M_PI_2 clockwise:YES];
        
        [maskPath addLineToPoint:CGPointMake(0, _cornerR)];
        
        [maskPath addArcWithCenter:CGPointMake(_cornerR,_cornerR) radius:_cornerR startAngle:M_PI endAngle:M_PI + M_PI_2 clockwise:YES];
        
        surePass = 7 * _halfInW + M_PI * _cornerR * 2;
        [maskPath addLineToPoint:CGPointMake(_cornerR + passD - surePass, 0)];
        
    }
    
    //    [maskPath closePath];
    [maskPath fill];
    [maskPath stroke];
    [self.maskLayer setPath:maskPath.CGPath];
}


- (void)dealloc{
    [_timer invalidate];
    _timer = nil;
}

@end
