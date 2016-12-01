//
//  CNWeakDelegate.m
//  TopNews
//
//  Created by xuewu.long on 16/11/3.
//  Copyright © 2016年 levt. All rights reserved.
//

#import "CNWeakDelegate.h"

@implementation CNWeakDelegate


- (instancetype)initWithJSExportProtocalDelegate:(id<JSExportProtocolDelegate>)jsExportDelegate {
    self = [super init];
    if (self) {
        _jsExportDelegate = jsExportDelegate;
    }
    return self;
}
- (instancetype)initWithWKScriptMessageHandlerDelegate:(id<WKScriptMessageHandler>)scriptDelegate {
    self = [super init];
    if (self) {
        _scriptDelegate = scriptDelegate;
    }
    return self;
}

- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message
{
    [self.scriptDelegate userContentController:userContentController didReceiveScriptMessage:message];
}


#pragma mark -  JSExportProtocalDelegate
- (NSInteger)add:(NSInteger)a b:(NSInteger)b;{
    return [self.jsExportDelegate add:a b:b];
}
- (BOOL)jsCallExistLocalImgUrl:(NSString *)imgUrl;{
    return [self.jsExportDelegate jsCallExistLocalImgUrl:imgUrl];
}
- (NSString *)jsCallGetLocalImgByURL:(NSString *)imgUrl;{
    return [self.jsExportDelegate jsCallGetLocalImgByURL:imgUrl];
}
- (void)jsCallToRecommendDetail:(id )item;{
    [self.jsExportDelegate jsCallToRecommendDetail:item];
}
- (void)jsCallContentTap;{
    [self.jsExportDelegate jsCallContentTap];
}




@end
