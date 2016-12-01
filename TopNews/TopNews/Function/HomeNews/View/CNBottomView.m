//
//  CNBottomView.m
//  CrispyNews
//
//  Created by xuewu.long on 16/8/23.
//  Copyright © 2016年 letv. All rights reserved.
//

#import "CNBottomView.h"
#import "AppDelegate.h"

@interface CNBottomView ()<UITextFieldDelegate>

@property (nonatomic, strong) UITextField   *field;
@property (nonatomic, strong) UIButton      *btnCommi;
@property (nonatomic, strong) UILabel       *labelCom;
@property (nonatomic, strong) UIButton      *btnHeart;
@property (nonatomic, strong) UIButton      *btnShare;


@property (nonatomic, strong) UIView *viewSharePlat;
@property (nonatomic, strong) UIView *viewSignInPlat;
@property (nonatomic, strong) UIView *viewWhatsapp;
@property (nonatomic, strong) UIView *viewFacebook;
@property (nonatomic, strong) UIView *viewTwitter;

@property (nonatomic, strong) UIView *viewAccessory;
@property (nonatomic, strong) UIView *viewEmail;
@property (nonatomic, strong) UIView *viewMessage;
@property (nonatomic, strong) UIView *viewCopyLink;

@property (nonatomic, strong) UIView *viewMore;


@property (nonatomic, strong) UIButton *btnAll;
@property (nonatomic, strong) UIButton *btnDel;

@property (nonatomic, strong) UIButton  *btnSignIn;
@property (nonatomic, strong) UILabel   *labelSignIn;


@end

@implementation CNBottomView

CGFloat heighOfInputBar() {
    return SCREENW > 320 ? 45 * kRATIO : 45;
}
CGFloat heighOfShareBar() {
    return heighOfShareItemBar() + heighOfShareCancel();
}
CGFloat heighOfShareItemBar() {
    return 95 * kRATIO;
}
CGFloat heighOfShareCancel(){
    return 46 * kRATIO;
}
CGFloat heighOfSigInBar() {
    return 145 * kRATIO;
}

