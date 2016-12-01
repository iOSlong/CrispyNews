//
//  CNDefult.h
//  CrispyNews
//
//  Created by xuewu.long on 16/9/6.
//  Copyright © 2016年 letv. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CNAccount.h"

@interface CNDefult : NSObject

+ (instancetype)shareDefult;
@property (nonatomic, strong, readonly)NSUserDefaults *defult;
@property (nonatomic, assign) CNStatus cnStatus;
@property (nonatomic, strong) NSNumber *serverMode;     // 0 测试， 1 线上直连， 2 专线(亚军)
@property (nonatomic, strong) NSNumber *webType;        // 0 MKWebView,   1 UIWebView
@property (nonatomic, strong) NSNumber *netSrc;         // 1 内网， 2 外网
@property (nonatomic, strong) NSNumber *userState;      // 0 未登录，1 登录状态
@property (nonatomic, strong) NSNumber *imgShowControl; // 0 不做限制   1 对特定网络下图片加载做限制
@property (nonatomic, strong) NSString *deviceToken;
@property (nonatomic, strong) NSString *fbToken; // 登录FaceBooktoken
@property (nonatomic, strong) NSString *uid;     // 登录用户的uid
@property (nonatomic, strong) NSString *token;   // 登录用户的token
@property (nonatomic, strong) NSNumber *notificationsType;  // 1 开  0 关
@property (nonatomic, strong) NSNumber *noImageType;  // 1 开  0 关

@property (nonatomic, strong) CNAccount *account;

@property (nonatomic, strong) NSNumber  *locLineCollectionCount;// 已经同步到本地的线上收藏新闻的数目

+ (CNAccount *)defaultAccount;


//TODO 账号切换的时候，可以选择性清楚Default中的信息内容。
- (void)clearDefaults;



/*
 accessToken:
 EAARNFJekbXkBANebulJnul1NSPrFjqmvqGbkDOYCU1gZBZALAzEwuMgCoZAcseBvaMhJXYvZBQeG6IhLARWHNJkeyH1E1TlbsZCcDmOUjKlpOQYCJbOMCfhD7Qi6NauTHpMMtTl9iFt1Hejl1NebtYnLvuIZCUthrS58xY4NLZBVrqJzy9ZCgechHbDav57bYUhbjBgbLe4Gedc7AN3HFV0ZCL9pt5OYZClU0ZD
 */

@end
