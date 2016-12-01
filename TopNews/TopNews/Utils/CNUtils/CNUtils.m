//
//  CNUtils.m
//  CrispyNews
//
//  Created by xuewu.long on 16/8/26.
//  Copyright © 2016年 letv. All rights reserved.
//

#import "CNUtils.h"
#import "AppDelegate.h"
#import "MBProgressHUD.h"
#import "OpenUDID.h"
#import "CNDataManager.h"

@implementation CNUtils

#pragma mark - Overall About

#pragma mark - UIDefault About
// 设计图是基于iPhone6 的
+ (CGFloat)fontSizePreference:(CGFloat)fontSize {
    if (iPhone5 || iPhone4s) {
        return fontSize;
    }else if (iPhone6) {
        return fontSize;
    }else if (iPhone6Plus){
        return fontSize * kRATIO;
    }
    return fontSize;
}

+ (UIFont *)fontPreference:(NSString *)fontName size:(CGFloat)fontSize {
    if (fontName) {
        return [UIFont fontWithName:fontName size:[CNUtils fontSizePreference:fontSize]];
    }
    return [UIFont fontWithName:FONT_Helvetica size:[CNUtils fontSizePreference:fontSize]];
}



#pragma mark - Server About
+ (NSString *) getNewsServerHost {
    if (BUILD_MODE == 1)
    {
        return CN_NEWS_SERVER;
    }
    else if (BUILD_MODE == 0)
    {
        CNDefult *defult = [CNDefult shareDefult];

        if ([defult.serverMode integerValue] == 0)
        {
            return CN_TEST_NEWS_SERVER;
        }
        else if ([defult.serverMode integerValue]== 1)
        {
            return CN_NEWS_SERVER;
        }
        else if ([defult.serverMode integerValue] == 2)
        {
            return CN_YAJUN_TEST_NEWS_SERVER;
        }
    }
    return nil;
}

+ (NSString *)getPushServerHost {
    if (BUILD_MODE == 1) {
         return @"http://10.73.139.185:8080";//api.push.ios.le.com/reg";
    }
    return @"http://10.73.139.185:8080";//@"http://10.154.157.39/reg";
}

+ (NSString *)getShareServerHost {
    if (BUILD_MODE == 1) {
        return CN_NEWS_SERVER;
    }
    return CN_SHARE_SERVER;
}

+ (CNStatus) getStatusBarNetInfo;{
    UIApplication *app = [UIApplication sharedApplication];
    NSArray *children = [[[app valueForKeyPath:@"statusBar"]valueForKeyPath:@"foregroundView"]subviews];
    NSString *state = [[NSString alloc]init];
    CNStatus status = CNStatusNetReachableNone;
    int netType = 0;
    for (id child in children) {
        if ([child isKindOfClass:NSClassFromString(@"UIStatusBarDataNetworkItemView")]) {
            netType = [[child valueForKeyPath:@"dataNetworkType"]intValue];
            switch (netType) {
                case 0:{
                    state = @"无网络";
                    status = CNStatusNetReachableNone;
                }
                    break;
                case 1:{
                    state =  @"2G";
                    status = CNStatusNetReachable2G;
                }
                    break;
                case 2:{
                    state =  @"3G";
                    status = CNStatusNetReachable3G;
                }
                    break;
                case 3:{
                    state =   @"4G";
                    status = CNStatusNetReachable4G;
                }
                    break;
                case 5:{
                    state =  @"wifi";
                    status = CNStatusNetReachableWifi;
                }
                    break;
                default:
                    break;
            }
        }
    }
    return status;
}



//ip 106.38.180.188
#pragma mark - Device About
+ (NSString *)getDeviceUIID {
    return [[OpenUDID value] stringByRemovingPercentEncoding];
}

+ (NSString *)myRandomUUID {
    CFUUIDRef newUniqueID = CFUUIDCreate(kCFAllocatorDefault);
    CFStringRef newUniqueIDString = CFUUIDCreateString(kCFAllocatorDefault, newUniqueID);
    NSString *guid = (__bridge NSString *)newUniqueIDString;
    CFRelease(newUniqueIDString);
    CFRelease(newUniqueID);
    return([guid lowercaseString]);
}