- (instancetype)initWithFrame:(CGRect)frame style:(CNBottomViewStyle)style {
    self = [super initWithFrame:frame];
    _style = style;
    if (self) {
        if (style == CNBottomViewStyleNewsDetail) {
            //1. 背景图片
            self.imgvBackground = [[UIImageView alloc] initWithFrame:self.bounds];
            self.imgvBackground.backgroundColor = RGBACOLOR_HEX(0xF0F0F0, 1);
            self.imgvBackground.layer.borderWidth = 0.5;
            self.imgvBackground.layer.borderColor = RGBACOLOR_HEX(0x000000, 0.25).CGColor;
            self.layer.shadowColor  = RGBACOLOR_HEX(0x000000, 0.5).CGColor;
            self.layer.shadowOffset = CGSizeMake(0, 0);
            self.layer.shadowRadius = 1.0;
            self.layer.shadowOpacity= 1;
            self.layer.shadowPath = [UIBezierPath bezierPathWithRect:CGRectMake(0,-1, SCREENW , 1)].CGPath;
            
            
            [self addSubview:self.imgvBackground];
            
            //2. 添加 输入框
            CGFloat field_w = self.width - 2*(k_SpanLeft+k_SpanIn) - 50;//450
            CGFloat field_h = self.height - 2*k_SpanIn;//56
            _field = [[UITextField alloc] initWithFrame:CGRectMake(k_SpanLeft,0, field_w, field_h)];
            _field.delegate = self;
            _field.borderStyle = UITextBorderStyleNone;
            _field.layer.cornerRadius   = 1;
            _field.layer.borderColor    = CNCOLOR_FIELD_BORDER.CGColor;
            _field.layer.borderWidth    = 1;
            _field.layer.backgroundColor= CNCOLOR_FIELD_FILL.CGColor;
            _field.placeholder = @"";
            _field.centerY = self.height * 0.5;
            [self addSubview:_field];
            
            
            // 3. 分享按钮,评论按钮，收藏按钮
            CGFloat commi_w = 34 * kRATIO;
            CGFloat commi_h = 35 * kRATIO;
            
            _btnShare = [UIButton buttonFrame:CGRectMake(0, 0, 30, 30) imgSelected:@"ic_share" imgNormal:@"ic_share" target:self action:@selector(btnClick:) mode:UIViewContentModeScaleAspectFit ContentEdgeInsets:UIEdgeInsetsMake(6, 6, 6, 6)];
            
            
            _btnHeart = [UIButton buttonFrame:CGRectMake(0, 0, 30, 30) imgSelected:@"ic_marked" imgNormal:@"ic_mark_gray" target:self action:@selector(btnClick:) mode:UIViewContentModeScaleAspectFill ContentEdgeInsets:UIEdgeInsetsMake(1, 1, 1, 1)];
            
            _btnCommi = [UIButton buttonFrame:CGRectMake(0, 0, 30, 30) imgSelected:@"ic_coment" imgNormal:@"ic_coment" target:self action:@selector(btnClick:) mode:UIViewContentModeScaleAspectFit ContentEdgeInsets:UIEdgeInsetsMake(6, 6, 6, 6)];
            
            
            _labelCom = [UILabel labelFrame:CGRectMake(0, 0, commi_w, commi_h) fontSize:13 * kRATIO textColor:CNCOLOR_TEXT_SLIGHT];
            _labelCom.numberOfLines = 1;
            
            _btnShare.right = self.width - k_SpanLeft/2;
            _btnHeart.right = _btnShare.left - k_SpanIn;
            _btnShare.centerY = _btnHeart.centerY = _btnCommi.centerY = self.height * 0.5;
            
            [self addSubview:_btnCommi];
            [self addSubview:_labelCom];
            [self addSubview:_btnHeart];
            [self addSubview:_btnShare];
        }
        else if (style == CNBottomViewStyleBookMark){
            self.backgroundColor = [UIColor whiteColor];
            
            _btnAll = [UIButton buttonWithType:UIButtonTypeCustom];
            [_btnAll setFrame:CGRectMake(0, 0, self.width * 0.4, self.height * 0.6)];
            [_btnAll setTitle:@"All" forState:UIControlStateNormal];
            [_btnAll setTitleColor:CNCOLOR_TEXT_TITLE forState:UIControlStateNormal];
            [_btnAll setTitleColor:CNCOLOR_THEME_EDIT forState:UIControlStateSelected];
            [_btnAll.titleLabel setFont:[CNUtils fontPreference:FONT_Helvetica size:19]];
            _btnAll.center = CGPointMake(self.width * 0.25, self.height * 0.5);
            [self addSubview:_btnAll];
            
            
            _btnDel = [UIButton buttonWithType:UIButtonTypeCustom];
            [_btnDel setFrame:CGRectMake(0, 0, self.width * 0.4, self.height * 0.6)];
            [_btnDel setTitle:@"Delete" forState:UIControlStateNormal];
            [_btnDel setTitleColor:CNCOLOR_THEME_EDITNESS forState:UIControlStateNormal];
            [_btnDel setTitleColor:CNCOLOR_THEME_EDIT forState:UIControlStateSelected];
            [_btnDel.titleLabel setFont:[CNUtils fontPreference:FONT_Helvetica size:19]];
            _btnDel.center = CGPointMake(self.width * 0.75, self.height * 0.5);
            [self addSubview:_btnDel];
            
            [_btnAll addTarget:self action:@selector(bookMarkBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [_btnDel addTarget:self action:@selector(bookMarkBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            
            UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, 1)];
            line.backgroundColor = CNCOLOR_LINE_SEPERATE;
            [self addSubview:line];
        }
        
    }
    return self;
}


#pragma mark - CNBottomViewStyleBookMark
- (void)bookMarkBtnClick:(UIButton *)btn {
    CNBottomEvent event = CNBottomEventNone;
    if (btn == _btnDel) {
        event = CNBottomEventDelClick;
    }else if (btn == _btnAll){
        _btnAll.selected =!_btnAll.selected;
        if (_btnAll.selected) {
            event = CNBottomEventMarkAll;
        }else{
            event = CNBottomEventMarkNone;
        }
    }
    if ([self.delegate respondsToSelector:@selector(bottomBtnClickEvent:)]) {
        [self.delegate bottomBtnClickEvent:event];
    }
}

- (void)setMarkCount:(NSString *)markCount {
    _markCount = markCount;
    if ([markCount integerValue] == 0) {
        _btnDel.selected = NO;
        _btnDel.userInteractionEnabled = YES;
        [_btnDel setTitle:@"Delete" forState:UIControlStateNormal];
        _btnAll.selected = NO;
    }else{
        _btnDel.selected = YES;
        _btnDel.userInteractionEnabled = YES;
        [_btnDel setTitle:[NSString stringWithFormat:@"Delete(%@)",markCount] forState:UIControlStateNormal];
    }
}

- (void)setMarkAll:(BOOL)markAll {
    _markAll = markAll;
    if (markAll) {
        _btnAll.selected = YES;
    }else{
        _btnAll.selected = NO;
    }
}

#pragma mark - CNBottomViewStyleNewsDetail
- (void)btnClick:(UIButton *)btn {
    CNBottomEvent event = CNBottomEventNone;
    if (btn == _btnHeart) {
        event = CNBottomEventHeart;
    }else if (btn == _btnCommi) {
        event = CNBottomEventComment;
    }else if (btn == _btnShare) {
        event = CNBottomEventShare;
    }else if (btn == _btnSignIn) {
        event = CNBottomEventSinginClick;
    }
    else{
        event = btn.tag;// facebook twitter whatsapp more
    }
    
    if (event == CNBottomEventShareMore) {
        CGFloat accessoryAlpha  = 1;
        CGFloat accessoryBottom    = SCREENH;
        if (self.viewAccessory.bottom > self.viewSharePlat.centerY) {
            accessoryBottom    = self.viewSharePlat.top;
            [self.viewAccessory setHidden:NO];
            accessoryAlpha  = 1;
        }else{
            accessoryBottom = SCREENH + self.viewAccessory.height;
            accessoryAlpha  = 0;
        }
        self.viewAccessory.bottom = accessoryBottom;
        [UIView animateWithDuration:0.3 animations:^{
            self.viewAccessory.alpha = accessoryAlpha;
        } completion:^(BOOL finished) {
            [self.viewAccessory setHidden:!accessoryAlpha];
        }];
        return;
    }
    
    if ([self.delegate respondsToSelector:@selector(bottomBtnClickEvent:)]) {
        [self.delegate bottomBtnClickEvent:event];
    }
    if (self.style == CNBottomViewStyleForSign) {
        [self setHidden:YES];
    }

}

- (void)setInputContent:(NSString *)inputContent {
    if (inputContent && inputContent.length) {
        self.field.text = inputContent;
    }else{
        self.field.text = nil;
    }
}

- (void)setCommentCount:(NSString *)commentCount {
    _commentCount = commentCount;
    _labelCom.text = [commentCount integerValue]? commentCount : @"";
    [self reloadFrame];
}

- (void)setIsLiked:(BOOL)isLiked {
    _isLiked = isLiked;
    if (_isLiked) {
        _btnHeart.selected = YES;
    }else{
        _btnHeart.selected = NO;
    }
}

- (void)reloadFrame {
    [_labelCom sizeToFit];
    _labelCom.right     = _btnHeart.left - k_SpanIn;
    _btnCommi.right     = _labelCom.left - k_SpanIn/2;
    _labelCom.centerY   = self.height * 0.5;
    _field.width        = _btnCommi.left - 2 * k_SpanLeft;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if ([self.delegate respondsToSelector:@selector(bottomFieldShouldBeginEditing)]) {
        return [self.delegate bottomFieldShouldBeginEditing];
    }
    return NO;
}







#pragma mark - CNBottomViewStyleShare

- (instancetype)initWithStyle:(CNBottomViewStyle)style {
    self = [self initWithFrame:CGRectMake(0, 0, SCREENW, SCREENH)];
    _style = style;
    if (self) {
        self.imgvBackground = [self backImageViewWithGesture];
        [self addSubview:self.imgvBackground];
        if (_style == CNBottomViewStyleShare) {
            [self addSubview:self.viewAccessory];
            [self addSubview:self.viewSharePlat];
        }else if (_style == CNBottomViewStyleForSign) {
            [self addSubview:self.viewSignInPlat];
        }
    }
    return self;
}

- (UIImageView *)backImageViewWithGesture {
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.bounds];
    imageView.backgroundColor = [UIColor blackColor];
    
    imageView.alpha = 0.4;
    
    imageView.userInteractionEnabled = YES;
    [imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapEvent)]];
    
    UISwipeGestureRecognizer *swipeGR = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeEvent:)];
    swipeGR.direction = UISwipeGestureRecognizerDirectionDown|UISwipeGestureRecognizerDirectionUp;
    [imageView addGestureRecognizer:swipeGR];
    return imageView;
}
- (void)swipeEvent:(UISwipeGestureRecognizer *)swipeGR{
    NSLog(@"%lu",swipeGR.direction);
    [self setHidden:YES];
}
- (void)tapEvent {
    [self setHidden:YES];
}

