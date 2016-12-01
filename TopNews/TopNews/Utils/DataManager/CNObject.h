//
//  CNObject.h
//  CrispyNews
//
//  Created by xuewu.long on 16/8/10.
//  Copyright © 2016年 letv. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <YYModel/YYModel.h>


@interface CNObject : NSObject

@property (nonatomic, strong) NSData *data;

+ (instancetype)shareObject;

+ (NSArray *)getAllPropertyiesWithType:(BOOL)typeBy;

+ (NSString *)stringForSQLFormat;

- (NSDictionary *)cnModelToJSONObject;
- (NSData *)cnModelToJSONData;




@end
