//
//  CNDefult.m
//  CrispyNews
//
//  Created by xuewu.long on 16/9/6.
//  Copyright © 2016年 letv. All rights reserved.
//

#import "CNDefult.h"

@interface CNDefult ()

@end

@implementation CNDefult

- (instancetype)init
{
    self = [super init];
    if (self) {
        _defult = [NSUserDefaults standardUserDefaults];
    }
    return self;
}

+ (instancetype)shareDefult {
    static dispatch_once_t onceToken;
    static CNDefult *thisOBJ;
    dispatch_once(&onceToken, ^{
        thisOBJ = [[self alloc] init];
    });
    return thisOBJ;
}


#pragma mark - Default Account
+ (CNAccount *)defaultAccount {
    NSError *error = nil;
    NSString *accountFile   = [[CNUtils pathOfDatabase] stringByAppendingPathComponent:@"tempAccount"];
    NSString *accountStr    = [NSString stringWithContentsOfFile:accountFile encoding:NSUTF8StringEncoding error:&error];
    if (error == nil) {
        NSData *data = [accountStr dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
        if (error == nil) {
            CNAccount *account = [[CNAccount alloc] init];
            [account yy_modelSetWithJSON:dict];
            [CNDefult shareDefult].account       = account;
            return  account;
        }
    }
    return nil;
}

- (NSNumber *)serverMode {
    NSNumber *number = [self.defult objectForKey:USER_DEFAULT_KEY_SERVER_SETTING];
    return number;
}
- (void)setServerMode:(NSNumber *)serverMode {
    [self.defult setObject:serverMode forKey:USER_DEFAULT_KEY_SERVER_SETTING];
    [self.defult synchronize];
}

- (NSNumber *)webType {
    NSNumber *number= [self.defult objectForKey:USER_DEFAULT_KEY_WEBVIEW_TYPE];
    if (number == nil) {
        [self.defult setObject:@1 forKey:USER_DEFAULT_KEY_WEBVIEW_TYPE];
        [self.defult synchronize];
        number = @1;
    }
    return number;
}
- (void)setWebType:(NSNumber *)webType {
    [self.defult setObject:webType forKey:USER_DEFAULT_KEY_WEBVIEW_TYPE];
    [self.defult synchronize];
}


- (NSString *)deviceToken {
    return [self.defult objectForKey:USER_DEFAULT_KEY_APNS_DEVICETOKEN];
}

- (void)setDeviceToken:(NSString *)deviceToken {
    [self.defult setObject:deviceToken forKey:USER_DEFAULT_KEY_APNS_DEVICETOKEN];
    [self.defult synchronize];
}


- (NSNumber *)userState {
    return [self.defult objectForKey:USER_DEFAULT_KEY_USERSTATE];
}

- (void)setUserState:(NSNumber *)userState {
    [self.defult setObject:userState forKey:USER_DEFAULT_KEY_USERSTATE];
    [self.defult synchronize];
}

- (NSNumber *)imgShowControl {
    return [self.defult objectForKey:USER_DEFAULT_KEY_IMGSHOWCONTROL];
}
- (void)setImgShowControl:(NSNumber *)imgShowControl {
    [self.defult setObject:imgShowControl forKey:USER_DEFAULT_KEY_IMGSHOWCONTROL];
    [self.defult synchronize];
}



- (NSString *)fbToken {
    return  [self.defult objectForKey:USER_DEFAULT_KEY_FACEBOOKTOKEN];
}

- (void)setFbToken:(NSString *)fbToken {
    [self.defult setObject:fbToken forKey:USER_DEFAULT_KEY_FACEBOOKTOKEN];
    [self.defult synchronize];
}

- (void)setUid:(NSString *)uid {
    [self.defult setObject:uid forKey:USER_DEFAULT_KEY_UID];
    [self.defult synchronize];
}
- (NSString *)uid {
    NSString *uid =  [self.defult objectForKey:USER_DEFAULT_KEY_UID];
    if (uid == nil) {
        return @"";
    }
    return uid;
}

- (void)setToken:(NSString *)token {
    [self.defult setObject:token forKey:USER_DEFAULT_KEY_TOKEN];
    [self.defult synchronize];
}
- (NSString *)token {
    NSString *token = [self.defult objectForKey:USER_DEFAULT_KEY_TOKEN];
    if (token == nil) {
        return @"";
    }
    return token;
}

- (CNAccount *)account {
    NSDictionary *jsonModel = [self.defult objectForKey:USER_DEFAULT_KEY_ACCOUNT];
    if (jsonModel) {
        CNAccount *userAccount = [CNAccount new];
        [userAccount yy_modelSetWithJSON:jsonModel];
        return userAccount;
    }
    return nil;
}

- (void)setAccount:(CNAccount *)account {
    NSDictionary *jsonDict = [account yy_modelToJSONObject];
    [self.defult setObject:jsonDict forKey:USER_DEFAULT_KEY_ACCOUNT];
    [self.defult synchronize];
    self.userState    = account.status;
    self.token        = account.token;
    self.uid          = account.uid;
    
    NSDictionary *info = @{notiSenter   :NSStringFromClass([self class]),
                           notiEvent    :[NSNumber numberWithInteger:CNEventTypeNotiLoginStateChange],
                           notiBool     :[NSNumber numberWithBool:self.userState]};
    [CNUtils postNotificationName:NOTI_USERLOGINSTATE_CHANGE object:nil userInfo:info];
    
    if (account && [account.status boolValue]) {
        NSString *accountjsonStr = [account yy_modelToJSONString];
        NSString *accountFile = [[CNUtils pathOfDatabase] stringByAppendingPathComponent:@"tempAccount"];
        NSError *wError = nil;
        [accountjsonStr writeToFile:accountFile atomically:YES encoding:NSUTF8StringEncoding error:&wError];
        if (DEBUG_FLAG) {
            NSAssert(wError == nil, @"accountjsonStr write failed");
        }
    }
}


- (CNStatus)cnStatus {
    return [[self.defult objectForKey:USER_DEFAULT_KEY_CNSTATUS] integerValue];
}
- (void)setCnStatus:(CNStatus)cnStatus {
    NSNumber *status = [NSNumber numberWithInteger:cnStatus];
    [self.defult setObject:status forKey:USER_DEFAULT_KEY_CNSTATUS];
    [self.defult synchronize];
}


- (NSNumber *)locLineCollectionCount {
    return [self.defult objectForKey:USER_DEFAULT_KEY_LOCLINECOLLECTIONCOUNT];
}
- (void)setLocLineCollectionCount:(NSNumber *)locLineCollectionCount {
    [self.defult setObject:locLineCollectionCount forKey:USER_DEFAULT_KEY_LOCLINECOLLECTIONCOUNT];
    [self.defult synchronize];
}

- (void)clearDefaults {
    NSDictionary *dict = [self.defult dictionaryRepresentation];
    for (id key in dict) {
        [self.defult removeObjectForKey:key];
    }
    [self.defult synchronize];
}

- (NSNumber *)notificationsType {
    return [self.defult objectForKey:USER_CEFAULT_KEY_NOTIFICATION_TYPE];
}
- (void)setNotificationsType:(NSNumber *)notificationsType {
    [self.defult setObject:notificationsType forKey:USER_CEFAULT_KEY_NOTIFICATION_TYPE];
    [self.defult synchronize];
}


@end
