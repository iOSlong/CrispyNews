//
//  NetworkTools.m
//  我的NewsBoard
//
//  Created by mac on 16/1/2.
//  Copyright © 2016年 陈肖坤. All rights reserved.
//

#import "NetworkTools.h"

static NSString *const BASEURLString = @"";

@implementation NetworkTools

+ (instancetype)sharedNetworkTools {
    static NetworkTools *_networkTools;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _networkTools = [[self alloc]initWithBaseURL:[NSURL URLWithString:BASEURLString]];
        _networkTools.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];

    });
    
    return _networkTools;
}


@end
