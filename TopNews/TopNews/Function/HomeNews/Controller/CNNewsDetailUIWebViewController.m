//
//  CNNewsDetailUIWebViewController.m
//  TopNews
//
//  Created by xuewu.long on 16/10/9.
//  Copyright © 2016年 levt. All rights reserved.
//

#import "CNNewsDetailUIWebViewController.h"
#import "JSMessageInputView.h"
#import "CNDefult.h"
#import "CNBottomView.h"
#import "CNDataManager.h"
#import "AppDelegate.h"
#import "CNFavouriteViewController.h"
#import <JavaScriptCore/JavaScriptCore.h>

#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKShareKit/FBSDKShareKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <TwitterKit/TwitterKit.h>
#import "CNImageView+CN.h"
#import "NSString+CN.h"
#import "CNImgDownloader.h"
#import "CNProgressView.h"
#import "CNFeedbackViewController.h"

@interface UIWebView (JavaScriptAlert)

- (void)webView:(UIWebView *)sender runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(CGRect *)frame;

@end


@implementation UIWebView (JavaScriptAlert)

- (void)webView:(UIWebView *)sender runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(CGRect *)frame {
    
    
    UIAlertView* customAlert = [[UIAlertView alloc] initWithTitle:@"提示信息" message:message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    
    [customAlert show];
}

@end

typedef NS_ENUM(NSUInteger, CNDetailCommentType) {
    CNDetailCommentTypeNews,
    CNDetailCommentTypeComnent,
    CNDetailCommentTypeOther,
};

@interface CNNewsDetailUIWebViewController ()<JSMessageInputViewDelegate,UITextFieldDelegate,CNBottomViewDelegate,FBSDKSharingDelegate,UIWebViewDelegate,UIScrollViewDelegate,MFMessageComposeViewControllerDelegate>

@property (nonatomic, strong) UIWebView             *webView;
@property (nonatomic, strong) JSContext             *jsContext;

@property (nonatomic, strong) CNProgressView        *progressView;
@property (nonatomic, strong) JSMessageInputView    *messageInputView;
@property (nonatomic, strong) CNBottomView          *inPutBottomView;
@property (nonatomic, strong) CNBottomView          *shareBottomView;
@property (nonatomic, strong) CNBottomView          *signInBottomView;
@property (nonatomic, strong) NSMutableArray        *recommends;
@property (nonatomic, strong) NSMutableArray        *comments;

@property (nonatomic, assign) CNFrom                from;
@property (nonatomic, assign) CNDetailCommentType   commentType;
@property (nonatomic, copy) NSDictionary            *dictComment;

@end


@implementation CNNewsDetailUIWebViewController{
    BOOL _freshWebContent;
}


#pragma mark -
- (void)setNewsFrom:(NSString *)newsFrom {
    _newsFrom = newsFrom;
    if ([_newsFrom isEqualToString:NSStringFromClass([CNFavouriteViewController class])]) {
        self.from = CNFromFavesListVC;
    }else if ([_newsFrom isEqualToString:NSStringFromClass([CNHomeNewsViewController class])]){
        self.from = CNFromHomeListVC;
    }else if ([_newsFrom isEqualToString:NSStringFromClass([AppDelegate class])]){
        self.from = CNFromPushNoti;
    }else{
        self.from = CNFromOtherOri;
    }
}
- (CNProgressView *)progressView{
    if (!_progressView) {
        _progressView = [[CNProgressView alloc] initWithFrame:CGRectMake(0, 64, SCREENW, 2)];
    }
    return _progressView;
}

- (UIWebView *)webView {
    if (!_webView) {
        _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, SCREENW, self.view.height - heighOfInputBar())];
        _webView.opaque = YES;
        _webView.delegate = self;
        _webView.scalesPageToFit = YES;
        _webView.backgroundColor = [UIColor clearColor];
        _webView.scrollView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag; // 当拖动时移除键盘
        _webView.scrollView.delegate = self;
    }
    return _webView;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    NSLog(@"______");
}

