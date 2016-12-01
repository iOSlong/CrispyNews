//
//  CNAccount.h
//  TopNews
//
//  Created by 陈肖坤 on 16/10/19.
//  Copyright © 2016年 levt. All rights reserved.
//

#import "CNObject.h"

@interface CNAccount : CNObject

@property (nonatomic, strong) NSString *id;
@property (nonatomic, strong) NSString *uid;
@property (nonatomic, strong) NSString *ssouid;
@property (nonatomic, strong) NSString *token;
@property (nonatomic, strong) NSString *fbAvatar;

@property (nonatomic, strong) NSString  *success;
@property (nonatomic, strong) NSNumber  *status;
@property (nonatomic, strong) NSNumber  *age;
@property (nonatomic, strong) NSString  *email;
@property (nonatomic, strong) NSString  *gender;
@property (nonatomic, strong) NSString  *birthday;
@property (nonatomic, strong) NSString  *username;
@property (nonatomic, strong) NSString  *nickname;
@property (nonatomic, strong) NSString  *phoneNumber;

@property (nonatomic, strong) NSString  *picture;
@property (nonatomic, strong) NSString  *imgUrl;
@property (nonatomic, strong) NSArray   *headUrls;
@property (nonatomic, strong) NSNumber  *isFirst;
@property (nonatomic, strong) NSNumber  *isIdentify;
@property (nonatomic, strong) NSNumber  *smsLoginSwitch;
@property (nonatomic, strong) NSString  *registCountry;

@property (nonatomic, strong) NSString  *createTime;
@property (nonatomic, strong) NSString  *lastModifyPwdTime;
@property (nonatomic, strong) NSString  *mixCommentClose;
@property (nonatomic, strong) NSString  *mobile;
@property (nonatomic, strong) NSString  *deviceNumber;
@property (nonatomic, strong) NSString  *productId;
@property (nonatomic, strong) NSString  *regProductid;
@property (nonatomic, strong) NSString  *loginProductid;
//token的当前时间
@property (nonatomic, strong) NSDate    *createDate;



@end
