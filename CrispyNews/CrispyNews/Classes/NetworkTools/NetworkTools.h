//
//  NetworkTools.h
//  我的NewsBoard
//
//  Created by mac on 16/1/2.
//  Copyright © 2016年 陈肖坤. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>

@interface NetworkTools : AFHTTPSessionManager

//重写 AFN 返回字段
+ (instancetype)sharedNetworkTools;

@end