#pragma mark - UIWebView Delegate
- (void)webViewDidStartLoad:(UIWebView *)webView {
    NSLog(@"");
}
- (void)adjustWebViewCachePolicy{
    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"WebKitCacheModelPreferenceKey"];
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"WebKitDiskImageCacheEnabled"];//自己添加的，原文没有提到。
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"WebKitOfflineWebApplicationCacheEnabled"];//自己添加的，原文没有提到。
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
//    [self adjustWebViewCachePolicy];

    //    取消长按webView上的链接弹出actionSheet的问题
    [webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitTouchCallout = 'none';"];
    weakSelf();
    //    如果h5页面存在js给定的分享设置内容，则优先使用H5页面中的内容
    self.jsContext = [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    self.jsContext.exceptionHandler =
    ^(JSContext *context, JSValue *exceptionValue)
    {
        context.exception = exceptionValue;
        NSLog(@"%@", exceptionValue);
    };
    
//
    
    CNStatus cstatus    = [CNDefult shareDefult].cnStatus;
//    cstatus = CNStatusNetReachable2G;
    BOOL imgShowControl = [[CNDefult shareDefult].imgShowControl boolValue];
    self.jsContext[@"jsCallImgList"] = ^(BOOL flog) {
        NSArray *args = [JSContext currentArguments];
        for (JSValue *obj in args) {
            if (obj.isString) {
                NSString *decodeURL = [NSString cachedFileNameForKey:[obj toString]];
                NSLog(@"decodeUrl = %@",decodeURL);
                if([CNUtils file:decodeURL existsAtDirectory:[CNUtils pathOfNewsDetail]]){
                    return YES;
                }
            }
        }
        // 判断图片张氏规则，如果是在不需要张氏图片的情况下，这个地方也要返回yes， 然后返回一张默认的图片样式。
        NSLog(@"%ld",cstatus);
        if (cstatus&(CNStatusNetReachable2G|CNStatusNetReachableNone)){
            NSLog(@"imgshowState: 2G | Nonne");
            return YES;
        }else if (cstatus&(CNStatusNetReachable3G|CNStatusNetReachable4G)){
            NSLog(@"imgshowState: 3G | 4G");
            if (imgShowControl) {
                return YES;
            }
        }
        return NO;
    };
//
    self.jsContext[@"jsGetImgFromLocal"] = ^(NSString *imgName) {
        NSArray *args = [JSContext currentArguments];
        for (JSValue *obj in args) {
            if (obj.isString) {
                NSString *decodeURL = [NSString cachedFileNameForKey:[obj toString]];
                NSLog(@"decodeUrl = %@",decodeURL);
                if([CNUtils file:decodeURL existsAtDirectory:[CNUtils pathOfNewsDetail]]){
                    return decodeURL;
                }
            }
        }
        if (cstatus&(CNStatusNetReachable3G|CNStatusNetReachable4G)){
            NSLog(@"imgshowState: 3G | 4G");
            if (imgShowControl) {
                return DEV_PLACEHOLDERIMG;
            }else{
                return imgName;
            }
        }else if(cstatus & CNStatusNetReachableWifi){
            return imgName;
        }
        return DEV_PLACEHOLDERIMG;
    };
    
    self.jsContext[@"jsCallToRecommendDetail"] = ^(){
        NSArray *args = [JSContext currentArguments];
        for (JSValue *objNews in args) {
            CNNews *news = [CNNews new];
            [news yy_modelSetWithJSON:objNews.toObject];
            if (news.ID) {
                // TODO 重新清理掉 原有的推荐 和 评论。
                _news = news;
                [weakSelf reloadWebViewContentsForRefresh:NO];
            }
        }
    };
    
    self.jsContext[@"jsCallContentTap"] = ^() {
        if (weakSelf.messageInputView.textView.isFirstResponder) {
            [weakSelf.messageInputView resignFirstResponder];
        }
    };
    
    self.jsContext[@"jsCallGetComments"] = ^(){
        [weakSelf netGetComments];
    };
    self.jsContext[@"jsCallCommentTap"] = ^(){
        NSArray *args = [JSContext currentArguments];
        for (JSValue *objNews in args) {
            NSDictionary *comment = objNews.toDictionary;
            weakSelf.dictComment = [comment copy];
            if ([weakSelf judgeLoginState]) {
                weakSelf.commentType = CNDetailCommentTypeComnent;
                [weakSelf.messageInputView.textView becomeFirstResponder];
            }
            NSLog(@"%@",comment);
        }
    };
    
    self.jsContext[@"jsCallDetailLoadOver"] = ^(){
        NSLog(@"load OVer!");
        // 监听详情页面加载完毕之后才能进行评论和推荐的刷新工作。
        if (weakSelf.recommends.count == 0) {
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                [weakSelf netGetRecommends];
            });
        }
        if (weakSelf.comments.count == 0) {
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                [weakSelf netGetComments];
            });
        }
        if (_freshWebContent == YES) {
            
        }else{
            weakSelf.progressView.progress = 0.8;
        }
    };
    if (_freshWebContent == YES) {
        
    }else{
        self.progressView.progress = 0.02;
    }
    [self loadDetailFromNews:self.news];
}

-(void)loadDetailFromNews:(CNNews *)news {
    //     判断本地数据库是否存在数据
    CNNewsDetail *cacheDetail = [[CNDataManager shareDataController] getNewsDetailById:news.ID type:CNDBTableTypeNewsDetail];
    if (cacheDetail) {
        [self loadFromDetail:cacheDetail toStore:YES];
    }else{
        [self netGetWebNewsdetail:news];
    }
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    NSLog(@"%@",error);
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    NSString * loadingUrl = [request.URL absoluteString];
    
    if (navigationType == UIWebViewNavigationTypeFormSubmitted) {
        NSLog(@"navigation from submitted webview should start load with request url show: %@", loadingUrl);
        return YES;
    }
    if ([request valueForHTTPHeaderField:AUTHORIZATION_KEY]) {
        NSLog(@"_request has http header field authorization.");
        return YES;
    }
    NSLog(@"%@",loadingUrl);
    return YES;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSLog(@"");
}


#pragma mark - InputView + JSMessageInputView
- (CNBottomView *)inPutBottomView {
    if (!_inPutBottomView) {
        _inPutBottomView = [[CNBottomView alloc] initWithFrame:CGRectMake(0, self.view.height - heighOfInputBar(),SCREENW, heighOfInputBar()) style:CNBottomViewStyleNewsDetail];
        _inPutBottomView.commentCount = @"0";
        _inPutBottomView.delegate = self;
    }
    return _inPutBottomView;
}


- (JSMessageInputView *)messageInputView {
    if (!_messageInputView) {
        _messageInputView = [[JSMessageInputView alloc] initWithFrame:CGRectMake(0, self.view.height, SCREENW,[JSMessageInputView defaultHeight]) delegate:self];
        _messageInputView.maxLength = 200;
        
    }
    return _messageInputView;
}

#pragma mark - ShareView  + SignInView
- (CNBottomView *)shareBottomView {
    if (!_shareBottomView) {
        _shareBottomView = [[CNBottomView alloc] initWithStyle:CNBottomViewStyleShare];
        _shareBottomView.delegate = self;
        //        _shareBottomView.nav = self.navigationController;
    }
    return _shareBottomView;
}

- (CNBottomView *)signInBottomView {
    if (!_signInBottomView) {
        _signInBottomView = [[CNBottomView alloc] initWithStyle:CNBottomViewStyleForSign];
        _signInBottomView.delegate = self;
    }
    return _signInBottomView;
}

#pragma mark JSMessageInputViewDelegate
- (void)viewheightChanged:(float)height {
    //    _messageInputView.height = height;
}

#pragma mark 添加评论
- (void)textViewEnterSend {
    [self netSetComment:self.messageInputView.textView.text];
}

