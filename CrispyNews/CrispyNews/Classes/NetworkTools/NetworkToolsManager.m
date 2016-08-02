//
//  NetworkToolsManager.m
//  我的NewsBoard
//
//  Created by mac on 16/1/2.
//  Copyright © 2016年 陈肖坤. All rights reserved.
//

#import "NetworkToolsManager.h"
#import "NetworkTools.h"

@implementation NetworkToolsManager

+ (void)getWithURLString:(NSString *)urlString parameters:(id)parameters  ResultBlock:(ResultBlock)resultBlock{
    //1.创建我们的管理类
    NetworkTools *networkTools = [NetworkTools sharedNetworkTools];
    
    //2.发送GET请求
    [networkTools GET:urlString parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        //3.将我们拿到的结果返回给调用者(上一层)去处理,我本身只做为一个桥梁,我只负责拿到URL去加载数据,然后将数据交给调用都去处理
        if (resultBlock) {
            resultBlock(responseObject);
        }

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (resultBlock) {
            resultBlock(error);
        }

    }];
//    [networkTools GET:urlString parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
//        //NSLog(@"%@----",[NSThread currentThread]);
//        
//        //3.将我们拿到的结果返回给调用者(上一层)去处理,我本身只做为一个桥梁,我只负责拿到URL去加载数据,然后将数据交给调用都去处理
//        if (resultBlock) {
//            resultBlock(responseObject);
//        }
//    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
//        if (resultBlock) {
//            resultBlock(error);
//        }
//    }];
}

@end
