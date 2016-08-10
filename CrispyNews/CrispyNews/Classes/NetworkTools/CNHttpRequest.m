//
//  CNHttpRequest.m
//  CrispyNews
//
//  Created by xuewu.long on 16/8/9.
//  Copyright © 2016年 letv. All rights reserved.
//

#import "CNHttpRequest.h"

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
        self.httpSessionManager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:kNet_baseURL]];
        self.httpSessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    }
    return self;
}


- (NSURLSessionDataTask *)GET:(NSString *)URLString parameters:(id)parameters success:(void (^)(NSURLSessionDataTask *, id _Nullable))success failure:(void (^)(NSURLSessionDataTask * _Nullable, NSError *))failure {
    NSURLSessionDataTask *dataTast = [self.httpSessionManager GET:URLString parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(task, responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(task, error);
    }];
    
    return dataTast;
}

- (NSURLSessionDataTask *)GET:(NSString *)URLString parameters:(id)parameters progress:(void (^)(NSProgress * _Nonnull))downloadProgress success:(void (^)(NSURLSessionDataTask * _Nonnull, id _Nullable))success failure:(void (^)(NSURLSessionDataTask * _Nullable, NSError * _Nonnull))failure{
    NSURLSessionDataTask *dataTast = [self.httpSessionManager GET:URLString parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {

    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(task, responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(task, error);
    }];
    
    return dataTast;
}




@end