- (UIView *)viewSignInPlat {
    if (!_viewSignInPlat) {
        _viewSignInPlat = [[UIView alloc] initWithFrame:CGRectMake(0, SCREENH, SCREENW, heighOfSigInBar())];
        _viewSignInPlat.backgroundColor = RGBCOLOR_HEX(0xEEEEEE);
        
        UIButton *facebookBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [facebookBtn setBackgroundColor:RGBCOLOR_HEX(0x557CC5)];
        facebookBtn.layer.cornerRadius = 1.0f;
        [facebookBtn setTitle:@"Facebook" forState:UIControlStateNormal];
        [facebookBtn setFrame:CGRectMake(0, 0, 225, 28)];
        [facebookBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [facebookBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [facebookBtn setCenter:CGPointMake(_viewSignInPlat.width * 0.5, 40 * kRATIO + 14)];
        [_viewSignInPlat addSubview:facebookBtn];
        self.btnSignIn = facebookBtn;
        
        UILabel *signInlabel = [UILabel labelFrame:CGRectMake(0, 0, 200, 20) fontSize:14.0 textColor:RGBCOLOR_HEX(0xA9A9A9)];
        [signInlabel setText:@"Sign in to comment"];
        [signInlabel setTextAlignment:NSTextAlignmentCenter];
        [signInlabel setCenter:CGPointMake(facebookBtn.centerX, facebookBtn.bottom + 20 + 10)];
        [_viewSignInPlat addSubview:signInlabel];
        self.labelSignIn = signInlabel;
    }
    return _viewSignInPlat;
}

- (UIView *)viewAccessory {
    if (!_viewAccessory) {
        _viewAccessory = [[UIView alloc] initWithFrame:CGRectMake(0, SCREENH, SCREENW, heighOfShareItemBar())];
        _viewAccessory.backgroundColor = CNCOLOR_PLAT_SHARE;
        
        NSMutableArray *accessoryViewArr = [NSMutableArray arrayWithObjects:self.viewEmail, self.viewMessage, self.viewCopyLink, nil];
        CGFloat span_w = (SCREENW - 80.0 * 4)/ 5;
        for (int i=0; i<accessoryViewArr.count; i++) {
            UIView *viewShare = accessoryViewArr[i];
            viewShare.top  = k_SpanIn * 1.5;
            viewShare.centerX = span_w + viewShare.width*0.5 + (viewShare.width + span_w)*(i%4);
            [_viewAccessory addSubview:viewShare];
            
            // TODO 切换图片之后删除掉
            for (UIView *view in viewShare.subviews) {
                if ([view isKindOfClass:[UIButton class]]) {
//                    view.backgroundColor = RGBCOLOR_HEX(0x514e5e);
                    break;
                }
            }
        }
    }
    return _viewAccessory;
}

- (UIView *)viewSharePlat {
    if (!_viewSharePlat) {
        _viewSharePlat = [[UIView alloc] initWithFrame:CGRectMake(0, SCREENH, SCREENW, heighOfShareBar())];
        _viewSharePlat.backgroundColor = CNCOLOR_PLAT_SHARE;
        
        
        NSMutableArray *shareViewArr = [NSMutableArray arrayWithObjects:self.viewWhatsapp,self.viewFacebook,self.viewTwitter,self.viewMore, nil];
        CGFloat span_w = (SCREENW - 80.0*(shareViewArr.count>4?4:shareViewArr.count) )/((shareViewArr.count > 4 ? 4:shareViewArr.count)+1);
        for (int i=0; i<shareViewArr.count; i++) {
            UIView *viewShare = shareViewArr[i];
            viewShare.top  = k_SpanIn * 1.5;
            viewShare.centerX = span_w + viewShare.width*0.5 + (viewShare.width + span_w)*(i%4);
            [_viewSharePlat addSubview:viewShare];
        }
        
        UIButton *btnCancel = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [btnCancel setFrame:CGRectMake(0,heighOfShareItemBar(),SCREENW, heighOfShareCancel())];
        [btnCancel setTitle:@"Cancel" forState:UIControlStateNormal];
        btnCancel.tag = CNBottomEventShareCancel;
        [btnCancel addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [btnCancel setTitleColor:CNCOLOR_TEXT_SHARE_CANCEL forState:UIControlStateNormal];
        btnCancel.backgroundColor = [UIColor whiteColor];
        [btnCancel.titleLabel setFont:[CNUtils fontPreference:nil size:18]];
        [_viewSharePlat addSubview:btnCancel];
    }
    return _viewSharePlat;
}

- (UIView *)viewWhatsapp {
    if (!_viewWhatsapp) {
        _viewWhatsapp = [self createShareItemWithImage:@"wahtsapp" title:@"Whatapp" tag:CNBottomEventShareWhatsapp];
    }
    return _viewWhatsapp;
}
- (UIView *)viewFacebook {
    if (!_viewFacebook) {
        _viewFacebook = [self createShareItemWithImage:@"Facebook" title:@"Facebook" tag:CNBottomEventShareFacebook];
    }
    return _viewFacebook;
}
- (UIView *)viewTwitter {
    if (!_viewTwitter) {
        _viewTwitter = [self createShareItemWithImage:@"twitter" title:@"Twitter" tag:CNBottomEventShareTwitter];
    }
    return _viewTwitter;
}
- (UIView *)viewEmail {
    if (!_viewEmail) {
        _viewEmail = [self createShareItemWithImage:@"Email" title:@"Email" tag:CNBottomEventShareEmail];
    }
    return _viewEmail;
}
- (UIView *)viewMessage {
    if (!_viewMessage) {
        _viewMessage = [self createShareItemWithImage:@"Message" title:@"Message" tag:CNBottomEventShareMessage];
    }
    return _viewMessage;
}
- (UIView *)viewCopyLink {
    if (!_viewCopyLink) {
        _viewCopyLink = [self createShareItemWithImage:@"CopyLink" title:@"Copy Link" tag:CNBottomEventShareCopyLink];
    }
    return _viewCopyLink;
}

- (UIView *)viewMore {
    if (!_viewMore) {
        _viewMore = [self createShareItemWithImage:@"sharemore" title:@"More" tag:CNBottomEventShareMore];
    }
    return _viewMore;
}


- (UIView *)createShareItemWithImage:(NSString *)imgName title:(NSString *)title tag:(NSInteger)tag{
    
    UIView *platView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 80, 80)];
    
    CGFloat btn_w = 50 * kRATIO;
    CGFloat span_in = 5;
    CGFloat label_h = 20;
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setFrame:CGRectMake(0,0, btn_w, btn_w)];
    btn.centerX = platView.width * 0.5;
//    btn.backgroundColor = RGBCOLOR_HEX(0x514e5e);
    btn.layer.cornerRadius = 7.0;
    btn.tag = tag;
    [btn setImage:[UIImage imageNamed:imgName] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [platView addSubview:btn];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0,btn.origin.y+btn.size.height+span_in,platView.width,label_h)];
    label.text = title;
    label.textColor = CNCOLOR_TEXT_SHARE_ITEM;
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [CNUtils fontPreference:nil size:12];
    [platView addSubview:label];
    
    return platView;
}