- (BOOL)judgeLoginState {
    if ([[CNDefult shareDefult].userState integerValue] == 0) {
        [self.signInBottomView setHidden:NO];
        return NO;
    }
    return YES;
}



#pragma mark - BottomViewDelegate
- (void)bottomBtnClickEvent:(CNBottomEvent)event {
    if (_newsDetail ) {
        
    }else{
        return;
    }
    if (event == CNBottomEventComment)
    {
        // TODO， 进行滚动效果
        [self scrollTopWithComment:NO];
    }
    else if (event == CNBottomEventShare)
    {
        [self.shareBottomView setHidden:NO];
    }
    else if (event == CNBottomEventHeart)
    {
#pragma mark 收藏/取消收藏
        // TODO 判断是否登录
        if (self.inPutBottomView.isLiked == NO) {
            [self netSetCollectionState:YES];
            [CNUtils reportInfo:nil widget:WIDGET_DETAIL_FAVES_CLICK Evt:evt_click];
            
        }else{
            [self netSetCollectionState:NO];
            [CNUtils reportInfo:nil widget:WIDGET_DETAIL_FAVES_CANCEL Evt:evt_click];
        }
    }else if (event == CNBottomEventShareWhatsapp) {
        self.shareBottomView.hidden = YES;
        [self shareWhatsapp];
        NSDictionary *info = @{@"vid"   :_news.ID,
                               @"cid"   :self.channelName,
                               @"url"   :_news.url,
                               @"eid"   :[CNUtils myRandomUUID],
                               };
        [CNUtils reportInfo:info widget:WIDGET_DETAIL_SHARES_WHATSAPP Evt:evt_click];

    }else if (event == CNBottomEventShareFacebook){
        self.shareBottomView.hidden = YES;
        [self shareFacebook];
        NSDictionary *info = @{@"vid"   :_news.ID,
                               @"cid"   :self.channelName,
                               @"url"   :_news.url,
                               @"eid"   :[CNUtils myRandomUUID],
                               };
        [CNUtils reportInfo:info widget:WIDGET_DETAIL_SHARES_FACEBOOK Evt:evt_click];

    }else if (event == CNBottomEventShareTwitter){
        self.shareBottomView.hidden = YES;
        [self shareTwitter];
        NSDictionary *info = @{@"vid"   :_news.ID,
                               @"cid"   :self.channelName,
                               @"url"   :_news.url,
                               @"eid"   :[CNUtils myRandomUUID],
                               };
        [CNUtils reportInfo:info widget:WIDGET_DETAIL_SHARES_TWITTER Evt:evt_click];
    }else if (event == CNBottomEventShareEmail){
        self.shareBottomView.hidden = YES;
        [self shareEmail];
    }else if (event == CNBottomEventShareMessage){
        self.shareBottomView.hidden = YES;
        [self shareMessage];
    }else if (event == CNBottomEventShareCopyLink){
        self.shareBottomView.hidden = YES;
        [UIPasteboard generalPasteboard].string = [NSString stringWithFormat:@"\nTilte : %@\nUrl : %@",
                                                   _news.title,
                                                   [CNApiManager apiNewsShareDetailId:_news.ID]
                                                   ];
        [CNUtils showHint:@"Link copied" hide:TIMER_HIDE_DELAY];
    }else if (event == CNBottomEventShareCancel){
        self.shareBottomView.hidden = YES;
    }else if (event == CNBottomEventSinginClick) {
        NSDictionary *info = @{notiSenter:NSStringFromClass([self class]),
                               notiEvent: [NSNumber numberWithInteger:CNEventTypeNotiLoginNeed]};
        [CNUtils postNotificationName:NOTI_NEEDLOGIN_POST object:nil userInfo:info];
    }else{
        [CNUtils showHint:[NSString stringWithFormat:@"%ld",event] hide:TIMER_HIDE_DELAY];
    }
}

- (BOOL)bottomFieldShouldBeginEditing {
    if ([self judgeLoginState]) {
        self.commentType = CNDetailCommentTypeNews;
        [self scrollTopWithComment:YES];
        [self.messageInputView.textView becomeFirstResponder];
    }
    return NO;
}


- (void)detailBlock:(DetailBlock)thisBlock {
    self.dBlock = thisBlock;
}


/**
 刷新界面

 @param refresh 是否为加载别个的新闻，如果是原有新闻刷新refresh=yes，如果是加载新的新闻refresh=no。
 */
- (void)reloadWebViewContentsForRefresh:(BOOL)refresh {
    _freshWebContent = refresh;
    NSString *detailUrl = [CNApiManager apiNewsDetailWithChannel:_news.ID];
    NSURL *localHtmlURL = [NSURL URLWithString:detailUrl];
    //    localHtmlURL =  [[NSBundle mainBundle] URLForResource:@"imgtest" withExtension:@"html"];
    localHtmlURL =  [[NSBundle mainBundle] URLForResource:DEV_MODELH5 withExtension:@"html"];
    
    
    NSString *htmlString = [NSString stringWithContentsOfURL:localHtmlURL encoding:NSUTF8StringEncoding error:nil];
    
    
    
    NSURL *sourceUrl = [NSURL fileURLWithPath:[CNUtils pathOfNewsDetail]];
    
    //    sourceUrl = [NSURL fileURLWithPath:[[NSBundle mainBundle] bundlePath]];
    //    NSString *cachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask , YES) lastObject];
    //    sourceUrl = [NSURL fileURLWithPath:cachePath];
    
    if (_recommends==nil)   self.recommends = [NSMutableArray array];
    if (_comments==nil)     self.comments   = [NSMutableArray array];
    if (refresh == NO) {
        [self.recommends removeAllObjects];
        [self.comments removeAllObjects];
    }
    [self.webView loadHTMLString:htmlString baseURL:sourceUrl];
}

