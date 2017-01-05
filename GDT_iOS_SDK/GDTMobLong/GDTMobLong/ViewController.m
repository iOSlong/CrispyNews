//
//  ViewController.m
//  GDTMobLong
//
//  Created by xuewu.long on 16/12/27.
//
//

#import "ViewController.h"
#import "NativeAdView.h"

@interface ViewController ()<GDTNativeAdDelegate>

@end

@implementation ViewController {
    GDTNativeAd *_nativeAd;     //原生广告实例
    NSArray *_data;             //原生广告数据数组
    GDTNativeAdData *_currentAd;//当前展示的原生广告数据对象
    NativeAdView *_nativeView;
    
    UIViewController *_desVC;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    _nativeView = [[NativeAdView alloc] initWithFrame:CGRectMake(0,[UIScreen mainScreen].bounds.size.height - 200, [UIScreen mainScreen].bounds.size.width, 100)];
    _nativeView.backgroundColor = [UIColor colorWithWhite:0.8 alpha:0.6];
    [self.view addSubview:_nativeView];
    
    [_nativeView nativeAdBlock:^{
        [_nativeAd clickAd:_currentAd];
    }];
    [self getDataOfNativeAd];
    
    
    
    
    UIButton * but = [[UIButton alloc]initWithFrame:CGRectMake(50, 50, 100, 100)];
    [but setBackgroundImage:[UIImage imageNamed:@"SplashBottomLogo.jpg"] forState:UIControlStateNormal];
    but.backgroundColor = [UIColor redColor];
    [self.view addSubview:but];
    
    UIBlurEffect * blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleRegular];
    UIVisualEffectView * effe = [[UIVisualEffectView alloc]initWithEffect:blur];
    effe.alpha = 0.7;
    effe.frame = CGRectMake(0, 0, but.frame.size.width - 10, but.frame.size.height - 10);
    // 把要添加的视图加到毛玻璃上
    [but addSubview:effe];


    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    static int hhh = 0;
    hhh ++;
    if (hhh%2 == 1) {
        _nativeView.imgvShow.clipsToBounds = YES;
    }else{
        _nativeView.imgvShow.clipsToBounds = NO;
    }
}

/**
 *  原生广告点击之后将要展示内嵌浏览器或应用内AppStore回调
 */
- (void)nativeAdWillPresentScreen
{
    NSLog(@"%s",__FUNCTION__);
}








#pragma mark - GetNativeAd
- (void)getDataOfNativeAd {
    NSString *demoID = @"1105344611";
    NSString *demoAdID = @"1080215124193862";
    
    NSString *sdspID = @"1105916224";
    NSString *sdspAdID1 = @"8010112801386390";
    NSString *sdspAdID2 = @"5030013851731322";
    NSString *sdspDownLoadAdID = @"1060919851030331";

    
    
    NSString *sdspAdID = @"6090919871932330";

    /*
     * 创建原生广告
     * "appkey" 指在 http://e.qq.com/dev/ 能看到的app唯一字符串
     * "placementId" 指在 http://e.qq.com/dev/ 生成的数字串，广告位id
     *
     * 本原生广告位ID在联盟系统中创建时勾选的详情图尺寸为1280*720，开发者可以根据自己应用的需要
     * 创建对应的尺寸规格ID
     *
     * 这里详情图以1280*720为例
     */
    
//    _desVC  = [UIViewController new]; 
    
    _nativeAd = [[GDTNativeAd alloc] initWithAppkey:sdspID placementId:demoAdID];
    _nativeAd.controller = self;
    _nativeAd.delegate = self;
    
    /*
     * 拉取广告,传入参数为拉取个数。
     * 发起拉取广告请求,在获得广告数据后回调delegate
     */
    [_nativeAd loadAd:5]; //这里以一次拉取一条原生广告为例

}

- (void)nativeAdSuccessToLoad:(NSArray *)nativeAdDataArray {
    _data = nativeAdDataArray;
    NSMutableString *result = [NSMutableString string];
    for (GDTNativeAdData *data in nativeAdDataArray) {
        [result appendFormat:@"%@",data.properties];
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        _nativeView.adData = _data.firstObject;
        _currentAd = _data.firstObject;
        [_nativeAd attachAd:_currentAd toView:self.view];
    });
}

- (void)nativeAdFailToLoad:(NSError *)error {
    NSLog(@"%@",error);
}

@end
