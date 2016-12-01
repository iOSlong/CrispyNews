//
//  CNBottomView.h
//  CrispyNews
//
//  Created by xuewu.long on 16/8/23.
//  Copyright © 2016年 letv. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, CNBottomViewStyle) {
    CNBottomViewStyleNewsDetail,
    CNBottomViewStyleShare,
    CNBottomViewStyleBookMark,
    CNBottomViewStyleForSign,
    CNBottomViewStyleOther,
};

typedef NS_ENUM(NSUInteger, CNBottomEvent) {
    CNBottomEventShare,
    CNBottomEventHeart,
    CNBottomEventComment,
    CNBottomEventFieldTouch,
    
    CNBottomEventMarkAll,
    CNBottomEventMarkNone,
    CNBottomEventDelClick,
    
    CNBottomEventShareEmail     = 90,
    CNBottomEventShareMessage   = 91,
    CNBottomEventShareCopyLink  = 92,
    CNBottomEventShareWhatsapp  = 100,
    CNBottomEventShareFacebook  = 200,
    CNBottomEventShareTwitter   = 300,
    CNBottomEventShareMore      = 400,
    CNBottomEventShareCancel    = 500,
    
    CNBottomEventSinginClick,
    CNBottomEventNone,
};

@protocol CNBottomViewDelegate <NSObject>
@optional
- (BOOL)bottomFieldShouldBeginEditing;
- (void)bottomBtnClickEvent:(CNBottomEvent)event;

@end



@interface CNBottomView : UIView

@property (nonatomic, strong) UIImageView   *imgvBackground;
@property (nonatomic, strong) NSString      *commentCount;
@property (nonatomic, strong) NSString      *inputContent;
@property (nonatomic, strong) NSString      *markCount;
@property (nonatomic, assign) BOOL          markAll;
@property (nonatomic, assign) BOOL          isLiked;// 是否收藏。
@property (nonatomic, assign, readonly) CNBottomViewStyle style;
@property (nonatomic, assign) id<CNBottomViewDelegate>delegate;
@property (nonatomic, strong) UINavigationController *nav;

- (instancetype)initWithFrame:(CGRect)frame style:(CNBottomViewStyle)style;
- (instancetype)initWithStyle:(CNBottomViewStyle)style;
- (void)setHidden:(BOOL)hidden;


CGFloat heighOfInputBar();
CGFloat heighOfShareBar();


@end
