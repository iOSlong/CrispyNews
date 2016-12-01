//
//  CNUtils.h
//  CrispyNews
//
//  Created by xuewu.long on 16/8/26.
//  Copyright © 2016年 letv. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Agnes.h"

static NSString * const KEY_IN_KEYCHAIN = @"com.myuuid.uuid";
static Agnes    *globleAgnes    = nil;
static AGS_App  *globleApp      = nil;

@interface CNUtils : NSObject

#pragma mark - Server About
/// 获取服务器地址
+ (NSString *) getNewsServerHost;

/// 获取Push 服务器地址
+ (NSString *) getPushServerHost;

//获取 share 服务器
+ (NSString *) getShareServerHost;

+ (CNStatus) getStatusBarNetInfo;


#pragma mark - UIDefault About

+ (CGFloat)fontSizePreference:(CGFloat)fontSize;

+ (UIFont *)fontPreference:(NSString *)fontName size:(CGFloat)fontSize;


#pragma mark - File Directory About

// 数据库路径
+ (NSString *)pathOfDatabase;

// 下载文件夹路径
+ (NSString *)pathOfNameSpace;

// 获取UI加载图片，下模板等资源路径
+ (NSString *)pathOfNewsDetail;

// 获取图片列表目录（包括新闻list.json）
+ (NSString *)pathOfImageList;

// 获取原生网络缓存文件路径
+ (NSString *)pathOfNetCache;



// 获取指定目录下的文件，
+ (NSArray <NSString *> *)allFilePathInDirectory:(NSString *)dirPath isDir:(BOOL)isDir;
+ (NSArray <NSString *> *)allFileInDirectory:(NSString *)dirPath isDir:(BOOL)isDir;

// 将dirPath中的类容 移动到desDir中，然后删除dirPath
+ (BOOL)filesMoveDir:(NSString *)dirPath toDir:(NSString *)desDir;

// 在指定目录中查找是否存在文件
+ (BOOL)file:(NSString *)file existsAtDirectory:(NSString *)desDir;

// 将指定目录中的图片文件进行编码
+ (BOOL)cnImgurlFilecodeInPath:(NSString *)dirPath;

// 读取jsonName 文件
+ (id)jsonFromPath:(NSString *)dirPath jsonName:(NSString *)jsonName;
// 读取文件二进制数据
+ (NSData *)dataFromPath:(NSString *)filePath;

+ (BOOL)isExistCacheImgListOfURL:(NSString *)imgurl;

// 计算指定路径的文件大小
+ (void)file:(NSString *)filePath size:(void(^)(NSString *fileSize))sizeBlock;
+ (void)fileCNIMGClear;



//===================================================================================
#pragma mark - Device About
+ (NSString *)getDeviceUIID;
// 随机生成一个字符串
+ (NSString *)myRandomUUID;
// 检测app是否在后台.
+ (BOOL)isAppRunInBackground;

+ (BOOL)isAppRunInForeground;



#pragma mark - keychainAbout

+ (NSMutableDictionary *)getKeychainQuery:(NSString *)service;

+ (void)save:(NSString *)service data:(id)data;

+ (id)load:(NSString *)service;

+ (void)delete:(NSString *)service;

#pragma mark - UUID
+(void)saveUUID:(NSString *)uuid;

+(NSString *)getUUID;

+(void)deleteUUID;


#pragma mark - Time About
+ (NSString *)newsTimeFormat:(long long)timestamp;

    
#pragma mark - postShow flip pall
+ (void)showHint:(NSString *)hint hide:(CGFloat)delay debug:(BOOL)configure;
+ (void)showHint:(NSString *)hint hide:(CGFloat)delay;
+ (void)showHODAnimation:(BOOL)animated toView:(UIView *)view;
+ (void)removeHOD;



#pragma mark - NotificationPost;
+ (void)postNotificationName:(NSString *)aName object:(id)obj;
+ (void)postNotificationName:(NSString *)aName object:(id)obj userInfo:(NSDictionary *)info;


#pragma mark Agnes 数据上报 About


+ (BOOL)AgnesRegist;
+ (NSString *)getAgnesId;
/**
 上报数据接口

 @param info     上报数据包， NSDictionary
 @param widgetId NSString *widgetId
 @param eType    EventEnum 事件类型
 */
+ (void)reportInfo:(NSDictionary *)info widget:(NSString *)widgetId Evt:(EventEnum)eType;




@end
