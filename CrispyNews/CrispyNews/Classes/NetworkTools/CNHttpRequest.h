//
//  CNHttpRequest.h
//  CrispyNews
//
//  Created by xuewu.long on 16/8/9.
//  Copyright © 2016年 letv. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>

@interface CNHttpRequest : NSObject

@property (nullable,nonatomic, strong) AFHTTPSessionManager *httpSessionManager;

+ (_Nullable instancetype)shareHttpRequest;





- (nullable NSURLSessionDataTask *)GET:(nullable NSString *)URLString
                            parameters:(nullable id)parameters
                               success:(nullable void (^)(NSURLSessionDataTask *task, id _Nullable responseObject))success
                               failure:(nullable void (^)(NSURLSessionDataTask * _Nullable task, NSError *error))failure;




- (NSURLSessionDataTask *)GET:(NSString *)URLString
                   parameters:(nullable id)parameters
                     progress:(void (^)(NSProgress * _Nonnull))downloadProgress
                      success:(nullable void (^)(NSURLSessionDataTask *task, id _Nullable responseObject))success
                      failure:(nullable void (^)(NSURLSessionDataTask * _Nullable task, NSError *error))failure;



@end
