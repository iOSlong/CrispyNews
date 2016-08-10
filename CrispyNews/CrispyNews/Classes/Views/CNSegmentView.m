//
//  CNSegmentView.m
//  CNMenuDemo
//
//  Created by xuewu.long on 16/8/1.
//  Copyright © 2016年 letv. All rights reserved.
//

#import "CNSegmentView.h"


#define k_lineH         (3)
#define k_spanOfBtn     (1)
#define k_edgeOfBtn     (10)
#define k_minBtnW       (40)
#define k_maxBtnW       (150)

@implementation CNSegmentBtn

+ (instancetype)buttonWithType:(UIButtonType)buttonType {
    CNSegmentBtn *btn = [super buttonWithType:buttonType];
    btn.backgroundColor = RGBCOLOR_HEX(0xefefef);
    
    [btn setTitleColor:RGBCOLOR_HEX(0x7f7f7f) forState:UIControlStateNormal];
    [btn setTitleColor:RGBCOLOR_HEX(0xf95900) forState:UIControlStateSelected];
    [btn setTitleColor:RGBCOLOR_HEX(0xffffff) forState:UIControlStateHighlighted];
    
    return btn;
}


- (void)setTitle:(NSString *)title forState:(UIControlState)state
{
    [super setTitle:title forState:state];
    _valueRect = [self sizeOfBtn:self];
}

- (NSValue *)sizeOfBtn:(UIButton *)btn
{
    CGSize sizeBtn = [btn.titleLabel sizeThatFits:CGSizeMake(150, btn.titleLabel.frame.size.height)];
    NSValue *rectValur   = [NSValue valueWithCGSize:CGSizeMake(sizeBtn.width + 2 * k_edgeOfBtn, sizeBtn.height)];
    NSValue *minRectValue= [NSValue valueWithCGSize:CGSizeMake(k_minBtnW, sizeBtn.height)];
    NSValue *lastSizeValue =  sizeBtn.width + 2 * k_edgeOfBtn  > k_minBtnW ? rectValur : minRectValue;
    return lastSizeValue;
}

- (CGFloat)realW {
    CGSize size = [self.valueRect CGSizeValue];
    return size.width;
}

- (void)reloadFrame{
    self.valueRect = [self sizeOfBtn:self];
}

@end



@interface CNSegmentView ()

@property (nonatomic, strong) UIView            *layerLine;
@property (nonatomic, strong) UIScrollView      *scrollView;
@property (nonatomic, strong) NSMutableArray    *muArrBtn;
@property (nonatomic, strong) NSMutableArray    *muArrRectValue;
@property (nonatomic, strong) CNSegmentBtn      *currentBtn;
@property (nonatomic, strong) UIButton          *btnAdd;

@end

@implementation CNSegmentView {
    CNSegmentBlock _CNSBlock;
}

+ (CGFloat)segmentHeight {
    return 44;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        
        self.backgroundColor =RGBCOLOR_HEX(0xefefef);
        self.layer.shadowOffset = CGSizeMake(0, 0);
        self.layer.shadowRadius = 1;
        self.layer.shadowColor  = [UIColor lightGrayColor].CGColor;
        self.layer.shadowOpacity= 0.6;
        self.layer.shadowPath = [UIBezierPath bezierPathWithRect:CGRectMake(0, 44, SCREENW , 2)].CGPath;
        
        
        [self configureItmes];
        [self addSubview:self.scrollView];
        self.scrollView.width   = self.width - self.height;
        [self.scrollView addSubview:self.layerLine];
        
        
        [self addSubview:self.btnAdd];
        self.btnAdd.x           = self.scrollView.width+2;
        self.btnAdd.y           = 0;
        
    }
    return self;
}

