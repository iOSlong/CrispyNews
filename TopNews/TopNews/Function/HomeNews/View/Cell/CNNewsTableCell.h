//
//  CNNewsTableCell.h
//  CrispyNews
//
//  Created by xuewu.long on 16/8/19.
//  Copyright © 2016年 letv. All rights reserved.
//

#import "CNTableViewCell.h"
#import "CNNews.h"
#import "CNCellBar.h"
#import "CNImageView.h"
/// 声明一个单例，辅助计算cell高度。
@interface CNCellCaculate : NSObject
+ (instancetype)shareCellCaculate;
@property (nonatomic, strong) UILabel *label;
@end





typedef NS_ENUM(NSUInteger, CNNewsCellType) {
    CNNewsCellTypeImgvNone  = 0,
    CNNewsCellTypeImgvFull  = 1,
    CNNewsCellTypeImgvSideR = 2,
    CNNewsCellTypeImgvParts = 3
};

typedef NS_ENUM(NSUInteger, CNNewsCellState) {
    CNNewsCellStateNormal,
    CNNewsCellStateEditing,
    CNNewsCellStateOther,
};

typedef NS_ENUM(NSUInteger, CNNewsCellEvent) {
    CNNewsCellEventMark,
    CNNewsCellEventMarkNess,
    CNNewsCellEventClick,
    CNNewsCellEventLongPress,
    CNNewsCellEventNone
};

//图片类型 0 无图,1: 大图,2: 一张小图,3,三张小图

static NSString *cellIDImgvFull         = @"CNNewsCellTypeImgvFull";
static NSString *cellIDImgvSideR        = @"CNNewsCellTypeImgvSideR";
static NSString *cellIDImgvParts        = @"CNNewsCellTypeImgvParts";
static NSString *cellIDImgvNone         = @"CNNewsCellTypeImgvNone";


@protocol CNNewsTableCellDelegate <NSObject>
@optional
- (void)cellNews:(CNNews *)news event:(CNNewsCellEvent)event info:(NSDictionary *)info ;


@end

@interface CNNewsTableCell : CNTableViewCell
@property (nonatomic, strong) UIView        *viewBase;
@property (nonatomic, strong) UIButton      *btnCheck;
@property (nonatomic, strong) UILabel       *labelTitle;
@property (nonatomic, strong) CNImageView   *imgvFull;
@property (nonatomic, strong) CNImageView   *imgvSideR;
@property (nonatomic, strong) NSArray<CNImageView *>       *imgvArray;
@property (nonatomic, strong) CNCellBar     *cellBar;

@property (nonatomic, assign, readonly) CNNewsCellType type;
@property (nonatomic, strong) CNNews *news;
@property (nonatomic, assign) id <CNNewsTableCellDelegate>delegate;
@property (nonatomic, assign) CNNewsCellState cellState;
@property (nonatomic, assign) BOOL marked;
@property (nonatomic, strong) NSIndexPath *showIndexPath;
- (instancetype)initWithStyle:(CNNewsCellType)type reuseIdentifier:(NSString *)reuseIdentifier;

+ (CGFloat)cellHeightWithModel:(CNNews *)news;


@end



//@property NSString *author;
//@property NSString *content;
//@property NSString *createTime;
//@property NSString *desc;
//@property NSString *id;
//@property NSString *ID;
//@property NSString *imgType;
////图片类型 0 无图,1: 大图,2: 一张小图,3,三张小图
//@property NSArray  *imgUrls;
//@property NSString *publishTime;
//@property NSString *source;
//@property NSString *title;
//@property NSString *url;