- (void)configureNavigation {
    CNBarButtonItem *rItem = [[CNBarButtonItem alloc] barButtomItem:@"reload"];
    [rItem barBlock:^(CNBarButtonItem *barBItem) {
        
    }];
//    self.navigationItem.rightBarButtonItem = rItem;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    [self configureNavigation];
    
    /// 0. 添加通知
    [self configureNotifications];
    
    

    /// 1. 添加WKWebView 控件
    [self.view addSubview:self.webView];
    
    [self.view addSubview:self.progressView];

    
    /// 2. 添加下发的输入控件
    [self.view addSubview:self.messageInputView];
    [self.view addSubview:self.inPutBottomView];
    
    
    
    // 更新新闻离别数据阅读状态
    if (_news) {
        _news.readState = @1;
        if ([_news.locCollected integerValue] || [_news.hasCollected integerValue]) {
            [[CNDataManager shareDataController] insertNews:_news channel:_channelName type:CNDBTableTypeNewsFaves];
        }
        [[CNDataManager shareDataController] insertNews:_news channel:_channelName type:CNDBTableTypeNewsChannel];
    }
    
    
    
    [self reloadWebViewContentsForRefresh:NO];
    
    // 下载处理缓存文件
    CNImageView *shareImgv = [[CNImageView alloc] init];
    [shareImgv cn_setImageWithURL:[NSURL URLWithString:[_news.imgUrls firstObject]] placeholderImage:[UIImage imageNamed:@"cover1"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        self.imgShare= image;
    }];
    
    
    NSDictionary *info;
    if ([self.newsFrom isEqualToString:NSStringFromClass([CNHomeNewsViewController class])] || [self.newsFrom isEqualToString:NSStringFromClass([CNFavouriteViewController class])]) {
        info = @{@"vid"   :_news.ID,
                 @"cid"   :self.channelName,
                 @"url"   :_news.url,
                 @"eid"   :[CNUtils myRandomUUID],
                 };
        [CNUtils reportInfo:info widget:WIDGET_DETAIL_EXPOSE Evt:evt_expose];
    }
    else
    {
        [CNUtils reportInfo:info widget:WIDGET_DETAIL_FROM_RECOMMEND Evt:evt_click];
    }
}



#pragma mark - JS Began Comment
- (void)scrollTopWithComment:(BOOL)comment {
    NSString *scrollJS=@"commentTop()";//准备执行的js代码
    if (comment) {
        scrollJS = @"commentTop('comments')";
    }else{
        scrollJS=@"commentTop()";
    }
    if (self.jsContext) {
        [self.jsContext evaluateScript:scrollJS];
    }
}






#pragma mark - Notification and NotiMethods
- (void)configureNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleWillShowKeyboard:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleWillHideKeyboard:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(eventWithNoti:) name:NOTI_USERLOGINSTATE_CHANGE object:nil];

}
- (void)eventWithNoti:(NSNotification *)noti {
    NSLog(@"%@",[noti.userInfo objectForKey:notiSenter]);
    NSInteger cnEvent = [[noti.userInfo objectForKey:notiEvent] integerValue];
    if (cnEvent == CNEventTypeNotiLoginStateChange) {
        BOOL status = [[noti.userInfo objectForKey:notiBool] boolValue];
        if (status) {
            NSLog(@"into TestSign_In status");
            [self.messageInputView.textView becomeFirstResponder];
        }else{
            NSLog(@"into TestSign_Out Status");
        }
    }
}


- (void)handleWillShowKeyboard:(NSNotification *)notification {
    CGRect keyboardRect;
    keyboardRect = [(notification.userInfo)[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    keyboardRect = [self.view convertRect:keyboardRect fromView:nil];
    weakSelf();
    if (self.messageInputView.textView.isFirstResponder) {
        //什么都没有显示
        [UIView animateWithDuration:0.25 animations:^{
            [weakSelf.messageInputView setFrame:CGRectMake(0, keyboardRect.origin.y - weakSelf.messageInputView.height, weakSelf.view.width, weakSelf.messageInputView.height)];
        }];
    }
}
- (void)handleWillHideKeyboard:(NSNotification *)notification
{
    CGRect keyboardRect;
    keyboardRect = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    keyboardRect = [self.view convertRect:keyboardRect fromView:nil];
    [self p_hideBottomComponent];
}

- (void)p_hideBottomComponent
{
    [self.messageInputView.textView resignFirstResponder];
    self.inPutBottomView.inputContent   = self.messageInputView.textView.text;
    weakSelf();
    [UIView animateWithDuration:0.25 animations:^{
        weakSelf.messageInputView.frame = CGRectMake(0,SCREENH,SCREENW,weakSelf.messageInputView.height);
    }];
    NSLog(@"%f",self.inputView.frame.origin.y);
    //    [self setValue:@(self.inputView.frame.origin.y) forKeyPath:@"_inputViewY"];
}

- (void)updateDetail:(CNNewsDetail *)detail withFreshUI:(BOOL)needFresh {
    [[CNDataManager shareDataController] insertNewsDetail:_newsDetail type:CNDBTableTypeNewsDetail];
    if (needFresh) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([[CNDefult shareDefult].userState boolValue])
            {
                if ([detail.hasCollected boolValue] || [detail.locCollected boolValue]) {
                    self.inPutBottomView.isLiked = YES;
                }else {
                    self.inPutBottomView.isLiked = NO;
                }
            }
            else{
                if ([detail.locCollected boolValue]) {
                    self.inPutBottomView.isLiked = YES;
                }else{
                    self.inPutBottomView.isLiked = NO;
                }
            }
        });
    }
}

- (void)updateNews:(CNNews *)news type:(CNDBTableType)tableType{
    [[CNDataManager shareDataController] insertNews:news channel:self.channelName type:tableType];
}


