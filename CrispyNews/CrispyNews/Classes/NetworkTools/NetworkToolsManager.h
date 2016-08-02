//
//  NetworkToolsManager.h
//  我的NewsBoard
//
//  Created by mac on 16/1/2.
//  Copyright © 2016年 陈肖坤. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^ResultBlock)(id result);


@interface NetworkToolsManager : NSObject
/**
 *  这是一个get请求
 *
 *  @param urlString   urlString
 *  @param resultBlock id,可能是字典,也可能是数组
 */
+ (void)getWithURLString:(NSString *)urlString parameters:(id)parameters ResultBlock:(ResultBlock)resultBlock;

@end
