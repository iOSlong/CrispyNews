//
//  CNBezierView.h
//  TopNews
//
//  Created by xuewu.long on 16/9/27.
//  Copyright © 2016年 levt. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, CNBezierViewType) {
    CNBezierViewTypeProgressItem,
    CNBezierViewTypeNone,
};

@interface CNBezierView : UIView
@property (nonatomic, assign) CGFloat progress;
@property (nonatomic, assign, readonly)CNBezierViewType Type;
- (instancetype)initWithFrame:(CGRect)frame andType:(CNBezierViewType)type;



@end
