//
//  CNHttpRequest.m
//  CrispyNews
//
//  Created by xuewu.long on 16/8/9.
//  Copyright © 2016年 letv. All rights reserved.
//

#import "CNHttpRequest.h"
#import "UIDeviceHardware.h"
#import "OpenUDID.h"
#import "CNDataLoad.h"


@implementation CNNetInfo
-(NSString *)vs {
    return [NSString stringWithFormat:@"%@",self.version];
}
- (NSString *)limit {
    if (self.ext) {
        return [self.ext objectForKey:@"limit"];
    }
    return nil;
}
- (NSString *)page {
    if (self.ext) {
        return [self.ext objectForKey:@"page"];
    }
    return nil;
}
- (NSString *)totalPage {
    if (self.ext) {
        return [self.ext objectForKey:@"totalPage"];
    }
    return nil;
}
- (NSString *)data {
    if (self.ext) {
        return [self.ext objectForKey:@"data"];
    }
    return nil;
}
- (NSString *)offset {
    if (self.ext) {
        return [self.ext objectForKey:@"offset"];
    }
    return nil;
}
- (NSString *)total {
    if (self.ext) {
        return [self.ext objectForKey:@"total"];
    }
    return nil;
}

- (NSString *)recId {
    if (self.ext) {
        return [self.ext objectForKey:@"recId"];
    }
    return nil;
}



@end


@interface CNHttpRequest ()
@property (nonatomic, strong) NSURL *baseURL;
@property (nonatomic, copy, readonly)void(^NetMonitorBlock)(AFNetworkReachabilityStatus status);

@end
@implementation CNHttpRequest

+ (instancetype)shareHttpRequest {
    static dispatch_once_t  onceToken;
    static CNHttpRequest    *thisHR;
    dispatch_once(&onceToken, ^{
        thisHR = [[self alloc] init];
    });
    
    
    return thisHR;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
//        self.httpSessionManager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:[CNUtils getNewsServerHost]]];
        
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration  defaultSessionConfiguration];
        [configuration setRequestCachePolicy:NSURLRequestReloadIgnoringCacheData];
        
        self.httpSessionManager = [[AFHTTPSessionManager alloc] initWithBaseURL:nil sessionConfiguration:configuration];
        
        
        
        self.httpSessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
        
        [self setHttpHeader:@{}];
        
        self.httpSessionManager.requestSerializer.timeoutInterval = TOPNEWS_HTTP_SERVER_TIMEOUT;
        _netStatus = AFNetworkReachabilityStatusUnknown; // 默认情况下
        
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(eventWithNoti:) name:NOTI_USERLOGINSTATE_CHANGE object:nil];

        
    }
    return self;
}

- (void)eventWithNoti:(NSNotification *)noti {
    NSLog(@"%@",[noti.userInfo objectForKey:notiSenter]);
    NSInteger cnEvent = [[noti.userInfo objectForKey:notiEvent] integerValue];
    if (cnEvent == CNEventTypeNotiLoginStateChange) {
        BOOL status = [[noti.userInfo objectForKey:notiBool] boolValue];
        if (status) {
            NSLog(@"into TestSign_In status");
        }else{
            NSLog(@"into TestSign_Out Status");
        }
    
        [self setHttpHeader:@{}];
    }
}

- (void)upDateBaseUrl:(NSString *)baseUrl {
    self.baseURL = [NSURL URLWithString:baseUrl];
}

- (void)cancelAllOperations {
    [self.httpSessionManager.operationQueue cancelAllOperations];
}

- (void)showActivity:(BOOL)visible {
    return;
    if (visible) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    }else{
        if ([CNDataLoad shareDataLoad].isLoading == NO) {
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        }
    }
}

#pragma mark - URLRequest
- (NSURLSessionDataTask *)GET:(NSString *)URLString parameters:(id)parameters success:(void (^)(NSURLSessionDataTask *, id _Nullable))success failure:(void (^)(NSURLSessionDataTask * _Nullable, NSError *))failure {
    NSLog(@"postUrl:%@",URLString);
    URLString = [CNHttpRequest commonUserInfo:URLString];
    
    [self showActivity:YES];
    
    weakSelf();
    NSURLSessionDataTask *dataTast = [self.httpSessionManager GET:URLString parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        NSLog(@"downloadProgress:%@",downloadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(task, responseObject);
        [weakSelf showActivity:NO];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(task, error);
        [weakSelf showActivity:NO];
    }];
    
//    [self.httpSessionManager.reachabilityManager startMonitoring];

    return dataTast;
}



