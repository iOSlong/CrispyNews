//
//  CNNewsType.h
//  CrispyNews
//
//  Created by 陈肖坤 on 16/8/4.
//  Copyright © 2016年 陈肖坤. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CNNewsType : NSObject

typedef NS_ENUM(NSInteger, NewsType) {

    NewsTypeNoIconCell = 1,//无图
    NewsTypeBigIconCell = 2,//大图
    NewsTypeIconsCell = 3,//多图
    NewsTypeSingleCell = 4,//小图
    
};



@property (nonatomic, assign) NewsType newsType;

@end