- (UIButton *)btnAdd {
    if (!_btnAdd) {
        _btnAdd = [UIButton buttonWithType:UIButtonTypeCustom];
        [_btnAdd setSize:CGSizeMake(self.height, self.height)];
        [_btnAdd addTarget:self action:@selector(btnAddClick:) forControlEvents:UIControlEventTouchUpInside];
        [_btnAdd setTitle:@"+" forState:UIControlStateNormal];
        [_btnAdd.titleLabel setFont:[UIFont systemFontOfSize:25]];
        [_btnAdd setBackgroundColor:RGBCOLOR_HEX(0xf5f5f5)];
        [_btnAdd setTitleColor:RGBCOLOR_HEX(0x7f7f7f) forState:UIControlStateNormal];
        
        _btnAdd.layer.shadowOffset = CGSizeMake(0, 0);
        _btnAdd.layer.shadowRadius = 2.5;
        _btnAdd.layer.shadowColor  = [UIColor lightGrayColor].CGColor;
        _btnAdd.layer.shadowOpacity= 0.7;
        _btnAdd.layer.shadowPath = [UIBezierPath bezierPathWithRect:CGRectMake(-2.5,0,2.5, self.height)].CGPath;
        
    }
    return _btnAdd;
}

- (UIView *)layerLine{
    if (!_layerLine) {
        _layerLine = [[UIView alloc] initWithFrame:CGRectMake(0, self.bounds.size.height - k_lineH, 0, k_lineH)];
        _layerLine.backgroundColor = [UIColor redColor];
    }
    return _layerLine;
}


- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        _scrollView.showsHorizontalScrollIndicator  = NO;
    }
    return _scrollView;
}

- (void)setArrItem:(NSArray *)arrItem {
    if (arrItem) {
        _arrItem = arrItem;
        [self resetAllSegments];
    }
}

