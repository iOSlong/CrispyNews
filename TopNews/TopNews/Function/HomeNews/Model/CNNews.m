//
//  CNNewsModel.m
//  CrispyNews
//
//  Created by xuewu.long on 16/8/10.
//  Copyright © 2016年 letv. All rights reserved.
//

#import "CNNews.h"

@implementation CNNews

- (NSString *)ID{
    return [NSString stringWithFormat:@"%@",_id];
}

- (void)setID:(NSString *)ID {
    self.id = ID;
}

- (NSString *)recSource {
    if (_recSource) {
        return _recSource;
    }
    return @"";
}

- (NSString *)recId {
    if (_recId) {
        return _recId;
    }
    return @"";
}

- (CNNews *)newsCopy {
    CNNews *news = [CNNews new];
    id jsonObj = [self yy_modelToJSONObject];
    [news yy_modelSetWithJSON:jsonObj];
    return news;
}

@end
