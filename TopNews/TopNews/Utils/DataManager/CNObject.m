//
//  CNObject.m
//  CrispyNews
//
//  Created by xuewu.long on 16/8/10.
//  Copyright © 2016年 letv. All rights reserved.
//

#import "CNObject.h"

static const NSString *keyType = @"propertyType";
static const NSString *keyName = @"propertyName";

@implementation CNObject

+ (instancetype)shareObject {
    static dispatch_once_t onceToken;
    static id thisObj = nil;
    dispatch_once(&onceToken, ^{
        thisObj = [[self alloc] init];
    });
    return thisObj;
}

- (NSString *)description {
    return [self yy_modelDescription];
}

+ (NSString *)stringForSQLFormat {
    NSArray *propertyAtt = [[self class] getAllPropertyiesWithType:YES];
    NSMutableArray *muArray = [NSMutableArray array];
    for (NSDictionary *dict in propertyAtt) {
        NSString *type = dict[keyType];
        if ([dict[keyName] isEqualToString:@"id"]) {
            continue;
        }
        NSString *sqltype = @"text";
        if ([type isEqualToString:NSStringFromClass([NSNumber class])]) {
            sqltype = @"integer";
        }else if ([type isEqualToString:NSStringFromClass([NSData class])]){
            sqltype = @"blob";
        }else if ([type isEqualToString:NSStringFromClass([NSArray class])]){
            // 注意， 数组的情况存储
            sqltype = @"text";
        }else{
            
        }
        [muArray addObject:[NSString stringWithFormat:@"%@ %@",dict[keyName], sqltype]];
    }
    NSString *sqlFormat = [muArray componentsJoinedByString:@","];
    
    return sqlFormat;
}


- (NSDictionary *)cnModelToJSONObject;{
    const void *key = (__bridge const void *)(NSStringFromClass([self class]));
    NSArray *proArr =  objc_getAssociatedObject([[self class] shareObject], key);
    if (proArr == nil) {
        proArr = [[self class] getAllPropertyiesWithType:NO];
        objc_setAssociatedObject([[self class] shareObject], key, proArr, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    NSMutableDictionary *muDict = [NSMutableDictionary dictionary];
    for (NSString *proKey in proArr) {
        id value = [self valueForKey:proKey];
        if ([value isKindOfClass:[NSData class]]) {
//            [muDict setObject:value?:[NSNull null] forKey:proKey];
        }else{
            [muDict setObject:value?:[NSNull null] forKey:proKey];
        }
    }
    return muDict;
}

- (NSData *)cnModelToJSONData;{
    NSDictionary *dict = [self cnModelToJSONObject];
    NSData *data = [NSJSONSerialization dataWithJSONObject:dict options:0 error:nil];
    [self setValue:data forKey:@"data"];
    return data;
}


+ (NSArray *)getAllPropertyiesWithType:(BOOL)typeBy {
    u_int count;
    objc_property_t *properties = class_copyPropertyList([self class], &count);
    
    NSMutableArray *propertiesArray = [NSMutableArray arrayWithCapacity:count];
    
    for (int i =0; i < count; i ++) {
        const char *proName = property_getName(properties[i]);
        NSString *nameStr = [NSString stringWithUTF8String:proName];
    
        const char *type    = getPropertyType(properties[i]);
        NSString *typeStr   = [NSString stringWithUTF8String:type];
        
        if (typeBy) {
            NSDictionary *dict = @{keyName:nameStr, keyType:typeStr};
            [propertiesArray addObject:dict];
        }else{
            [propertiesArray addObject:nameStr];
        }
    }
    free(properties);
    
    objc_setAssociatedObject([[self class] new], (__bridge const void *)(NSStringFromClass([self class])), propertiesArray, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    
    return propertiesArray;
}



//获取属性的方法
static const char *getPropertyType(objc_property_t property) {
    const char *attributes = property_getAttributes(property);
    //printf("attributes=%s\n", attributes);
    char buffer[1 + strlen(attributes)];
    strcpy(buffer, attributes);
    char *state = buffer, *attribute;
    while ((attribute = strsep(&state, ",")) != NULL) {
        if (attribute[0] == 'T' && attribute[1] != '@') {
            // it's a C primitive type:
            NSString *name = [[NSString alloc] initWithBytes:attribute + 1 length:strlen(attribute) - 1 encoding:NSASCIIStringEncoding];
            return (const char *)[name cStringUsingEncoding:NSASCIIStringEncoding];
        }
        else if (attribute[0] == 'T' && attribute[1] == '@' && strlen(attribute) == 2) {
            // it's an ObjC id type:
            return "id";
        }
        else if (attribute[0] == 'T' && attribute[1] == '@') {
            // it's another ObjC object type:
            NSString *name = [[NSString alloc] initWithBytes:attribute + 3 length:strlen(attribute) - 4 encoding:NSASCIIStringEncoding];
            return (const char *)[name cStringUsingEncoding:NSASCIIStringEncoding];
        }
    }
    return "";
}

@end
