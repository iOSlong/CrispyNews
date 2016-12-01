//
//  CNHttpRequest.h
//  CrispyNews
//
//  Created by xuewu.long on 16/8/9.
//  Copyright © 2016年 letv. All rights reserved.
//

/* code about:
 200 OK - [GET]：服务器成功返回用户请求的数据，该操作是幂等的（Idempotent）。
 201 CREATED - [POST/PUT/PATCH]：用户新建或修改数据成功。
 202 Accepted - [*]：表示一个请求已经进入后台排队（异步任务）
 204 NO CONTENT - [DELETE]：用户删除数据成功。
 400 INVALID REQUEST - [POST/PUT/PATCH]：用户发出的请求有错误，服务器没有进行新建或修改数据的操作，该操作是幂等的。
 401 Unauthorized - [*]：表示用户没有权限（令牌、用户名、密码错误）。
 403 Forbidden - [*] 表示用户得到授权（与401错误相对），但是访问是被禁止的。
 404 NOT FOUND - [*]：用户发出的请求针对的是不存在的记录，服务器没有进行操作，该操作是幂等的。
 406 Not Acceptable - [GET]：用户请求的格式不可得（比如用户请求JSON格式，但是只有XML格式）。
 410 Gone -[GET]：用户请求的资源被永久删除，且不会再得到的。
 422 Unprocesable entity - [POST/PUT/PATCH] 当创建一个对象时，发生一个验证错误。
 500 INTERNAL SERVER ERROR - [*]：服务器发生错误，用户将无法判断发出的请求是否成功。
 */

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>
#import "CNObject.h"
#import "CNApiManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface CNNetInfo : CNObject

@property (nonatomic, assign) NSInteger     code;
@property (nonatomic, assign) NSInteger     success;
@property (nonatomic, strong) NSString      *errorMsg;
@property (nonatomic, strong) NSString      *version;
@property (nonatomic, strong) NSString      *vs;
@property (nonatomic, strong) NSDictionary  *ext;
@property (nonatomic, strong) NSString      *recId;

@property (nonatomic, strong) NSString *limit;
@property (nonatomic, strong) NSString *offset;
@property (nonatomic, strong) NSString *page;
@property (nonatomic, strong) NSString *total;
@property (nonatomic, strong) NSString *totalPage;

@end




@interface CNHttpRequest : NSObject

@property (nullable, nonatomic, strong) AFHTTPSessionManager *httpSessionManager;
@property (nonatomic, assign, readonly) AFNetworkReachabilityStatus netStatus;
@property (nonatomic, strong, readonly) NSDictionary *requestHeader;

+ (_Nullable instancetype)shareHttpRequest;

- (void)setHttpHeader:(NSDictionary *)headerInfo;

- (void)starMonitoringNetReachability:(void(^)(AFNetworkReachabilityStatus status))monitor;

- (void)upDateBaseUrl:(NSString *)baseUrl;

- (void)cancelAllOperations;



- (nullable NSURLSessionDataTask *)GET:(nullable NSString *)URLString
                            parameters:(nullable id)parameters
                               success:(nullable void (^)(NSURLSessionDataTask *task, id _Nullable responseObject))success
                               failure:(nullable void (^)(NSURLSessionDataTask * _Nullable task, NSError *error))failure;




- (NSURLSessionDataTask *)POST:(NSString *)URLString
                    parameters:(id)parameters
                       success:(void (^)(NSURLSessionDataTask * task, id responseObject))success
                       failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;




@end

NS_ASSUME_NONNULL_END