+ (NSMutableDictionary *)getKeychainQuery:(NSString *)service {
    return [NSMutableDictionary dictionaryWithObjectsAndKeys:
            (__bridge_transfer id)kSecClassGenericPassword,(__bridge_transfer id)kSecClass,
            service, (__bridge_transfer id)kSecAttrService,
            service, (__bridge_transfer id)kSecAttrAccount,
            (__bridge_transfer id)kSecAttrAccessibleAfterFirstUnlock,(__bridge_transfer id)kSecAttrAccessible,
            nil];
}

+ (void)save:(NSString *)service data:(id)data {
    //Get search dictionary
    NSMutableDictionary *keychainQuery = [self getKeychainQuery:service];
    //Delete old item before add new item
    SecItemDelete((__bridge_retained CFDictionaryRef)keychainQuery);
    //Add new object to search dictionary(Attention:the data format)
    [keychainQuery setObject:[NSKeyedArchiver archivedDataWithRootObject:data] forKey:(__bridge_transfer id)kSecValueData];
    //Add item to keychain with the search dictionary
    SecItemAdd((__bridge_retained CFDictionaryRef)keychainQuery, NULL);
}

+ (id)load:(NSString *)service {
    id ret = nil;
    NSMutableDictionary *keychainQuery = [self getKeychainQuery:service];
    //Configure the search setting
    [keychainQuery setObject:(id)kCFBooleanTrue forKey:(__bridge_transfer id)kSecReturnData];
    [keychainQuery setObject:(__bridge_transfer id)kSecMatchLimitOne forKey:(__bridge_transfer id)kSecMatchLimit];
    CFDataRef keyData = NULL;
    if (SecItemCopyMatching((__bridge_retained CFDictionaryRef)keychainQuery, (CFTypeRef *)&keyData) == noErr) {
        @try {
            ret = [NSKeyedUnarchiver unarchiveObjectWithData:(__bridge_transfer NSData *)keyData];
        } @catch (NSException *e) {
            NSLog(@"Unarchive of %@ failed: %@", service, e);
        } @finally {
        }
    }
    return ret;
}

+ (void)delete:(NSString *)service {
    NSMutableDictionary *keychainQuery = [self getKeychainQuery:service];
    SecItemDelete((__bridge_retained CFDictionaryRef)keychainQuery);
}

+(void)saveUUID:(NSString *)uuid{
    if (uuid && uuid.length > 0) {
        [CNUtils save:KEY_IN_KEYCHAIN data:uuid];
    }
}


+(NSString *)getUUID{
    //先获取keychain里面的UUID字段，看是否存在
    NSString *uuid = (NSString *)[CNUtils load:KEY_IN_KEYCHAIN];
    
    //如果不存在则为首次获取UUID，所以获取保存。
    if (!uuid || uuid.length == 0) {
        CFUUIDRef puuid = CFUUIDCreate( nil );
        
        CFStringRef uuidString = CFUUIDCreateString( nil, puuid );
        
        uuid = [NSString stringWithFormat:@"%@", uuidString];
        
        [self saveUUID:uuid];
        
        CFRelease(puuid);
        
        CFRelease(uuidString);
    }
    
    return uuid;
}


+(void)deleteUUID{
    [CNUtils delete:KEY_IN_KEYCHAIN];
}


+ (BOOL)isAppRunInBackground
{
    UIApplicationState state = [[UIApplication sharedApplication] applicationState];
    return ((state == UIApplicationStateBackground) || (state == UIApplicationStateInactive));
}

+ (BOOL)isAppRunInForeground
{
    if (![NSThread isMainThread]) {
        NSLog(@"not main thread");
    }
    UIApplicationState state = [[UIApplication sharedApplication] applicationState];
    return (state == UIApplicationStateActive);
}



#pragma mark - File Directory About
// 数据库路径
+ (NSString *)pathOfDatabase;{
    static NSString *dbPath = nil;
    if (dbPath == nil) {
        dbPath = [[CNDataManager shareDataController] pathOfDatabase];
    }
    return dbPath;
}

