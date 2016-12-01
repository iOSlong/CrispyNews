//
//  CNChannel.m
//  CrispyNews
//
//  Created by xuewu.long on 16/8/10.
//  Copyright © 2016年 letv. All rights reserved.
//

#import "CNChannel.h"

@implementation CNChannel

- (NSString *)ID{
    if (!_ID) {
        return [NSString stringWithFormat:@"%@",_id];
    }
    return _ID;
}


@end