#pragma mark 刷新详情
- (void)loadFromDetail:(CNNewsDetail *)detail toStore:(BOOL)store {
    self.newsDetail = detail;
    
    if (detail.imgContextMap) {
        // 如果本地没有图片，就执行图片下载任务。
        weakSelf();
        [detail.imgContextMap enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            NSArray *imgArr = obj;
            for (NSString *imgUrl in imgArr) {
                NSLog(@"%@",imgUrl);
                NSString *decodeURL = [NSString cachedFileNameForKey:imgUrl];
                NSLog(@"decodeUrl = %@",decodeURL);
                if(![CNUtils file:decodeURL existsAtDirectory:[CNUtils pathOfNewsDetail]]){
                    [CNImgDownloader downLoadFromUrl:[NSURL URLWithString:imgUrl] completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
                        if (image && error == nil) {
                            // TODO 这种刷新方式会导致，界面出现重载，用户体验会比较糟糕。
                            // 处理方法， 使用两套下载方式，如果网络好使的情况下，使用webView 原生的方法进行图片下载展示，缓存图片则使用现有的下载图片方式。
//                            [weakSelf reloadWebViewContentsForRefresh:YES];
                        }
                    }];
                }
            }
        }];
    }
    weakSelf();
    dispatch_async(dispatch_get_main_queue(), ^{
        
        NSString *jsonString = [[NSString alloc] initWithData:detail.data encoding:NSUTF8StringEncoding];
        jsonString = [jsonString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];  //去除掉首尾的空白字符和换行字符
        
        NSString  *setDetailJS = [NSString stringWithFormat:@"setDetail(%@, 1, %d)", jsonString,[[CNDefult shareDefult].imgShowControl intValue]];
        [weakSelf.webView stringByEvaluatingJavaScriptFromString:setDetailJS];
//        if (self.jsContext) {
//            [self.jsContext evaluateScript:setDetailJS];
//        }
    });
   
    
    if (store){
        [self updateDetail:detail withFreshUI:YES];
    }
}

#pragma mark 刷新推荐
- (void)loadFromRecommend:(id)recommends {
    NSData  *dataComments = [NSJSONSerialization dataWithJSONObject:recommends options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonString = [[NSString alloc] initWithData:dataComments encoding:NSUTF8StringEncoding];
    jsonString = [jsonString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];  //去除掉首尾的空白字符和换行字符
    NSString *setRecommendJS = [NSString stringWithFormat:@"setRecommend(%@)",jsonString];
    
    
    [self.webView stringByEvaluatingJavaScriptFromString:setRecommendJS];
    // ??? 调用下面的方法，导致界面卡顿的概率实在是太大了太大了  ，卡顿 ？？？
//    dispatch_async(dispatch_get_main_queue(), ^{
//        if (self.jsContext) {
//            [self.jsContext evaluateScript:setRecommendJS];
//        }
//    });
}

#pragma mark 刷新评论

/**
 * 刷新评论列表
 *
 * @param comments id 推荐Json对象
 */
- (void)loadFromComments:(id)comments subComment:(BOOL)subCom{
    NSData  *dataComments = [NSJSONSerialization dataWithJSONObject:comments options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonString = [[NSString alloc] initWithData:dataComments encoding:NSUTF8StringEncoding];
    jsonString = [jsonString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];  //去除掉首尾的空白字符和换行字符
    __block NSString *setCommentsJS = [NSString stringWithFormat:@"setComments(%@)",jsonString];
    if (comments==nil || [comments count]== 0) {
        setCommentsJS = @"setComments()";
    }
    if (subCom) {
        setCommentsJS = [NSString stringWithFormat:@"setComment(%@)",jsonString];
        if (comments==nil ) {
            setCommentsJS = @"setComment()";
        }
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.webView stringByEvaluatingJavaScriptFromString:setCommentsJS];
        self.inPutBottomView.commentCount = [self.comments count]?[NSString stringWithFormat:@"%ld",[self.comments count]] : @"";
    });
}


#pragma mark - NetWork

- (void)netGetWebNewsdetail:(CNNews *)news {
    if (nil == news) {
        return;
    }
    CNDataManager *_DM = [CNDataManager shareDataController];
    weakSelf();
    NSString *urlJ = [CNApiManager apiNewsJsonDetail:news.ID];
    NSMutableDictionary *muDict = [NSMutableDictionary dictionary];
    [muDict setObject:[CNUtils myRandomUUID] forKey:@"eid"];
    [muDict setObject:[CNDefult shareDefult].uid?:@"" forKey:@"uid"];
    [muDict setObject:news.recId forKey:@"rec_id"];
    [muDict setObject:news.recSource forKey:@"rec_source"];
    //    NSOperationQueue
    // 获取Html newsJsonDetail
    [[CNHttpRequest shareHttpRequest] GET:urlJ parameters:muDict success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        CNNetInfo *netInfo = [[CNNetInfo alloc]init];
        [netInfo yy_modelSetWithJSON:responseObject];
        id result = [responseObject objectForKey:@"result"];
        if (netInfo.success && result && result !=[NSNull null])
        {
            NSMutableDictionary *resultDict = [[NSMutableDictionary alloc] initWithDictionary:result];
            if (resultDict) {
                CNNewsDetail *newsdetail = [CNNewsDetail new];
                [newsdetail yy_modelSetWithJSON:resultDict];
                
                NSData  *resultData = [NSJSONSerialization dataWithJSONObject:resultDict options:NSJSONWritingPrettyPrinted error:nil];
                newsdetail.result = resultData;
                newsdetail.locCollected = @0;
                [_DM updateDetails:@[newsdetail] type:CNDBTableTypeNewsDetail];
                
                
                [weakSelf loadFromDetail:newsdetail toStore:YES];
            }
        }
        else
        {
            NSError *error = [[NSError alloc] initWithDomain:@"LoadDown" code:320 userInfo:@{@"netInfo":netInfo}];
            NSLog(@"%@",error);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (error.userInfo) {
            NSData *errorData = [error.userInfo objectForKey:@"com.alamofire.serialization.response.error.data"];
            if (errorData) {
                NSString *dataStr = [[NSString alloc] initWithData:errorData encoding:NSUTF8StringEncoding];
                [weakSelf showHint:dataStr hide:TIMER_HIDE_DELAY debug:YES];
            }else{
                if (error.localizedDescription) {
                    [weakSelf showHint:error.localizedDescription hide:TIMER_HIDE_DELAY debug:YES];
                }
            }
        }else{
            [weakSelf showHint:error.description hide:TIMER_HIDE_DELAY debug:YES];
        }
    }];
}