// 下载文件夹路径
+ (NSString *)pathOfNameSpace;{
    static NSString *dfPath = nil;
    if(dfPath == nil){
        dfPath = [[CNDataManager shareDataController] pathOfNameSpace];
    }
    return dfPath;
}

+ (NSString *)pathOfNewsDetail;{
    static NSString *ndPath = nil;
    if(ndPath == nil){
        ndPath = [[CNDataManager shareDataController] pathOfNewsDetail];
    }
    return ndPath;
}
+ (NSString *)pathOfImageList;{
    static NSString *imgPath = nil;
    if(imgPath == nil){
        imgPath = [[CNDataManager shareDataController] pathOfDiskCache];
    }
    return imgPath;
}

+ (NSString *)pathOfNetCache;{
    static NSString *netCachePath = nil;
    if (netCachePath == nil) {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
        NSString *bundleIdentifier = [[NSBundle mainBundle] bundleIdentifier];
        netCachePath = [paths[0] stringByAppendingPathComponent:bundleIdentifier];
    }
    return netCachePath;
}


+ (NSArray <NSString *> *)allFilePathInDirectory:(NSString *)dirPath isDir:(BOOL)isDir {
    return [CNUtils allInDirectory:dirPath isDirectory:isDir fullPath:YES];
}
+ (NSArray <NSString *> *)allFileInDirectory:(NSString *)dirPath isDir:(BOOL)isDir {
    return [CNUtils allInDirectory:dirPath isDirectory:isDir fullPath:NO];
}
+ (NSArray <NSString *> *)allInDirectory:(NSString *)dirPath isDirectory:(BOOL)isDir fullPath:(BOOL)isPath{
    NSMutableArray* array = [NSMutableArray array];
    NSFileManager* fileMgr = [NSFileManager defaultManager];
    NSArray* tempArray = [fileMgr contentsOfDirectoryAtPath:dirPath error:nil];
    for (NSString* fileName in tempArray) {
        BOOL flag = YES;
        NSString* fullPath = [dirPath stringByAppendingPathComponent:fileName];
        if ([fileMgr fileExistsAtPath:fullPath isDirectory:&flag]) {
            if (isPath) {
                if (flag && isDir) {
                    [array addObject:fullPath];
                }else if (!flag && !isDir){
                    [array addObject:fullPath];
                }
            }else{
                if (flag && isDir) {
                    [array addObject:fileName];
                }else if (!flag && !isDir){
                    [array addObject:fileName];
                }
            }
        }
    }
    return array;
}


+ (BOOL)file:(NSString *)file existsAtDirectory:(NSString *)desDir;
{
    NSFileManager *fileMgr = [NSFileManager defaultManager];
    BOOL existFlag = [fileMgr fileExistsAtPath:[desDir stringByAppendingPathComponent:file]];
    return existFlag;
}

+ (BOOL)cnImgurlFilecodeInPath:(NSString *)dirPath;
{
    NSFileManager* fileMgr      = [NSFileManager defaultManager];
    NSArray *dirArr = [fileMgr contentsOfDirectoryAtPath:dirPath error:nil];
    for (NSString *fileName in dirArr)
    {
        NSString *fullPath  = [dirPath stringByAppendingPathComponent:fileName];
        NSString *newPath   = dirPath;
        if ([fullPath CNISImagePath])
        {
            NSString *imgCaheName = [NSString cachedFileNameForKey:[fileName URLDecoded]];
            newPath = [dirPath stringByAppendingPathComponent:imgCaheName];
            NSError *error;
            if([fileMgr moveItemAtPath:fullPath toPath:newPath error:&error] == YES){
                [fileMgr removeItemAtPath:fullPath error:&error];
                NSLog(@"%@",error);
            }
        }
    }
    return YES;
}