- (void)configureItmes {
    self.muArrBtn = [NSMutableArray array];
    if (self.arrItem.count) {
        [self resetAllSegments];
    }
}
- (void)resetAllSegments {
    
    CGFloat btn_w = (self.scrollView.width - self.arrItem.count + k_lineH) / self.arrItem.count;
    for (UIView *view in self.subviews) {
        if ([view isKindOfClass:[CNSegmentBtn class]]) {
            [view removeFromSuperview];
        }
    }
    [self.muArrBtn removeAllObjects];
    
    
    
    
    self.layerLine.frame = CGRectMake(0, self.scrollView.height - k_lineH, btn_w, k_lineH);
    
    
    for (int i = 0; i< self.arrItem.count; i++) {
        CNSegmentBtn *btnItem = [CNSegmentBtn buttonWithType:UIButtonTypeCustom];
        [btnItem setTitle:self.arrItem[i] forState:UIControlStateNormal];
        [btnItem addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [btnItem setTag:i];
        
        [self.scrollView addSubview:btnItem];
        [self.muArrBtn addObject:btnItem];
        
    }
    
    [self displaySuitItems];
    
    self.selectedIndex = 0;
}

- (void)displaySuitItems {
    CGFloat last_x = [self vanguardDisplaySegmentItems];
    
    if (last_x + (k_spanOfBtn * self.muArrBtn.count - 1) < self.scrollView.width) {
        CGFloat realSegBarW = self.scrollView.width - k_spanOfBtn * (self.muArrBtn.count - 1);
        for (CNSegmentBtn *cnsegBtn in self.muArrBtn) {
            CGFloat realBtnW = realSegBarW * cnsegBtn.realW / last_x;
            CGSize  realSize = CGSizeMake(realBtnW, cnsegBtn.height);
            cnsegBtn.valueRect = [NSValue valueWithCGSize:realSize];
        }
        
        last_x = [self vanguardDisplaySegmentItems];
    }
    [self.scrollView setContentSize:CGSizeMake(last_x + k_spanOfBtn * (self.muArrBtn.count - 1), self.height)];
}

- (CGFloat )vanguardDisplaySegmentItems {
    CGFloat last_x = 0;
    for (int i =0 ; i < self.muArrBtn.count; i ++ )
    {
        CNSegmentBtn *cnsegBtn =  self.muArrBtn[i];
        CGSize sizeBtn = [cnsegBtn.valueRect CGSizeValue];
        cnsegBtn.frame = CGRectMake(last_x + i * k_spanOfBtn, 0, sizeBtn.width, self.height - k_lineH);
        last_x += sizeBtn.width;
    }
    return last_x;
}



- (void)addItems:(NSArray *)items {
    
    for (CNSegmentBtn *cegBtn in self.muArrBtn) {
        [cegBtn reloadFrame];
    }
    
    if (items && items.count) {
        for (int i = 0; i< items.count; i++) {
            CNSegmentBtn *btnItem = [CNSegmentBtn buttonWithType:UIButtonTypeCustom];
            [btnItem setTitle:items[i] forState:UIControlStateNormal];
            [btnItem addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
            
            [btnItem setTag:self.muArrBtn.count];
            
            [self.scrollView addSubview:btnItem];
            [self.muArrBtn addObject:btnItem];
        }
        
        [self displaySuitItems];
    }
    self.selectedIndex = self.selectedIndex;
}


- (void)insertItem:(NSString *)item atIndex:(NSInteger)index {
    CNSegmentBtn *btnItem = [CNSegmentBtn buttonWithType:UIButtonTypeCustom];
    [btnItem setTitle:item forState:UIControlStateNormal];
    [btnItem addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [btnItem setTag:self.muArrBtn.count];
    
    [self.scrollView addSubview:btnItem];
    [self.muArrBtn insertObject:btnItem atIndex:index];
    
    for (NSInteger i = index + 1; i< self.muArrBtn.count; i ++ ) {
        CNSegmentBtn *cnsegBtn =  self.muArrBtn[i];
        cnsegBtn.tag = i;
    }
    [self displaySuitItems];
}


- (void)setSelectedIndex:(NSInteger)selectedIndex {
    if (selectedIndex < self.muArrBtn.count) {
        _selectedIndex = selectedIndex;
        
        [self animationShowBtn:self.muArrBtn[selectedIndex]];
        
        if (self.currentBtn) {
            self.currentBtn.selected = NO;
        }
        self.currentBtn = self.muArrBtn[selectedIndex];
        self.currentBtn.selected = YES;
    }
}

- (void)moveToBtn:(CNSegmentBtn *)btn {
    CGFloat span_left   = btn.realW * 0.15;
    [UIView animateWithDuration:0.3f animations:^{
        self.layerLine.frame  = CGRectMake(btn.x + span_left,
                                           btn.height,
                                           btn.width - 2 * span_left,
                                           k_lineH);
    }];
}

- (void)btnAddClick:(UIButton *)btn {
    NSLog(@"add Click!");
    if (_CNSBlock) {
        _CNSBlock(self.selectedIndex, CNSegmentEventAddClick);
    }
}

- (void)btnClick:(CNSegmentBtn *)btn {
    
    self.selectedIndex = btn.tag;
    if (_CNSBlock) {
        _CNSBlock(btn.tag, CNSegmentEventItemClick);
    }
    NSLog(@"%@ -- %ld ",btn.titleLabel.text, (long)btn.tag);
}

- (void)animationShowBtn:(CNSegmentBtn *)btn {
    [self moveToBtn:btn];
    
    CGFloat btnCenterX      = btn.center.x;
    CGFloat contentW        = self.scrollView.contentSize.width;
    CGFloat halfSizeW       = self.scrollView.width * 0.3;
    CGFloat offsetX          = self.scrollView.width * btnCenterX / self.scrollView.contentSize.width;
    
    
    [UIView animateWithDuration:0.5 animations:^{
        if (btnCenterX <= halfSizeW) {
            self.scrollView.contentOffset = CGPointMake(0, 0);
        }else if (contentW - btnCenterX <= halfSizeW ){
            self.scrollView.contentOffset = CGPointMake(contentW - self.scrollView.width, 0);
        }else{
            self.scrollView.contentOffset = CGPointMake(btnCenterX - offsetX, 0);
        }
    }];
}

- (void)cn_segBlock:(CNSegmentBlock)thisBlock {
    _CNSBlock = thisBlock;
}


@end
