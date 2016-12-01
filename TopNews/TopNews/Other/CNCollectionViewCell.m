//
//  CNCollectionViewCell.m
//  CrispyNews
//
//  Created by xuewu.long on 16/8/22.
//  Copyright © 2016年 letv. All rights reserved.
//

#import "CNCollectionViewCell.h"

@implementation CNCollectionViewCell


- (void)showHint:(NSString *)hint hide:(CGFloat)delay {
    if (self.destViewController) {
        [self.destViewController showHint:hint hide:delay];
    }
}
- (void)showHint:(NSString *)hint hide:(CGFloat)delay enableBackgroundUserAction:(BOOL)enable{
    if (self.destViewController) {
        [self.destViewController showHint:hint hide:delay enableBackgroundUserAction:enable];
    }
}
@end