- (NSURLSessionDataTask *)POST:(NSString *)URLString parameters:(id)parameters success:(void (^)(NSURLSessionDataTask * _Nonnull, id _Nonnull))success failure:(void (^)(NSURLSessionDataTask * _Nonnull, NSError * _Nonnull))failure {
  
    NSLog(@"postUrl:%@",URLString);
    URLString = [CNHttpRequest commonUserInfo:URLString];
    
    [self showActivity:YES];
    weakSelf();
    NSURLSessionDataTask *dataTast = [self.httpSessionManager POST:URLString parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        NSLog(@"");
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(task, responseObject);
        [weakSelf showActivity:NO];

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(task, error);
        [weakSelf showActivity:NO];
    }];
    
//    [self.httpSessionManager.reachabilityManager startMonitoring];

    return dataTast;
}



#pragma mark -  AFNetworkReachabilityStatus
- (void)starMonitoringNetReachability:(void (^)(AFNetworkReachabilityStatus))monitor {
    //    AFNetworkReachabilityManager *reachabilityM = [AFNetworkReachabilityManager sharedManager];
    _NetMonitorBlock = monitor;
    weakSelf();
    [self.httpSessionManager.reachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        _netStatus = status;
        if (weakSelf.NetMonitorBlock) {
            weakSelf.NetMonitorBlock(status);
        }
        CNDefult *myDefaul = [CNDefult shareDefult];
        switch (status) {
            case AFNetworkReachabilityStatusNotReachable:{
                myDefaul.cnStatus = CNStatusNetNotReachable;
            }
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN:{
                myDefaul.cnStatus = CNStatusNetReachableViaWWAN;
            }
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:{
                myDefaul.cnStatus = CNStatusNetReachableViaWifi;
            }
                break;
            case AFNetworkReachabilityStatusUnknown:{
                myDefaul.cnStatus = CNStatusNetReachableUnknown;
            }
                break;
            default:
                break;
        }
    }];
    [self.httpSessionManager.reachabilityManager startMonitoring];
}



#pragma mark - URL_suffix Info
+ (NSString *) commonUserInfo:(NSString *)urlString
{
    //
    NSDictionary *dict = [CNHttpRequest getUserAgentInfo];
    if (dict.count == 0) {
        return urlString;
    }
    NSArray *keys = [dict allKeys];
    if (keys.count == 0) {
        return urlString;
    }
    
    
    NSRange range = [urlString rangeOfString:@"?" options:NSBackwardsSearch];
    if (range.location == NSNotFound) {
        urlString = [urlString stringByAppendingString:@"?"];
    }else{
        urlString = [urlString stringByAppendingString:@"&"];
    }
    
    //
    NSString *sufix = @"";
    for (NSInteger i=0; i<keys.count; i++) {
        NSString *key = [keys objectAtIndex:i];
        NSString *value = [dict objectForKey:key];
        NSString *pair = @"";
        if (i == keys.count - 1) {
            pair = [NSString stringWithFormat:@"%@=%@",key,value];
        }else{
            pair = [NSString stringWithFormat:@"%@=%@&", key, value];
        }
        sufix = [sufix stringByAppendingString:pair];
    }
    //
    sufix = [sufix stringByRemovingPercentEncoding];
    
    
    NSCharacterSet *set = [NSCharacterSet characterSetWithCharactersInString:@"!*'();:@+$,/[]"];
    
//    CFSTR("!*'();:@+$,/[]=?&#"),
    
    sufix = [sufix stringByAddingPercentEncodingWithAllowedCharacters:set];
    
    sufix = [sufix stringByReplacingOccurrencesOfString:@" " withString:@"-"];
    urlString = [urlString stringByAppendingString:sufix];
    
    return urlString;
    
}


