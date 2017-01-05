//
//  GDTNativeViewController.m
//  GDTMobApp
//
//  Created by michaelxing on 2016/11/2.
//  Copyright © 2016年 Tencent. All rights reserved.
//

#import "NativeViewController.h"
#import "GDTNativeAd.h"

@interface NativeViewController ()<GDTNativeAdDelegate>
{
    GDTNativeAd *_nativeAd;     //原生广告实例
    NSArray *_data;             //原生广告数据数组
    GDTNativeAdData *_currentAd;//当前展示的原生广告数据对象
    UIView *_adView;            //当前展示的原生广告界面
    
    // 业务相关
    BOOL _attached;
}

@property (weak, nonatomic) IBOutlet UITextView *resultTV;
@property (weak, nonatomic) IBOutlet UITextField *posTextField;

@end

@implementation NativeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)loadAd:(id)sender {
    if (_attached) {
        [UIView animateWithDuration:0.5 animations:^{
            CGRect adviewFrame = _adView.frame;
            adviewFrame.origin.x += [[UIScreen mainScreen] bounds].size.width;
            _adView.frame = adviewFrame;
            CGRect textViewFrame = _resultTV.frame;
            textViewFrame.origin.x += [[UIScreen mainScreen] bounds].size.width;
            _resultTV.frame = textViewFrame;
            
        } completion:^(BOOL finished) {
            [_adView removeFromSuperview];
            _adView = nil;
        }];
        _attached = NO;
    }
    
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
    
    _nativeAd = [[GDTNativeAd alloc] initWithAppkey:@"1105344611" placementId:_posTextField.text];
    _nativeAd.controller = self;
    _nativeAd.delegate = self;
    
    /*
     * 拉取广告,传入参数为拉取个数。
     * 发起拉取广告请求,在获得广告数据后回调delegate
     */
    [_nativeAd loadAd:5]; //这里以一次拉取一条原生广告为例
    
}
- (IBAction)attach:(id)sender {
    if (_data && !_attached) {
        /*选择展示广告*/
        _currentAd = [_data objectAtIndex:0];
        
        /*开始渲染广告界面*/
        _adView = [[UIView alloc] initWithFrame:CGRectMake(320, 150, 320, 250)];
        _adView.layer.borderWidth = 1;
        _adView.backgroundColor = [UIColor whiteColor];
        
        /*广告详情图*/
        UIImageView *imgV = [[UIImageView alloc] initWithFrame:CGRectMake(2, 70, 316, 176)];
        [_adView addSubview:imgV];
        NSURL *imageURL = [NSURL URLWithString:[_currentAd.properties objectForKey:GDTNativeAdDataKeyImgUrl]];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
            NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
            dispatch_async(dispatch_get_main_queue(), ^{
                imgV.image = [UIImage imageWithData:imageData];
            });
        });
        
        /*广告Icon*/
        UIImageView *iconV = [[UIImageView alloc] initWithFrame:CGRectMake(10, 5, 60, 60)];
        [_adView addSubview:iconV];
        NSURL *iconURL = [NSURL URLWithString:[_currentAd.properties objectForKey:GDTNativeAdDataKeyIconUrl]];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
            NSData *imageData = [NSData dataWithContentsOfURL:iconURL];
            dispatch_async(dispatch_get_main_queue(), ^{
                iconV.image = [UIImage imageWithData:imageData];
            });
        });
        
        /*广告标题*/
        UILabel *txt = [[UILabel alloc] initWithFrame:CGRectMake(80, 5, 100, 35)];
        txt.text = [_currentAd.properties objectForKey:GDTNativeAdDataKeyTitle];
        [_adView addSubview:txt];
        
        /*广告描述*/
        UILabel *desc = [[UILabel alloc] initWithFrame:CGRectMake(80, 45, 200, 20)];
        desc.text = [_currentAd.properties objectForKey:GDTNativeAdDataKeyDesc];
        [_adView addSubview:desc];
        
        [self.view addSubview:_adView];
        
        /*注册点击事件*/
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
        [_adView addGestureRecognizer:tap];
        
        //动画开始
        [UIView animateWithDuration:0.5 animations:^{
            CGRect adviewFrame = _adView.frame;
            adviewFrame.origin.x -= [[UIScreen mainScreen] bounds].size.width;
            _adView.frame = adviewFrame;
            CGRect textViewFrame = _resultTV.frame;
            textViewFrame.origin.x -= [[UIScreen mainScreen] bounds].size.width;
            _resultTV.frame = textViewFrame;
        } completion:nil];
        
        /*
         * 广告数据渲染完毕，即将展示时需调用AttachAd方法。
         */
        [_nativeAd attachAd:_currentAd toView:_adView];
        
        _attached = YES;
        
    } else if (_attached){
        _resultTV.text = @"Already attached";
    } else {
        _resultTV.text = @"原生广告数据拉取失败，无法Attach";
    }

}

- (void)viewTapped:(UITapGestureRecognizer *)gr {
    /*点击发生，调用点击接口*/
    [_nativeAd clickAd:_currentAd];
}


-(void)nativeAdSuccessToLoad:(NSArray *)nativeAdDataArray
{
    NSLog(@"%s",__FUNCTION__);
    /*广告数据拉取成功，存储并展示*/
    _data = nativeAdDataArray;
    dispatch_async(dispatch_get_main_queue(), ^{
        NSMutableString *result = [NSMutableString string];
        [result appendString:@"原生广告返回数据:\n"];
        for (GDTNativeAdData *data in nativeAdDataArray) {
            [result appendFormat:@"%@",data.properties];
            [result appendString:@"\n------------------------"];
        }
        
        _resultTV.text = result;
    });
}

-(void)nativeAdFailToLoad:(NSError *)error
{
    NSLog(@"%@",error);
    /*广告数据拉取失败*/
    _data = nil;
    dispatch_async(dispatch_get_main_queue(), ^{
        _resultTV.text = [NSString stringWithFormat:@"原生广告数据拉取失败, %@\n",error];
    });
}

/**
 *  原生广告点击之后将要展示内嵌浏览器或应用内AppStore回调
 */
- (void)nativeAdWillPresentScreen
{
    NSLog(@"%s",__FUNCTION__);
}

/**
 *  原生广告点击之后应用进入后台时回调
 */
- (void)nativeAdApplicationWillEnterBackground
{
    NSLog(@"%s",__FUNCTION__);
}

- (void)nativeAdClosed
{
    NSLog(@"%s",__FUNCTION__);
}
@end
