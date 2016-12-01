//
//  CNWeakDelegate.h
//  TopNews
//
//  Created by xuewu.long on 16/11/3.
//  Copyright © 2016年 levt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WebKit/WebKit.h>
#import <JavaScriptCore/JavaScriptCore.h>

@protocol JSExportProtocolDelegate <JSExport>

@optional
- (NSInteger)add:(NSInteger)a b:(NSInteger)b;
- (BOOL)jsCallExistLocalImgUrl:(NSString *)imgUrl;
- (NSString *)jsCallGetLocalImgByURL:(NSString *)imgUrl;
- (void)jsCallToRecommendDetail:(id )item;
- (void)jsCallContentTap;

@end




@interface CNWeakDelegate : NSObject <WKScriptMessageHandler, JSExportProtocolDelegate>

@property (nonatomic, weak) id<WKScriptMessageHandler> scriptDelegate;
@property (nonatomic, weak) id<JSExportProtocolDelegate> jsExportDelegate;

- (instancetype)initWithWKScriptMessageHandlerDelegate:(id<WKScriptMessageHandler>)scriptDelegate;
- (instancetype)initWithJSExportProtocalDelegate:(id<JSExportProtocolDelegate>)jsExportDelegate;



@end