-(void)setHidden:(BOOL)hidden{
    weakSelf();
    self.alpha = 1;
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    UIView *drawerView = nil;
    if (self.style == CNBottomViewStyleShare) {
        drawerView = _viewSharePlat;
    }else if (self.style == CNBottomViewStyleForSign){
        drawerView = _viewSignInPlat;
    }
    if (hidden) {
        self.viewAccessory.top = SCREENH;
        [UIView animateWithDuration:0.2 delay:0.0 options:0 animations:^{
            self.imgvBackground.alpha = 0;
            if (drawerView) {
                drawerView.center = CGPointMake(drawerView.centerX, weakSelf.height+drawerView.height);
            }
        } completion:^(BOOL finished) {
            NSLog(@"hidden");
            [weakSelf removeFromSuperview];
            [delegate.crispyMenu  setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
        }];
        
    }else{

        
        UIViewController *topVC = [self appRootViewController];
        [topVC.view addSubview:self];
        //        [self.nav.view addSubview:self];
        
        [UIView animateWithDuration:0.2 delay:0.0 options:0 animations:^{
            self.imgvBackground.alpha = 0.70;
            if (drawerView) {
                drawerView.center = CGPointMake(drawerView.centerX, weakSelf.height-drawerView.height*0.5);
            }
        } completion:^(BOOL finished) {
            NSLog(@"nohidden");
            // 禁掉抽屉滑动出现功能。
            [delegate.crispyMenu  setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeCustom];
        }];
    }
}



- (UIViewController *)appRootViewController
{
    //    UIWindow *window = [[[UIApplication sharedApplication] windows] lastObject];
    //    return window.rootViewController;
    
#if 1
    UIViewController *appRootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    UIViewController *topVC = appRootVC;
    while (topVC.presentedViewController) {
        topVC = topVC.presentedViewController;
    }
    return topVC;
#endif
    
}


@end