- (void)netGetRecommends {
    NSString *recommendsAPi = [CNApiManager apiDetailGetRecommendsByNewsId:_news.ID];
    NSDictionary *param = @{@"limit" : @""};
    weakSelf();
    [[CNHttpRequest shareHttpRequest] POST:recommendsAPi parameters:param success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        weakSelf.progressView.progress = 1;
        CNNetInfo *netInfo = [[CNNetInfo alloc]init];
        [netInfo yy_modelSetWithJSON:responseObject];
        id result = [responseObject objectForKey:@"result"];
        if (netInfo.success && result && result != [NSNull null])
        {
            if ([result count]) {
                [weakSelf.recommends removeAllObjects];
                [weakSelf.recommends addObjectsFromArray:result];
            }
            [weakSelf loadFromRecommend:result];
        }else{
            [weakSelf showHint:netInfo.errorMsg hide:TIMER_HIDE_DELAY];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        weakSelf.progressView.progress = 1;
        if (error.userInfo) {
            NSData *errorData = [error.userInfo objectForKey:@"com.alamofire.serialization.response.error.data"];
            NSString *dataStr = [[NSString alloc] initWithData:errorData encoding:NSUTF8StringEncoding];
            if (dataStr == nil || dataStr.length == 0) {
                dataStr = error.localizedDescription;
            }
            [weakSelf showHint:dataStr hide:TIMER_HIDE_DELAY debug:YES];
        }else{
            [weakSelf showHint:error.description hide:TIMER_HIDE_DELAY debug:YES];
        }
    }];
}

- (void)netGetComments{
    NSString *commentsAPi = [CNApiManager apiDetailGetCommentsByNewsId:_news.ID];
    NSDictionary *comment = [self.comments firstObject];
    NSDictionary *param = @{@"cursor" :comment ? [comment objectForKey:@"commentId"] : @0};
    weakSelf();
    [[CNHttpRequest shareHttpRequest] POST:commentsAPi parameters:param success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        CNNetInfo *netInfo = [[CNNetInfo alloc]init];
        [netInfo yy_modelSetWithJSON:responseObject];
        id result = [responseObject objectForKey:@"result"];
        if (netInfo.success && result && result != [NSNull null])
        {
            NSArray *comments = [result objectForKey:@"comments"];
            for (int i = 0; i < comments.count; i ++) {
                NSDictionary *comment = comments[i];
                [weakSelf.comments addObject:comment];
            }
            [weakSelf loadFromComments:comments subComment:NO];
        }else{
            [weakSelf showHint:netInfo.errorMsg hide:TIMER_HIDE_DELAY];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (error.userInfo) {
            NSData *errorData = [error.userInfo objectForKey:@"com.alamofire.serialization.response.error.data"];
            NSString *dataStr = [[NSString alloc] initWithData:errorData encoding:NSUTF8StringEncoding];
            [weakSelf showHint:dataStr hide:TIMER_HIDE_DELAY debug:YES];
        }else{
            [weakSelf showHint:error.description hide:TIMER_HIDE_DELAY debug:YES];
        }
    }];
}

- (void)netSetComment:(NSString *)comments {
    if (!TextValid(comments) || !TextValid(_news.ID)) {
        return;
    }
    NSString *commentsApi = [CNApiManager apiDetailCommentsByNewsId:_news.ID];
    NSDictionary *param = @{@"text" : comments};
    if (self.commentType == CNDetailCommentTypeComnent) {
        param = @{@"text" : comments,
                  @"toCommentId" :[self.dictComment objectForKey:@"commentId"]};
    }
    weakSelf();
    [CNUtils showHODAnimation:YES toView:self.view];
    [[CNHttpRequest shareHttpRequest] POST:commentsApi parameters:param success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        [CNUtils removeHOD];
        
        CNNetInfo *netInfo = [[CNNetInfo alloc]init];
        [netInfo yy_modelSetWithJSON:responseObject];
        if (netInfo.success)
        {
            [weakSelf.messageInputView.textView resignFirstResponder];
            weakSelf.messageInputView.textView.text = nil;
            weakSelf.inPutBottomView.inputContent   = nil;
            [weakSelf showHint:MSG_DETAIL_COMMENT_SUCCESS hide:TIMER_HIDE_DELAY];
            
            NSDictionary *subComment = [responseObject objectForKey:@"result"];
            [weakSelf.comments insertObject:subComment atIndex:0];
            [weakSelf loadFromComments:subComment subComment:YES];
            
        }else{
            [weakSelf showHint:netInfo.errorMsg hide:TIMER_HIDE_DELAY];
        }
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        [CNUtils removeHOD];
        if (error.userInfo) {
            NSData *errorData = [error.userInfo objectForKey:@"com.alamofire.serialization.response.error.data"];
            NSString *dataStr = [[NSString alloc] initWithData:errorData encoding:NSUTF8StringEncoding];
            [weakSelf showHint:dataStr hide:TIMER_HIDE_DELAY debug:YES];
        }else{
            [weakSelf showHint:error.description hide:TIMER_HIDE_DELAY debug:YES];
        }
    }];
}