+ (NSDictionary*)getUserAgentInfo{
    static NSDictionary *userAgentInto = nil;
    if (userAgentInto && userAgentInto.count>0)
    {
        return userAgentInto;
    }
    else{
        //	app版本
        NSString *appVer = [APPVERSION stringByRemovingPercentEncoding];
        //	app平台KEYFROM
        NSString *keyfrom = [KEYFROM stringByRemovingPercentEncoding];
      
        //	设备唯一标识
        NSString *imei = [[OpenUDID value] stringByRemovingPercentEncoding];

        
        CGSize winSize = [UIScreen mainScreen].bounds.size;
        //	设备屏幕大小
        NSString *screenW = [NSString stringWithFormat:@"%.0f", winSize.width];
        NSString *screenH = [NSString stringWithFormat:@"%.0f", winSize.height];
        
        //	model是手机型号
        NSString *model = [[UIDeviceHardware platformString] stringByRemovingPercentEncoding];
        //	手机系统
        NSString *mid = [[[UIDevice currentDevice] systemVersion] stringByRemovingPercentEncoding];
        //	app安装渠道
        NSString *vendor = [VENDOR stringByRemovingPercentEncoding];
        
        
        NSString *randomUUID = [CNUtils myRandomUUID];
        
        NSDictionary *dict = @{@"platform":@"iOS",
                          @"device":model,
                          @"deviceId":imei,
                          @"appVer":appVer,
                          @"screenH":screenH,
                          @"screenW":screenW,
                          @"osVer":mid,
                          @"vendor":vendor,
                          @"keyfrom":keyfrom,
                          @"eid":randomUUID,
                          };
        
        userAgentInto = dict;
        CNOUT(userAgentInto);
        
    }
    
    return userAgentInto;
}

- (void)setHttpHeader:(NSDictionary *)headerInfo {
    //    "token":"",//如果是登录状态
    //    "uid":"",//如果是登录状态
    //    "productId" :"",// android 是6000011，IOS 是6000010 （必须）(done)
    //    "deviceNum" : "", //设备号 必须(done)
    //    "version" :"",//客户端版本 必须 (done)
    //    "imei":"",//手机imei 必须     (done)
    //    "mac":"",//手机mac 必须   (done)
    //    "longitude":"", //用户位置的经度（如果有）
    //    "latitude":"",//用户位置的纬度（如果有）
    //    "cid":"",//手机基站的编号（如果有）
    //    "lac":""//手机基站区域码（如果有）
    
    NSString *token     = [CNDefult shareDefult].token;
    NSString *uid       = [CNDefult shareDefult].uid;
    NSString *productId = @"6000010";
    NSString *mac       = [CNUtils getUUID];
    NSString *eid       = [CNUtils myRandomUUID];
    NSString *imei      = [CNUtils getDeviceUIID];
    NSString *deviceNum = [CNUtils getDeviceUIID];
    NSString *version   = [APPVERSION stringByRemovingPercentEncoding];
    
    
    
    if (headerInfo && [headerInfo allKeys].count) {
        [self.httpSessionManager.requestSerializer setValuesForKeysWithDictionary:headerInfo];
    }
    
    [self.httpSessionManager.requestSerializer setValue:token forHTTPHeaderField:@"token"];
    [self.httpSessionManager.requestSerializer setValue:uid forHTTPHeaderField:@"uid"];
    [self.httpSessionManager.requestSerializer setValue:productId forHTTPHeaderField:@"productId"];
    [self.httpSessionManager.requestSerializer setValue:deviceNum forHTTPHeaderField:@"deviceNum"];
    [self.httpSessionManager.requestSerializer setValue:imei forHTTPHeaderField:@"imei"];
    [self.httpSessionManager.requestSerializer setValue:eid forHTTPHeaderField:@"eid"];
    [self.httpSessionManager.requestSerializer setValue:mac forHTTPHeaderField:@"mac"];
    [self.httpSessionManager.requestSerializer setValue:version forHTTPHeaderField:@"version"];
    
    NSDictionary *dict = @{@"platform":@"iOS",
                           @"token":token,
                           @"uid":uid,
                           @"mac":mac,
                           @"eid":eid,
                           @"imei":imei,
                           @"deviceNum":deviceNum,
                           @"productId":productId,
                           };
    _requestHeader = dict;
}


@end