+ (BOOL)filesMoveDir:(NSString *)dirPath toDir:(NSString *)desDir
{
    NSFileManager* fileMgr = [NSFileManager defaultManager];
    BOOL flag = YES;
    if ([fileMgr fileExistsAtPath:desDir isDirectory:&flag] == NO ||[fileMgr fileExistsAtPath:dirPath isDirectory:&flag] == NO ) {
        return NO;
    }
    dispatch_async(dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0), ^{
        NSArray *dirArr = [fileMgr contentsOfDirectoryAtPath:dirPath error:nil];
        for (NSString *fileName in dirArr) {
            NSString *fullPath  = [dirPath stringByAppendingPathComponent:fileName];
            NSString *newPath   = [desDir stringByAppendingPathComponent:fileName];
            if ([fileMgr fileExistsAtPath:newPath]){
                [fileMgr removeItemAtPath:newPath error:nil];
            }
            NSError *error;
            if([fileMgr moveItemAtPath:fullPath toPath:newPath error:&error] == NO){
                NSLog(@"%@",error);
            }
        }
        NSError *error;
        [fileMgr removeItemAtPath:dirPath error:&error];
//        return YES;
    });
    return YES;
}

+ (id)jsonFromPath:(NSString *)dirPath jsonName:(NSString *)jsonName{
    id jsonObj = nil;
    BOOL flag = YES;
    if ([[NSFileManager defaultManager] fileExistsAtPath:dirPath isDirectory:&flag]) {
        NSString *jsonPath = [dirPath stringByAppendingPathComponent:jsonName];
        if ([[NSFileManager defaultManager] fileExistsAtPath:jsonPath]) {
            NSData *jsonData = [NSData dataWithContentsOfFile:jsonPath];
            NSError *error = nil;
            jsonObj = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:&error];
        }
    }
    return jsonObj;
}

+ (NSData *)dataFromPath:(NSString *)filePath{
    BOOL flag = YES;
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath isDirectory:&flag]) {
        if (flag == NO) {
            NSData *data = [NSData dataWithContentsOfFile:filePath];
            return data;
        }
    }
    return nil;
}

+ (BOOL)isExistCacheImgListOfURL:(NSString *)imgurl;{
    NSString *decodeURL = [NSString cachedFileNameForKey:imgurl];
    if([CNUtils file:decodeURL existsAtDirectory:[CNUtils pathOfImageList]]){
        return YES;
    }
    return NO;
}
+ (void)file:(NSString *)filePath size:(void(^)(NSString *fileSize))sizeBlock;{
    [filePath fileSize:^(NSString *size) {
        if (sizeBlock) {
            sizeBlock(size);
        }
    }];
}
+ (void)fileCNIMGClear;{
    NSFileManager *fm = [NSFileManager defaultManager];
    NSString *imgList   = [CNUtils pathOfImageList];
    NSString *h5Path    = [CNUtils pathOfNewsDetail];
    NSString *netCache  = [CNUtils pathOfNetCache];
    [fm removeItemAtPath:imgList error:nil];
    [fm removeItemAtPath:h5Path error:nil];
    [fm removeItemAtPath:netCache error:nil];
}

#pragma mark - Time About
/*
 GMT 就是格林威治标准时间的英文缩写(Greenwich Mean Time 格林尼治标准时间),是世界标准时间. gmt+8 是格林威治时间+8小时。中国所在时区就是gmt+8 
 */

+ (NSDateFormatter *)shareUSESTDateFormatter
{
    static NSDateFormatter *formatter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        formatter = [[NSDateFormatter alloc] init];
        [formatter setTimeStyle:NSDateFormatterNoStyle];
        [formatter setDateStyle:NSDateFormatterMediumStyle];
        NSLocale *usLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
        [formatter setLocale:usLocale];
        [formatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"EST"]];
    });
    return formatter;
}

+ (NSDateFormatter *)shareCNDateFormatter
{
    static NSDateFormatter *formatter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        formatter = [[NSDateFormatter alloc] init];
        [formatter setTimeStyle:NSDateFormatterNoStyle];
        [formatter setDateStyle:NSDateFormatterMediumStyle];
        NSLocale *cnLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
        [formatter setLocale:cnLocale];
    });
    return formatter;
}

