//
//  CNChangeSeverViewController.m
//  CrispyNews
//
//  Created by xuewu.long on 16/9/6.
//  Copyright © 2016年 letv. All rights reserved.
//

#import "CNChangeServerViewController.h"

@interface CNChangeServerViewController ()

@property (nonatomic, strong) UILabel *labelTest;
@property (nonatomic, strong) UILabel *labelDirect;
@property (nonatomic, strong) UILabel *labelSpecial;
@property (nonatomic, strong) UILabel *labelLoginSta;
@property (nonatomic, strong) UILabel *labelWebType;

@property (nonatomic, strong) UIButton *btnTest;        // 链接测试服务器
@property (nonatomic, strong) UIButton *btnDirect;      // 直连服务器
@property (nonatomic, strong) UIButton *btnSpecial;     // 亚军专线
@property (nonatomic, strong) UISwitch *switchLogin;    // 登录状态切换按钮
@property (nonatomic, strong) UISwitch *switchWebType;  // MKWeb/UIWeb切换按钮


@property (nonatomic, strong) CNDefult *defult;

@end

@implementation CNChangeServerViewController {
    NSNumber *_tempServerMode;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"Server Seting";
    self.view.backgroundColor = [UIColor whiteColor];//RGBCOLOR_HEX(0xFF5800);

    
    
    _labelTest = [UILabel labelFrame:CGRectMake(0, 0, 150, 25) fontSize:17 textColor:RGBCOLOR_HEX(0x654321)];
    _labelTest.text = @"测试";
    
    _labelDirect = [UILabel labelFrame:CGRectMake(0, 0, 150, 25) fontSize:17 textColor:RGBCOLOR_HEX(0x654321)];
    _labelDirect.text = @"直连线上";

    _labelSpecial = [UILabel labelFrame:CGRectMake(0, 0, 150, 25) fontSize:17 textColor:RGBCOLOR_HEX(0x654321)];
    _labelSpecial.text = @"亚军专线";
    
    
    _labelLoginSta = [UILabel labelFrame:CGRectMake(0, 0, 240, 25) fontSize:15 textColor:RGBCOLOR_HEX(0x654321)];
    _labelLoginSta.text = @"登录状态切换（for 测试）";
    
    
    _labelWebType = [UILabel labelFrame:CGRectMake(0, 0, 240, 25) fontSize:15 textColor:RGBCOLOR_HEX(0x123456)];
    _labelWebType.text = @"MKWeb/UIWeb切换（for dev）";

    
    
    
    _btnTest    = [UIButton xk_buttonWithFrame:CGRectMake(0, 0, 50, 50) imageNormal:@"market_unselected_button" selectedImage:@"market_selected_button" target:self action:@selector(btnClick:)];
    _btnDirect  = [UIButton xk_buttonWithFrame:CGRectMake(0, 0, 50, 50) imageNormal:@"market_unselected_button" selectedImage:@"market_selected_button" target:self action:@selector(btnClick:)];
    _btnSpecial = [UIButton xk_buttonWithFrame:CGRectMake(0, 0, 50, 50) imageNormal:@"market_unselected_button" selectedImage:@"market_selected_button" target:self action:@selector(btnClick:)];

    _switchLogin = [[UISwitch alloc] initWithFrame:CGRectMake(0, 0, 80, 30)];
    _switchLogin.tintColor = CNCOLOR_THEME_EDIT;
    [_switchLogin addTarget:self action:@selector(switchValueChange:) forControlEvents:UIControlEventValueChanged];
    

    _switchWebType = [[UISwitch alloc] initWithFrame:CGRectMake(0, 0, 80, 30)];
    _switchWebType.tintColor = _labelWebType.textColor;
    [_switchWebType addTarget:self action:@selector(switchValueChange:) forControlEvents:UIControlEventValueChanged];

    
    _labelDirect.left   = k_SpanLeft;
    _labelDirect.top    = k_SpanLeft + 64;
    
    
    _labelTest.left     = k_SpanLeft;
    _labelTest.top      = _labelDirect.bottom + 2 * k_SpanLeft;
    
    _labelSpecial.left  = k_SpanLeft;
    _labelSpecial.top   = _labelTest.bottom + 2 * k_SpanLeft;
    
    _labelLoginSta.left = k_SpanLeft;
    _labelLoginSta.top  = _labelSpecial.bottom + 2 * k_SpanLeft;
    
    _labelWebType.left  = k_SpanLeft;
    _labelWebType.top   = _labelLoginSta.bottom + 2 * k_SpanLeft;
    
    
    _btnTest.right      = SCREENW - k_SpanLeft;
    _btnTest.centerY    = _labelTest.centerY;
    
    _btnDirect.right    = SCREENW - k_SpanLeft;
    _btnDirect.centerY  = _labelDirect.centerY;
    
    _btnSpecial.right   = SCREENW - k_SpanLeft;
    _btnSpecial.centerY = _labelSpecial.centerY;
    
    _switchLogin.right  = SCREENW - 1.5 * k_SpanLeft;
    _switchLogin.centerY= _labelLoginSta.centerY;
    
    
    _switchWebType.right  = SCREENW - 1.5 * k_SpanLeft;
    _switchWebType.centerY= _labelWebType.centerY;


    
    [self.view addSubview:_btnTest];
    [self.view addSubview:_btnDirect];
    [self.view addSubview:_btnSpecial];
    [self.view addSubview:_switchLogin];
    [self.view addSubview:_switchWebType];
    

    
    
    [self.view addSubview:_labelDirect];
    [self.view addSubview:_labelTest];
    [self.view addSubview:_labelSpecial];
    [self.view addSubview:_labelLoginSta];
    [self.view addSubview:_labelWebType];

    
    self.defult = [CNDefult shareDefult];
    if ([self.defult.serverMode integerValue]== 0) {
        
        _btnTest.selected       = YES;
        _btnDirect.selected     = NO;
        _btnSpecial.selected    = NO;

        
    }else if ([self.defult.serverMode integerValue] == 1) {
        
        _btnDirect.selected     = YES;
        _btnTest.selected       = NO;
        _btnSpecial.selected    = NO;

        
    }else if ([self.defult.serverMode integerValue] == 2) {
        
        _btnSpecial.selected    = YES;
        _btnTest.selected       = NO;
        _btnDirect.selected     = NO;

    }
    
    
    if ([self.defult.userState integerValue] == 1) {
        [_switchLogin setOn:YES];
        // other excutes
    }else{
        [_switchLogin setOn:NO];
        // other excutes
    }
    
    if ([self.defult.webType integerValue] == 1) {
        [_switchWebType setOn:YES];
    }else{
        [_switchWebType setOn:NO];
    }
}

