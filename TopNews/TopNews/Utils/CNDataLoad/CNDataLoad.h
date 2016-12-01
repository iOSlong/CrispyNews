//
//  CNDataLoad.h
//  TopNews
//
//  Created by xuewu.long on 16/9/26.
//  Copyright © 2016年 levt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CNDataManager.h"


typedef void(^LoadNewsProBlock)(CGFloat progress, NSError *error);


@protocol CNDataLoadDelegate <NSObject>
@optional
- (void)loadNewsProgress:(CGFloat)progress error:(NSError *)error over:(BOOL)over show:(NSString *)showStr;

@end
@interface CNDataLoad : NSObject

@property (nonatomic, strong, readonly) CNChannel *channel;
@property (nonatomic, assign, readonly) BOOL isLoading;
@property (nonatomic, assign, readonly) LoadNewsProBlock proBlock;
@property (nonatomic, assign)id <CNDataLoadDelegate> delegate;

@property (nonatomic, strong, readonly) NSArray<CNNews *> *newsArr;
@property (nonatomic, strong, readonly) NSMutableArray<CNNewsDetail *> *newsDetailArray;

+ (instancetype)shareDataLoad;
- (void)loadNewsZipFromChannel:(CNChannel *)channel;
- (void)loadCancel;

@end