+ (NSString *)longToNSDateCNFormat:(long long)time format:(NSString *)formaterString
{
    const long long dateTimeLong = time / 1000;
    NSDate *dateTime = [[NSDate alloc] initWithTimeIntervalSince1970:dateTimeLong];
    NSDateFormatter *formatter = [CNUtils shareCNDateFormatter];
    [formatter setDateFormat:formaterString];
    NSString *dateString = [formatter stringFromDate:dateTime];
    return dateString;
}

+ (NSString *)longToNSDateFormat:(long long)time format:(NSString *)formaterString
{
    const long long dateTimeLong = time / 1000;
    NSDate *dateTime = [[NSDate alloc] initWithTimeIntervalSince1970:dateTimeLong];
    NSDateFormatter *formatter = [CNUtils shareUSESTDateFormatter];
    [formatter setDateFormat:formaterString];
    NSString *dateString = [formatter stringFromDate:dateTime];
    return dateString;
}

+ (NSString *)newsTimeFormat:(long long)timestamp {
//    NSString *timeF =  [CNUtils longToNSDateCNFormat:timestamp format:@"dd/MM HH:mm zzz"];
//    return timeF;
//    NSDate *dateJudge = [[NSDate alloc] initWithTimeIntervalSince1970:timestamp/1000];
    NSDate *date = [NSDate date];
    
    NSTimeInterval offset = [date timeIntervalSince1970] * 1000;
    NSTimeInterval timerSpan = offset - timestamp;
    if (timerSpan < 60 * 60 * 1000)// 1min < x < 1h
    {
        int ago = timerSpan / (60 * 1000);
        if (ago <= 0) {
//            return [NSString stringWithFormat:@"%d s",(int)(offset - timestamp) / 1000];
            return @"";
        }else if (ago < 60 * 1000){
            return @"1min";
        }else{
            
            return [NSString stringWithFormat:@"%d mins",ago];
        }

    }
    else if (timerSpan < 60 * 60 * 1000 * 12)// 1h < x < 12h
    {
        int ago = timerSpan / (60 * 60 * 1000);
        return [NSString stringWithFormat:@"%d hrs",ago];
    }
    else if (timerSpan < 60 * 60 * 1000 * 30 * 24.0)// 12hrs < x < 30days
    {
        return [CNUtils longToNSDateCNFormat:timestamp format:@"dd/MM "];
    }else{
        return @"";
    }
#if 0
    else
    {
        NSCalendar *cal = [NSCalendar currentCalendar];
        NSDateComponents *componentsJudge = [cal components:(NSCalendarUnitEra|NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay) fromDate:dateJudge];
        NSDateComponents *componentsNow = [cal components:(NSCalendarUnitEra|NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay) fromDate:date];
        
        if (componentsJudge.day == componentsNow.day && componentsNow.month == componentsJudge.month)
        {
//            return [NSString stringWithFormat:@"今天 %@",[CNUtils longToNSDateCNFormat:timestamp format:@"HH:mm"]];
            return [NSString stringWithFormat:@"%ld hrs",componentsNow.hour - componentsJudge.hour];
        }
        else if (componentsNow.year == componentsJudge.year)
        {
//            return [NSString stringWithFormat:@"%@",[CNUtils longToNSDateCNFormat:timestamp format:@"MM-dd HH:mm"]];
//            NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
//            NSDateComponents    * comp = [calendar components:(NSCalendarUnitEra|NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour) fromDate:dateJudge toDate:date options:NSCalendarWrapComponents];
            
//            return [NSString stringWithFormat:@"%ld d", comp.day + comp.hour/12];
            
            return [CNUtils longToNSDateFormat:timestamp format:@"dd/MM hh:mm"];
            
        }
        else{
//            return [CNUtils longToNSDateCNFormat:timestamp format:@"yy-MM-dd zzz"];
            return [CNUtils longToNSDateCNFormat:timestamp format:@"yy-MM-dd zzz"];
        }
    }
#endif
}
    
#pragma mark - postShow flip pall
+ (void)showHODAnimation:(BOOL)animated toView:(UIView *)view;{
    __block UIView *desView = view;
    __block BOOL blockEnableBackgroundInteraction = NO;
    dispatch_async(dispatch_get_main_queue(), ^{
        if (nil == desView) {
            desView = [UIApplication sharedApplication].keyWindow;
        }
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:desView animated:animated];
        hud.userInteractionEnabled = blockEnableBackgroundInteraction;
    });
}
+ (void)removeHOD;
{
    [[UIApplication sharedApplication].keyWindow removeSubViewClass:[MBProgressHUD class]];
}
    
