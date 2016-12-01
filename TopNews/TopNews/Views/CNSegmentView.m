//
//  CNSegmentView.m
//  CNMenuDemo
//
//  Created by xuewu.long on 16/8/1.
//  Copyright © 2016年 letv. All rights reserved.
//

#import "CNSegmentView.h"


#define k_lineH         (2)
#define k_spanOfBtn     (1)
#define k_edgeOfBtn     (10)
#define k_minBtnW       (40)
#define k_maxBtnW       (150)

@implementation CNSegmentBtn

+ (instancetype)buttonWithType:(UIButtonType)buttonType {
    CNSegmentBtn *btn = [super buttonWithType:buttonType];
    btn.backgroundColor = RGBCOLOR_HEX(0xefefef);
    [btn.titleLabel setFont:[UIFont systemFontOfSize:[CNUtils fontSizePreference:15]]];
    [btn setTitleColor:RGBCOLOR_HEX(0x747474) forState:UIControlStateNormal];
    [btn setTitleColor:RGBCOLOR_HEX(0xFC5700) forState:UIControlStateSelected];
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
    return (iPhone5 || iPhone4s)? 32 : 32 * kRATIO;
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
        self.layer.shadowPath = [UIBezierPath bezierPathWithRect:CGRectMake(0,[CNSegmentView segmentHeight]- 1, SCREENW , 3)].CGPath;
        
//        UIImageView *imgvShadow = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.height-0.5, self.width, 0.5)];
//        imgvShadow.backgroundColor = RGBACOLOR_HEX(0x000000, 0.5);
//        [self addSubview:imgvShadow];
        
        
        [self configureItmes];
        
        [self addSubview:self.scrollView];
        [self addSubview:self.btnAdd];

        self.scrollView.width   = self.width - self.btnAdd.width;
        [self.scrollView addSubview:self.layerLine];
        
        
        self.btnAdd.x           = self.scrollView.width+2;
        self.btnAdd.y           = 0;
        
    }
    return self;
}

- (UIButton *)btnAdd {
    if (!_btnAdd) {
        _btnAdd = [UIButton buttonWithType:UIButtonTypeCustom];
        [_btnAdd setSize:CGSizeMake(SCREENW > 320? 37 * kRATIO:37, self.height)];
        
        [_btnAdd addTarget:self action:@selector(btnAddClick:) forControlEvents:UIControlEventTouchUpInside];
        [_btnAdd setImage:[UIImage imageNamed:@"ic_addhannel"] forState:UIControlStateNormal];
        [_btnAdd setImageEdgeInsets:UIEdgeInsetsMake(9,12.5,9,12.5)];
        [_btnAdd setBackgroundColor:RGBCOLOR_HEX(0xf5f5f5)];
        
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
        _layerLine = [[UIView alloc] initWithFrame:CGRectMake(0, self.bounds.size.height - k_lineH+1, 0, k_lineH)];
        _layerLine.backgroundColor = CNCOLOR_THEME_EDIT;
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
    for (UIView *view in self.scrollView.subviews) {
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
            [self.currentBtn.titleLabel setFont:[UIFont systemFontOfSize:[CNUtils fontSizePreference:15]]];
        }
        self.currentBtn = self.muArrBtn[selectedIndex];
        self.currentBtn.selected = YES;
        [self.currentBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:[CNUtils fontSizePreference:15]]];
    }
}

- (void)moveToBtn:(CNSegmentBtn *)btn {
//    CGSize titleSize = [btn.titleLabel sizeThatFits:CGSizeMake(btn.width, btn.titleLabel.size.height)];
    [UIView animateWithDuration:0.3f animations:^{
        self.layerLine.frame  = CGRectMake(btn.x ,
                                           btn.height,
                                           btn.width,
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
    CGFloat halfSizeW       = self.scrollView.width * 0.5;
    CGFloat offsetX         = self.scrollView.width * btnCenterX / self.scrollView.contentSize.width;
    offsetX *= (self.scrollView.width / contentW);
    
    
    [UIView animateWithDuration:0.5 animations:^{
        if (btnCenterX <= halfSizeW) {
            self.scrollView.contentOffset = CGPointMake(0, 0);
        }else if (contentW - btnCenterX <= halfSizeW ){
            self.scrollView.contentOffset = CGPointMake(contentW - self.scrollView.width, 0);
        }else if (btnCenterX - self.scrollView.width/2 - offsetX < 0){
            self.scrollView.contentOffset = CGPointMake(0, 0);
        }else{
            self.scrollView.contentOffset = CGPointMake(btnCenterX - self.scrollView.width/2- offsetX, 0);
        }
    }];
}

- (void)cn_segBlock:(CNSegmentBlock)thisBlock {
    _CNSBlock = thisBlock;
}

- (void)setMapOffsetX:(CGFloat)mapOffsetX {
    _mapOffsetX = mapOffsetX;
    CGFloat offset_x    = _mapOffsetX - _selectedIndex * SCREENW;
    if (_selectedIndex == 0 && mapOffsetX <= 0) {
        return;
    }else if (_selectedIndex == self.muArrBtn.count - 1 && offset_x >=0){
        return;
    }

    
    NSInteger desIndex  = 0;
    CGFloat map_width   = 0;
    if (offset_x > 0) {
        desIndex    = _selectedIndex + 1;
    }else{
        desIndex = _selectedIndex - 1;
    }
    UIButton *currentBtn = self.muArrBtn[_selectedIndex];
    UIButton *desBtn     = self.muArrBtn[desIndex];
    map_width = currentBtn.width * 0.5 + desBtn.width * 0.5;
    
    CGFloat ratioScale  = map_width / SCREENW;
    CGFloat mapOffset_x = ratioScale * offset_x;
    
    CGFloat currentOffset_x = self.currentBtn.x;

    self.layerLine.frame  = CGRectMake(mapOffset_x + currentOffset_x,
                                       desBtn.height,
                                       currentBtn.width,
                                       k_lineH);


}


@end