- (void)netSetCollectionState:(BOOL)isCollect {
    if (!TextValid(_news.ID)) {
        return;
    }
    // 用户未登录的情况下
    if ([[CNDefult shareDefult].userState integerValue] == 0) {
        if (isCollect) {
            [self showHint:MSG_DETAIL_MARK_SUCCESS hide:TIMER_HIDE_DELAY];
            self.newsDetail.locCollected = @1;
            self.news.locCollected = @1;
            NSTimeInterval coltimer = [[NSDate date] timeIntervalSince1970] * 1000;
            self.news.collectTime = [NSNumber numberWithDouble:coltimer];
            if (self.from == CNFromHomeListVC)
            {
                CNNews *copyNews    = [_news newsCopy];
                copyNews.readState  = @0;
                copyNews.timerLoc   = [NSNumber numberWithDouble:coltimer];
                [self updateNews:copyNews type:CNDBTableTypeNewsFaves];
                [self updateNews:_news type:CNDBTableTypeNewsChannel];
            }
            else if(self.from == CNFromFavesListVC)
            {
                [[CNDataManager shareDataController] insertNews:_news channel:self.channelName type:CNDBTableTypeNewsFaves];
            }
        }else{
            [self showHint:MSG_DETAIL_DISMARK_SUCCESS hide:TIMER_HIDE_DELAY];
            self.newsDetail.locCollected = @0;
            self.news.locCollected = @0;
            [[CNDataManager shareDataController] deleteNews:_news type:CNDBTableTypeNewsFaves];
            [self updateNews:_news type:CNDBTableTypeNewsChannel];
        }
        [self updateDetail:_newsDetail withFreshUI:YES];
    }
    else
    {
        [CNUtils showHODAnimation:YES toView:self.view];
        NSString *collectionApi = [CNApiManager apiDetailCollection:isCollect byNewsId:_news.ID];
        weakSelf();
        if (isCollect) {
            [[CNHttpRequest shareHttpRequest] GET:collectionApi parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                [CNUtils removeHOD];
                
                CNNetInfo *netInfo = [[CNNetInfo alloc]init];
                [netInfo yy_modelSetWithJSON:responseObject];
                if (netInfo.success)
                {
                    NSTimeInterval coltimer = [[NSDate date] timeIntervalSince1970] * 1000;
                    [weakSelf showHint:MSG_DETAIL_MARK_SUCCESS hide:TIMER_HIDE_DELAY];
                    weakSelf.newsDetail.hasCollected    = @1;
                    weakSelf.news.hasCollected          = @1;
                    
                    if (weakSelf.from == CNFromHomeListVC)
                    {
                        CNNews *copyNews    = [_news newsCopy];
                        copyNews.readState  = @0;
                        copyNews.timerLoc   = [NSNumber numberWithDouble:coltimer];
                        [weakSelf updateNews:copyNews type:CNDBTableTypeNewsFaves];
                        [weakSelf updateNews:_news type:CNDBTableTypeNewsChannel];
                    }
                    else if(weakSelf.from == CNFromFavesListVC)
                    {
                        [weakSelf updateNews:_news type:CNDBTableTypeNewsFaves];
                    }
                    
                    [weakSelf updateDetail:weakSelf.newsDetail withFreshUI:YES];
                    
                }else{
                    [weakSelf showHint:netInfo.errorMsg hide:TIMER_HIDE_DELAY];
                }
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                [CNUtils removeHOD];
                if (error.userInfo) {
                    NSString *errMsg = [error.userInfo objectForKey:@"NSLocalizedDescription"];
                    if (errMsg) {
                        [weakSelf showHint:errMsg hide:TIMER_HIDE_DELAY debug:YES];
                    }
                }
            }];
        }
        else
        {
            NSDictionary *param = @{@"newsId" : _news.ID};
            [[CNHttpRequest shareHttpRequest] POST:collectionApi parameters:param success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
                [CNUtils removeHOD];
                CNNetInfo *netInfo = [[CNNetInfo alloc]init];
                [netInfo yy_modelSetWithJSON:responseObject];
                if (netInfo.success)
                {
                    [weakSelf showHint:@"Bookmark removed" hide:TIMER_HIDE_DELAY];
                    weakSelf.newsDetail.hasCollected    = @0;
                    weakSelf.news.hasCollected          = @0;
                    
                    [[CNDataManager shareDataController] deleteNews:_news type:CNDBTableTypeNewsFaves];
                    [weakSelf updateNews:_news type:CNDBTableTypeNewsChannel];
                    
                    [weakSelf updateDetail:_newsDetail withFreshUI:YES];

                }else{
                    [weakSelf showHint:netInfo.errorMsg hide:TIMER_HIDE_DELAY];
                }
            } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
                [CNUtils removeHOD];
                NSData *errorData = [error.userInfo objectForKey:@"com.alamofire.serialization.response.error.data"];
                NSString *dataStr = [[NSString alloc] initWithData:errorData encoding:NSUTF8StringEncoding];
                [weakSelf showHint:dataStr hide:TIMER_HIDE_DELAY debug:YES];
                if (error.userInfo) {
                    NSString *errMsg = [error.userInfo objectForKey:@"NSLocalizedDescription"];
                    if (errMsg) {
                        [weakSelf showHint:errMsg hide:TIMER_HIDE_DELAY debug:YES];
                    }
                }
            }];
        }
    }
}


- (void) shareWhatsapp {
    NSString *str = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL,(CFStringRef)[CNApiManager apiNewsShareDetailId:_news.ID], NULL,CFSTR("!*'();:@&=+$,/?%#[]"),kCFStringEncodingUTF8));
    NSURL *whatsappURL = [NSURL URLWithString:[NSString stringWithFormat:@"whatsapp://send?text=%@",str]];
    
    if ([[UIApplication sharedApplication] canOpenURL: whatsappURL]) {
        [[UIApplication sharedApplication] openURL: whatsappURL];
    }
}