+ (void)showHint:(NSString *)hint hide:(CGFloat)delay debug:(BOOL)configure;
{
    if (configure && DEBUG_FLAG) {
        [CNUtils showHint:hint hide:delay];
    }
}

+ (void)showHint:(NSString *)hint hide:(CGFloat)delay {
    __block NSString *hintBlock = hint;
    __block BOOL blockEnableBackgroundInteraction = YES;
    dispatch_async(dispatch_get_main_queue(), ^{
        //TBLog(@"show hint loading");
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
        // 如果允许操作下面的view, 需要禁用 mb 本身的userInteraction.
        hud.userInteractionEnabled = !blockEnableBackgroundInteraction;
        [hud.detailsLabel setFont:[UIFont systemFontOfSize:15 * kRATIO]];
        [hud setRemoveFromSuperViewOnHide:YES];
        [hud setMode:MBProgressHUDModeText];
        [hud.detailsLabel setText:hintBlock];
        [hud hideAnimated:YES afterDelay:delay];
    });
}

#pragma mark - NotificationPost;
+ (void)postNotificationName:(NSString *)aName object:(id)obj userInfo:(NSDictionary *)info {
    if ([NSThread isMainThread]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:aName object:obj userInfo:info];
    }else{
        __block NSString *nameBlock = aName;
        __block id objBlock = obj;
        __block NSDictionary *userInfo = info;
        dispatch_async(dispatch_get_main_queue(), ^{
            [[NSNotificationCenter defaultCenter] postNotificationName:nameBlock object:objBlock userInfo:userInfo];
        });
    }
}

+ (void)postNotificationName:(NSString *)aName object:(id)obj {
    [CNUtils postNotificationName:aName object:obj userInfo:nil];
}


#pragma mark Agnes 数据上报 About
+ (BOOL)AgnesRegist;{
    if (!globleAgnes) {
        NSString *currentShortVersionString = [NSBundle mainBundle].infoDictionary[@"CFBundleShortVersionString"];
        
        Agnes *agnes = [Agnes sharedAgnes:IN enableLog:YES];
        [agnes setRegion:@"IN"];
        [agnes setAppKeyWithStr:@"TopNews-iOS" andVersion:currentShortVersionString];
        globleApp   = [globleAgnes getAppwithStr:@"TopNews-iOS"];
        
        AGS_App *app = [agnes getAppwithStr:@"TopNews-iOS"];
        
        globleAgnes = agnes;
        globleApp   = app;
        
        
        [agnes reportApp:app];
    }
    if (globleAgnes && globleApp) {
        return YES;
    }
    return NO;
}
+ (NSString *)getAgnesId {
    if ([CNUtils AgnesRegist]) {
        return [globleAgnes getStartId];
    }
    return nil;
}

+ (void)reportInfo:(NSDictionary *)info widget:(NSString *)widgetId Evt:(EventEnum)eType;
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([CNUtils AgnesRegist]) {
            // 生成上报事件类型 report
            AGS_Event *event   = [globleApp createEventwithEnum:eType];
            [globleAgnes reportEvt:event];
            
            // 生成上报信息包， report
            AGS_Widget *widget   = [globleApp createWidget:widgetId];
            if ([[CNDefult shareDefult].userState integerValue] == 1) {
                [widget addPropwithStr:@"uid" propVal:[CNDefult shareDefult].uid];
            }
            [widget addPropwithStr:@"lc" propVal:[CNUtils getDeviceUIID]];
            [info enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
                [widget addPropwithStr:key propVal:obj];
            }];
            if ([CNDefult shareDefult].cnStatus) {
                [widget addPropwithStr:@"net_type" propVal:[NSString stringWithFormat:@"%ld",[CNDefult shareDefult].cnStatus]];
            }
            [globleAgnes reportWgt:widget];
            
        }
    });
}





@end
