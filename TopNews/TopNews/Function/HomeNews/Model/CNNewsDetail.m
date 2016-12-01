//
//  CNNewsDetail.m
//  TopNews
//
//  Created by xuewu.long on 16/9/28.
//  Copyright © 2016年 levt. All rights reserved.
//

#import "CNNewsDetail.h"

@implementation CNNewsDetail


- (NSString *)ID{
    return [NSString stringWithFormat:@"%@",_id];
}

- (void)setID:(NSString *)ID {
    self.id = ID;
}

@end