- (void)btnClick:(UIButton *)btn {
    btn.selected = YES;
    if (btn == _btnTest) {
        self.defult.serverMode  = @0;
        _btnDirect.selected     = NO;
        _btnSpecial.selected    = NO;
    }else if (btn == _btnDirect){
        self.defult.serverMode = @1;
        _btnTest.selected       = NO;
        _btnSpecial.selected    = NO;
    }else if (btn == _btnSpecial){
        self.defult.serverMode = @2;
        _btnTest.selected       = NO;
        _btnDirect.selected     = NO;
    }
    [self showHint:@"切换服务！" hide:1.5];
    NSDictionary *info = @{notiSenter:NSStringFromClass([self class]),
                           notiEvent: [NSNumber numberWithInteger:CNEventTypeNotiServerChange]};
    [CNUtils postNotificationName:NOTI_CHANGESERVER_POST object:nil userInfo:info];

}

- (void)switchValueChange:(UISwitch *)sw {
    if (sw == _switchLogin) {
        if (sw.isOn) {
            if([CNDefult defaultAccount]){
                [CNUtils showHint:@"Sign In" hide:TIMER_HIDE_DELAY];
            }else{
                [CNUtils showHint:@"account wrong, you have to Login at least once！" hide:TIMER_HIDE_DELAY * 2];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(TIMER_HIDE_DELAY * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [sw setOn:NO animated:YES];
                });
            }
        }else{
            [CNDefult shareDefult].account = [CNAccount new];
            [CNUtils showHint:@"Sign Out" hide:TIMER_HIDE_DELAY];
        }
    }else if (sw == _switchWebType){
        if (sw.isOn) {
            self.defult.webType = @1;
            [CNUtils showHint:@"UIWebView" hide:TIMER_HIDE_DELAY];
        }else{
            self.defult.webType = @0;
            [CNUtils showHint:@"MKWebView" hide:TIMER_HIDE_DELAY];
        }
    }
}


@end