- (void) shareFacebook {
    FBSDKShareLinkContent *content = [[FBSDKShareLinkContent alloc] init];
    content.contentURL = [NSURL URLWithString:[CNApiManager apiNewsShareDetailId:_news.ID]];
    content.imageURL = [NSURL URLWithString:_news.imgUrls.firstObject];
    content.contentTitle = _news.title;
    
    //        NSLog(@"+++++++++%@",content);
    FBSDKShareDialog *dialog = [[FBSDKShareDialog alloc] init];
    dialog.fromViewController = self;
    dialog.mode = FBSDKShareDialogModeWeb;
    [dialog show];
    dialog = [FBSDKShareDialog showFromViewController:self
                                          withContent:content
                                             delegate:self];
}
- (void)sharer:(id<FBSDKSharing>)sharer didFailWithError:(NSError *)error {
    NSLog(@"");
    [self showHint:@"Failed" hide:TIMER_HIDE_DELAY];
}
- (void)sharer:(id<FBSDKSharing>)sharer didCompleteWithResults:(NSDictionary *)results {
    //    NSLog(@"%@",[sharer.shareContent description]);
    if ([results allKeys].count == 0) {
        //        [self showHint:@"Cancel" hide:2];
    }else {
        [self showHint:@"Shared" hide:TIMER_HIDE_DELAY];
    }
}
- (void)sharerDidCancel:(id<FBSDKSharing>)sharer {
    NSLog(@"");
    //    [self showHint:@"Cancel" hide:2];
}

- (void) shareTwitter {
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter]) {
        SLComposeViewController *mySocialComposeView = [[SLComposeViewController alloc] init];
        mySocialComposeView = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
        TWTRComposer *composer = [[TWTRComposer alloc] init];
        NSString *string = _news.title;
        if (string.length < 92) {
            [composer setText:string];
        }else {
            [composer setText:[string substringToIndex:91]];
        }
        [composer setURL:[NSURL URLWithString:[CNApiManager apiNewsShareDetailId:_news.ID]]];
        [composer setImage:self.imgShare];
        [composer showFromViewController:self completion:^(TWTRComposerResult result) {
            if (result == TWTRComposerResultCancelled) {
                [self showHint:@"Cancel" hide:TIMER_HIDE_DELAY];
            }
            else {
                [self showHint:@"Shared" hide:TIMER_HIDE_DELAY];
            }
        }];
        
    } else {
        //初始化提示框；
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"No Twitter Accounts" message:@"There are no Twitter accounts configured.You can add or create a Twitter account in Settings." preferredStyle:  UIAlertControllerStyleAlert];
        
        [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            //点击按钮的响应事件；
        }]];
        //弹出提示框；
        [self presentViewController:alert animated:true completion:nil];
    }
}

- (void) shareEmail {
    if ([MFMailComposeViewController canSendMail]) {
        CNFeedbackViewController *controller = [[CNFeedbackViewController alloc] init];
         NSArray *arr = @[];
        [controller setToRecipients:arr];
        [controller setSubject:_news.title];
        [controller setMessageBody:[NSString stringWithFormat:@"\nTilte : %@\nUrl : %@",
                                    _news.title,
                                    [CNApiManager apiNewsShareDetailId:_news.ID]
                                    ] isHTML:NO];
        controller.mailComposeDelegate = controller;
        [self presentViewController:controller animated:YES completion:^{
            
        }];
    } else {
        //不可发送
        if ([UIAlertController class]) {
            UIAlertController *alert= [UIAlertController alertControllerWithTitle:CTFBLocalizedString(@"Error")
                                                                          message:CTFBLocalizedString(@"Mail no configuration")
                                                                   preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *dismiss = [UIAlertAction actionWithTitle:CTFBLocalizedString(@"Dismiss")
                                                              style:UIAlertActionStyleCancel
                                                            handler:^(UIAlertAction *action) {
                                                                [alert dismissViewControllerAnimated:YES completion:nil];
                                                            }];
            [alert addAction:dismiss];
            [self presentViewController:alert animated:YES completion:nil];
        } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:CTFBLocalizedString(@"Error")
                                                            message:CTFBLocalizedString(@"Mail no configuration")
                                                           delegate:nil
                                                  cancelButtonTitle:CTFBLocalizedString(@"Dismiss")
                                                  otherButtonTitles:nil];
            [alert show];
        }
    }
}

- (void) shareMessage {
    if (![MFMessageComposeViewController canSendText]) {
//        [CNUtils showHint:@"您的设备不支持短信操作" hide:TIMER_HIDE_DELAY];
        return;
    }
    MFMessageComposeViewController *sendMessageController = [[MFMessageComposeViewController alloc] init];
    sendMessageController.messageComposeDelegate = self;
    sendMessageController.body = [NSString stringWithFormat:@"Tilte : %@\nUrl : %@",
                                  _news.title,
                                  [CNApiManager apiNewsShareDetailId:_news.ID]
                                  ];
    [self presentViewController:sendMessageController animated:YES completion:^{
    }];
}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result {
    switch (result) {
        case MessageComposeResultCancelled:
            [self dismissViewControllerAnimated:YES completion:nil];
//            [CNUtils showHint:@"取消" hide: TIMER_HIDE_DELAY];
            break;
            
        case MessageComposeResultFailed:
            [self dismissViewControllerAnimated:YES completion:nil];
//            [CNUtils showHint:@"失败" hide:TIMER_HIDE_DELAY];
            break;
            
        case MessageComposeResultSent:
            [self dismissViewControllerAnimated:YES completion:nil];
//            [CNUtils showHint:@"发送" hide:TIMER_HIDE_DELAY];
            break;
            
        default:
            break;
    }
}


/* 释放  dealloc 等处理
 // * 使用self.mywkView, 导致dealloc函数没有调用！？TODO！
 */
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    if (_dBlock && ( [_news.locCollected integerValue] == NO || [_news.hasCollected integerValue] == NO)) {
        _dBlock(@{@"event":@"reloadCell"});
    }
    //  更新最新的Details数据 ,（WebView跟新图片存储处理 TODO）
    if (_newsDetail) {
        //        [self updateDetail:_newsDetail];
    }
}

#pragma mark - Dealloc
-(void)dealloc {
    NSLog(@"%@dealloc",[self class]);
    [CNUtils removeHOD];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self.webView stopLoading];
    self.webView = nil;
}



@end
