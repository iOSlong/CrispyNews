//
//  CNNewsDetailViewController.m
//  CrispyNews
//
//  Created by xuewu.long on 16/8/9.
//  Copyright © 2016年 letv. All rights reserved.
//

#import "CNNewsDetailViewController.h"
#import <WebKit/WebKit.h>
#import "JSMessageInputView.h"
#import "CNDefult.h"
#import "CNBottomView.h"
#import "CNDataManager.h"
#import "AppDelegate.h"
#import <JavaScriptCore/JavaScriptCore.h>

#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKShareKit/FBSDKShareKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <TwitterKit/TwitterKit.h>
#import <SDWebImage/UIImageView+WebCache.h>


@interface CNNewsDetailViewController ()<WKNavigationDelegate,WKUIDelegate,WKScriptMessageHandler,JSMessageInputViewDelegate,UITextFieldDelegate,CNBottomViewDelegate,FBSDKSharingDelegate>

@property (nonatomic, strong) WKWebView             *mywkView;


@property (nonatomic, strong) JSMessageInputView    *messageInputView;
@property (nonatomic, strong) CNBottomView          *inPutBottomView;
@property (nonatomic, strong) CNBottomView          *shareBottomView;
@property (nonatomic, strong) CNBottomView          *signInBottomView;
@property (nonatomic, strong) UIProgressView        *progressView;
@property (nonatomic, strong) NSObject              *recommends;
@property (nonatomic, strong) NSObject              *comments;

@end



@implementation CNNewsDetailViewController

- (WKWebView *)mywkView {
    if (!_mywkView) {
        WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
        
        // 设置偏好设置
        config.preferences = [[WKPreferences alloc] init];
        // 默认为0
        config.preferences.minimumFontSize = 10;
        // 默认认为YES
        config.preferences.javaScriptEnabled = YES;
        // 在iOS上默认为NO，表示不能自动通过窗口打开
        config.preferences.javaScriptCanOpenWindowsAutomatically = NO;
        
        // web内容处理池
        config.processPool = [[WKProcessPool alloc] init];
        
        // 通过JS与webview内容交互
        config.userContentController = [[WKUserContentController alloc] init];
        
        // 注入JS对象名称AppModel，当JS通过hanleName来调用时，
        // 我们可以在WKScriptMessageHandler代理中接收到
        // [config.userContentController addScriptMessageHandler:self name:@"setCount"];
        [config.userContentController addScriptMessageHandler:self name:@"AppModel"];
        [config.userContentController addScriptMessageHandler:self name:@"jsCallImgList"];
        [config.userContentController addScriptMessageHandler:self name:@"jsGetImgFromLocal"];
        
        // config.dataDetectorTypes     = UIDataDetectorTypeAll;
        
        _mywkView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, SCREENW, self.view.height - heighOfInputBar()) configuration:config];
        _mywkView.backgroundColor       = [UIColor whiteColor];
        _mywkView.navigationDelegate    = self;
        _mywkView.UIDelegate            = self;
        _mywkView.allowsBackForwardNavigationGestures = YES;
        
        
    }
    return _mywkView;
}


- (UIProgressView *)progressView {
    if (!_progressView) {
        _progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, 64, SCREENW, 2)];
        _progressView.tintColor = [UIColor whiteColor];
        _progressView.progressTintColor = [UIColor greenColor];
        _progressView.trackTintColor = [UIColor whiteColor];
    }
    return _progressView;
}

#pragma mark - InputView
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

- (void)viewheightChanged:(float)height {
    //    _messageInputView.height = height;
}

#pragma mark 添加评论
- (void)textViewEnterSend {
    // TODO 判断是否有网络， 判断用户是否进行了登录，
    [self netSetComment:self.messageInputView.textView.text];
    
}

- (BOOL)judgeLoginState {
    if ([[CNDefult shareDefult].userState integerValue] == 0) {
        [self.signInBottomView setHidden:NO];
        return NO;
    }
    return YES;
}



#pragma mark - ShareView + SignInView
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


#pragma mark - CNBottomViewDelegate
- (void)bottomBtnClickEvent:(CNBottomEvent)event {
    if (_newsDetail ) {
        
    }else{
        return;
    }
    if (event == CNBottomEventComment)
    {
        // TODO， 进行滚动效果
        [self javascriptScrollTopWithComment:NO];
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
        }else{
            [self netSetCollectionState:NO];
        }
    }
    else if (event == CNBottomEventShareWhatsapp)
    {
        NSDictionary *info = @{@"vid"   :_news.ID,
                               @"cid"   :self.channelName,
                               @"url"   :_news.url,
                               @"eid"   :[CNUtils myRandomUUID],
                               };
        [CNUtils reportInfo:info widget:WIDGET_DETAIL_SHARES_WHATSAPP Evt:evt_click];

        [self shareWhatsapp];
        
    }else if (event == CNBottomEventShareFacebook){
        
        NSDictionary *info = @{@"vid"   :_news.ID,
                               @"cid"   :self.channelName,
                               @"url"   :_news.url,
                               @"eid"   :[CNUtils myRandomUUID],
                               };
        [CNUtils reportInfo:info widget:WIDGET_DETAIL_SHARES_FACEBOOK Evt:evt_click];
        

        [self shareFacebook];
        
    }else if (event == CNBottomEventShareTwitter){
        
        NSDictionary *info = @{@"vid"   :_news.ID,
                               @"cid"   :self.channelName,
                               @"url"   :_news.url,
                               @"eid"   :[CNUtils myRandomUUID],
                               };
        [CNUtils reportInfo:info widget:WIDGET_DETAIL_SHARES_TWITTER Evt:evt_click];
        

        [self shareTwitter];
        
    }else if (event == CNBottomEventShareMore){
        
    }else if (event == CNBottomEventShareCancel){
        self.shareBottomView.hidden = YES;
    }else if (event == CNBottomEventSinginClick) {
        NSDictionary *info = @{notiSenter:NSStringFromClass([self class]),
                               notiEvent: [NSNumber numberWithInteger:CNEventTypeNotiLoginNeed]};
        [CNUtils postNotificationName:NOTI_NEEDLOGIN_POST object:nil userInfo:info];
    }
}

- (BOOL)bottomFieldShouldBeginEditing {
    if ([self judgeLoginState]) {
        [self javascriptScrollTopWithComment:YES];
        [self.messageInputView.textView becomeFirstResponder];
    }
    return NO;
}



- (void)detailBlock:(DetailBlock)thisBlock {
    self.dBlock = thisBlock;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [self.mywkView stopLoading];
    if (_dBlock && ( [_news.locCollected integerValue] == NO || [_news.hasCollected integerValue] == NO)) {
        _dBlock(@{@"event":@"reloadCell"});
    }
    //  更新最新的Details数据 ,（WebView跟新图片存储处理 TODO）
    if (_newsDetail) {
        //        [self updateDetail:_newsDetail];
    }
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    /// 0. 添加通知
    [self configureNotifications];
    
    /// 1. 添加WKWebView 控件
    [self.view addSubview:self.mywkView];
    
    
    /// 2. 添加下发的输入控件
    [self.view addSubview:self.messageInputView];
    [self.view addSubview:self.inPutBottomView];
    
    
    [self.view addSubview:self.progressView];
    
    
    
    // 更新新闻离别数据阅读状态
    if (_news) {
        _news.readState = @1;
        if ([_news.locCollected integerValue] || [_news.hasCollected integerValue]) {
            [[CNDataManager shareDataController] insertNews:_news channel:_channelName type:CNDBTableTypeNewsFaves];
        }
        [[CNDataManager shareDataController] insertNews:_news channel:_channelName type:CNDBTableTypeNewsChannel];
    }
    
    
    NSString *detailUrl = [CNApiManager apiNewsDetailWithChannel:_news.ID];
    NSURL *localHtmlURL = [NSURL URLWithString:detailUrl];
    localHtmlURL =  [[NSBundle mainBundle] URLForResource:@"detail" withExtension:@"html"];
    
    
    NSString *htmlString = [NSString stringWithContentsOfURL:localHtmlURL encoding:NSUTF8StringEncoding error:nil];
    
    NSURL *sourceUrl = [NSURL fileURLWithPath:[CNUtils pathOfNewsDetail]];
    sourceUrl = [NSURL fileURLWithPath:[[NSBundle mainBundle] bundlePath]];
    
    [self.mywkView loadHTMLString:htmlString baseURL:sourceUrl];
    
    
    // 下载处理缓存文件
    UIImageView *shareImgv = [[UIImageView alloc] init];
    [shareImgv sd_setImageWithURL:[NSURL URLWithString:[_news.imgUrls firstObject]] placeholderImage:[UIImage imageNamed:@"cover1"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        self.imgShare= image;
    }];
    
}



#pragma mark - JS Began Comment
- (void)javascriptScrollTopWithComment:(BOOL)comment {
    NSString *scrollJS=@"getScrollTop()";//准备执行的js代码
    if (comment) {
        scrollJS = @"getScrollTop()";
    }else{
        scrollJS=@"getScrollTop()";
    }
    weakSelf();
    [self.mywkView evaluateJavaScript:scrollJS completionHandler:^(id _Nullable title, NSError * _Nullable error) {
        NSLog(@"滑动到评论区域");
        if (comment) {
            [weakSelf.messageInputView.textView becomeFirstResponder];
        }
    }];
}


#pragma mark - WKNavigationDelegate  &  WKUIDelegate

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation { // 类似UIWebView的 -webViewDidStartLoad:
    NSLog(@"didStartProvisionalNavigation");
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation {
    NSLog(@"didCommitNavigation");
    /*
     important ,添加这行代码，WebView详情页面才能够实现右滑回到上一个界面的功能。
     三种情况，
     1. 不能右滑动
     2. 加载静态HTML文本或者其他HTML正常文本，可以右滑动，切UINavigationController+XKObjcSugar得到发挥
     3. 现下情况，h5有一些问题，所以添加代码，实现系统原生效果，在触及最右侧时候可以进行右滑，与Android效果一致。
     */
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    self.mywkView.allowsBackForwardNavigationGestures = YES;
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation { // 类似 UIWebView 的 －webViewDidFinishLoad:
    NSLog(@"didFinishNavigation");
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    // 判断本地数据库是否存在数据
    CNNewsDetail *cacheDetail = [[CNDataManager shareDataController] getNewsDetailById:_news.ID type:CNDBTableTypeNewsDetail];
    if (cacheDetail) {
        [self loadFromDetail:cacheDetail toStore:NO];
    }else{
        [self netGetWebNewsdetail:_news];
    }
}


- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    // 类似 UIWebView 的- webView:didFailLoadWithError:
    NSLog(@"didFailProvisionalNavigation");
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler {
    
    decisionHandler(WKNavigationResponsePolicyAllow);
}



#pragma mark  WKScriptMessageHandler
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    
//    [config.userContentController addScriptMessageHandler:self name:@"jsCallImgList"];
//    [config.userContentController addScriptMessageHandler:self name:@"jsGetImgFromLocal"];

//    userContentController
    
    NSLog(@"%@",message.name);
    NSLog(@"%@",message.body);
    
    NSString *imgLocalJS = @"jsImageHaveOne(100)";
    [self.mywkView evaluateJavaScript:imgLocalJS completionHandler:^(id _Nullable title, NSError * _Nullable error) {
        NSLog(@"%@",error);
        NSLog(@"滑动到评论区域");
    }];

    if ([message.name isEqualToString:@"setCount"]) {
        NSInteger commentCount = [message.body integerValue];
        self.inPutBottomView.commentCount = [NSString stringWithFormat:@"%ld",commentCount];
    }else if ([message.name isEqualToString:@"AppModel"]) {
        NSLog(@"AppMode :%@",message.body);
    }else if([message.name isEqualToString:@"jsCallImgList"]){
        
    }else if([message.name isEqualToString:@"jsGetImgFromLocal"]){
        
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

- (void)updateDetail:(CNNewsDetail *)detail {
    
    [[CNDataManager shareDataController] insertNewsDetail:_newsDetail type:CNDBTableTypeNewsDetail];
}

#pragma mark 刷新详情
- (void)loadFromDetail:(CNNewsDetail *)detail toStore:(BOOL)store {
    self.newsDetail = detail;
    dispatch_async(dispatch_get_main_queue(), ^{
        //TODO，收藏原则，先判断本地，再判断网络的，（判断条件，网络状态《登录状态<本地收藏状态，网络收藏状态>》）。
        if ([[CNDefult shareDefult].userState integerValue] == 0) {
            self.inPutBottomView.isLiked = [detail.locCollected integerValue];
        }else{
            self.inPutBottomView.isLiked = [detail.hasCollected integerValue];
        }
        
        NSString *jsonString = [[NSString alloc] initWithData:detail.data encoding:NSUTF8StringEncoding];
        jsonString = [jsonString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];  //去除掉首尾的空白字符和换行字符
        NSString  *setDetailJS = [NSString stringWithFormat:@"setDetail(%@, 1, 0)", jsonString];
        //    NSLog(@"result %@",comCountJS);
        [self.mywkView evaluateJavaScript:setDetailJS completionHandler:^(id _Nullable title, NSError * _Nullable error) {
            if (error) {
                /// TODO bug ，当发送类容为I'm 的时候 A JavaScript exception occurred
                NSLog(@"submit failed %@",error);
            }else{
                
            }
        }];
    });
    if (store) {
        [self updateDetail:detail];
    }
    if (self.recommends == nil) {
        [self netGetRecommends];
    }
    if (self.comments == nil) {
        [self netGetComments];
    }
}
#pragma mark 刷新推荐
- (void)loadFromRecommend:(id)recommends {
    dispatch_async(dispatch_get_main_queue(), ^{
        NSData  *dataComments = [NSJSONSerialization dataWithJSONObject:recommends options:NSJSONWritingPrettyPrinted error:nil];
        NSString *jsonString = [[NSString alloc] initWithData:dataComments encoding:NSUTF8StringEncoding];
        jsonString = [jsonString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];  //去除掉首尾的空白字符和换行字符
        
        NSString *setRecommendJS = [NSString stringWithFormat:@"setRecommend(%@)",jsonString];
        [self.mywkView evaluateJavaScript:setRecommendJS completionHandler:^(id _Nullable title, NSError * _Nullable error) {
            if (error) {
                /// TODO bug ，当发送类容为I'm 的时候 A JavaScript exception occurred
                NSLog(@"submit failed %@",error);
            }else{
                
            }
        }];
    });
}

#pragma mark 刷新评论
- (void)loadFromComments:(id)comments {
    dispatch_async(dispatch_get_main_queue(), ^{
        NSData  *dataComments = [NSJSONSerialization dataWithJSONObject:comments options:NSJSONWritingPrettyPrinted error:nil];
        NSString *jsonString = [[NSString alloc] initWithData:dataComments encoding:NSUTF8StringEncoding];
        jsonString = [jsonString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];  //去除掉首尾的空白字符和换行字符
        
        NSString *setCommentsJS = [NSString stringWithFormat:@"setComments(%@)",jsonString];
        [self.mywkView evaluateJavaScript:setCommentsJS completionHandler:^(id _Nullable title, NSError * _Nullable error) {
            if (error) {
                /// TODO bug ，当发送类容为I'm 的时候 A JavaScript exception occurred
                NSLog(@"submit failed %@",error);
            }else{
                
            }
        }];
    });
}

#pragma mark - NetWork
- (void)netGetWebNewsdetail:(CNNews *)news {
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
            NSError *thiserror = [[NSError alloc] initWithDomain:@"LoadDown" code:320 userInfo:@{@"netInfo":netInfo}];
            NSLog(@"%@",thiserror);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error %@",error);
    }];
}

- (void)netGetRecommends {
    NSString *recommendsAPi = [CNApiManager apiDetailGetRecommendsByNewsId:_news.ID];
    NSDictionary *param = @{@"limit" : @""};
    weakSelf();
    [[CNHttpRequest shareHttpRequest] POST:recommendsAPi parameters:param success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        CNNetInfo *netInfo = [[CNNetInfo alloc]init];
        [netInfo yy_modelSetWithJSON:responseObject];
        id result = [responseObject objectForKey:@"result"];
        if (netInfo.success && result && result != [NSNull null])
        {
            weakSelf.recommends = result;
            [weakSelf loadFromRecommend:result];
        }else{
            [weakSelf showHint:netInfo.errorMsg hide:1.5f];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (error.userInfo) {
            NSData *errorData = [error.userInfo objectForKey:@"com.alamofire.serialization.response.error.data"];
            NSString *dataStr = [[NSString alloc] initWithData:errorData encoding:NSUTF8StringEncoding];
            [weakSelf showHint:dataStr hide:1.5f];
        }else{
            [weakSelf showHint:error.description hide:1.5f];
        }
    }];
}

- (void)netGetComments{
    NSString *commentsAPi = [CNApiManager apiDetailGetCommentsByNewsId:_news.ID];
    NSDictionary *param = @{@"cursor" : @0};
    weakSelf();
    [[CNHttpRequest shareHttpRequest] POST:commentsAPi parameters:param success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        CNNetInfo *netInfo = [[CNNetInfo alloc]init];
        [netInfo yy_modelSetWithJSON:responseObject];
        id result = [responseObject objectForKey:@"result"];
        if (netInfo.success && result && result != [NSNull null])
        {
            NSArray *comments = [result objectForKey:@"comments"];
            weakSelf.comments = comments;
            [weakSelf loadFromComments:comments];
        }else{
            [weakSelf showHint:netInfo.errorMsg hide:1.5f];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (error.userInfo) {
            NSData *errorData = [error.userInfo objectForKey:@"com.alamofire.serialization.response.error.data"];
            NSString *dataStr = [[NSString alloc] initWithData:errorData encoding:NSUTF8StringEncoding];
            [weakSelf showHint:dataStr hide:1.5f];
        }else{
            [weakSelf showHint:error.description hide:1.5f];
        }
    }];
}

- (void)netSetComment:(NSString *)comments {
    if (!TextValid(comments) || !TextValid(_news.ID)) {
        return;
    }
    NSString *commentsApi = [CNApiManager apiDetailCommentsByNewsId:_news.ID];
    NSDictionary *param = @{@"text" : comments};
    weakSelf();
    [[CNHttpRequest shareHttpRequest] POST:commentsApi parameters:param success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        CNNetInfo *netInfo = [[CNNetInfo alloc]init];
        [netInfo yy_modelSetWithJSON:responseObject];
        if (netInfo.success)
        {
            [weakSelf.messageInputView.textView resignFirstResponder];
            weakSelf.messageInputView.textView.text = nil;
            weakSelf.inPutBottomView.inputContent   = nil;
            [weakSelf showHint:@"comments success!" hide:1.5f];
        }else{
            [weakSelf showHint:netInfo.errorMsg hide:1.5f];
        }
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        /// TODO bug ，当发送类容为I'm 的时候 A JavaScript exception occurred
        [weakSelf showHint:error.description hide:1.5f];
        
        //            [weakSelf showHint:@"success！" hide:1.5f];
    }];
}

- (void)netSetCollectionState:(BOOL)isCollect {
    if (!TextValid(_news.ID)) {
        return;
    }
    // 用户未登录的情况下
    if ([[CNDefult shareDefult].userState integerValue] == 0) {
        if (isCollect) {
            [self showHint:@"Bookmarked" hide:TIMER_HIDE_DELAY];
            self.newsDetail.locCollected = @1;
            self.news.locCollected = @1;
            NSTimeInterval coltimer = [[NSDate date] timeIntervalSince1970] * 1000;
            self.news.collectTime = [NSNumber numberWithDouble:coltimer];
            self.news.timerLoc = [NSNumber numberWithDouble:coltimer];
            [[CNDataManager shareDataController] insertNews:_news channel:self.channelName type:CNDBTableTypeNewsFaves];
        }else{
            [self showHint:@"Bookmark removed" hide:TIMER_HIDE_DELAY];
            self.newsDetail.locCollected = @0;
            self.news.locCollected = @0;
            [[CNDataManager shareDataController] deleteNews:_news type:CNDBTableTypeNewsFaves];
        }
        // 同步频道列表~
        if ([self.newsFrom isEqualToString:detailFromChannelList]) {
            [[CNDataManager shareDataController] insertNews:_news channel:self.channelName type:CNDBTableTypeNewsChannel];
        }
        [self loadFromDetail:_newsDetail toStore:YES];
        return;
    }
    NSString *collectionApi = [CNApiManager apiDetailCollection:isCollect byNewsId:_news.ID];
    weakSelf();
    if (isCollect) {
        [[CNHttpRequest shareHttpRequest] GET:collectionApi parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            CNNetInfo *netInfo = [[CNNetInfo alloc]init];
            [netInfo yy_modelSetWithJSON:responseObject];
            if (netInfo.success)
            {
                [weakSelf showHint:@"Bookmarked" hide:TIMER_HIDE_DELAY];
                weakSelf.newsDetail.hasCollected    = @1;
                weakSelf.news.hasCollected          = @1;
                [[CNDataManager shareDataController] insertNews:_news channel:weakSelf.channelName type:CNDBTableTypeNewsFaves];
                [weakSelf loadFromDetail:_newsDetail toStore:YES];
                
            }else{
                [weakSelf showHint:netInfo.errorMsg hide:TIMER_HIDE_DELAY];
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            if (error.userInfo) {
                NSString *errMsg = [error.userInfo objectForKey:@"NSLocalizedDescription"];
                if (errMsg) {
                    [weakSelf showHint:errMsg hide:TIMER_HIDE_DELAY];
                }
            }
        }];
    }
    else
    {
        NSDictionary *param = @{@"newsId" : _news.ID};
        [[CNHttpRequest shareHttpRequest] POST:collectionApi parameters:param success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
            CNNetInfo *netInfo = [[CNNetInfo alloc]init];
            [netInfo yy_modelSetWithJSON:responseObject];
            if (netInfo.success)
            {
                [weakSelf showHint:@"Bookmark removed" hide:TIMER_HIDE_DELAY];
                weakSelf.newsDetail.hasCollected    = @0;
                weakSelf.news.hasCollected          = @0;
                
                [[CNDataManager shareDataController] deleteNews:_news type:CNDBTableTypeNewsFaves];
                [weakSelf loadFromDetail:_newsDetail toStore:YES];
                
            }else{
                [weakSelf showHint:netInfo.errorMsg hide:TIMER_HIDE_DELAY];
            }
        } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
            if (error.userInfo) {
                NSString *errMsg = [error.userInfo objectForKey:@"NSLocalizedDescription"];
                if (errMsg) {
                    [weakSelf showHint:errMsg hide:TIMER_HIDE_DELAY];
                }
            }
        }];
    }
}


#pragma mark - AlertDelegate
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:message?:@"" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:([UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler();
    }])];
    [self presentViewController:alertController animated:YES completion:nil];
    
}

- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL))completionHandler{
    //    DLOG(@"msg = %@ frmae = %@",message,frame);
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:message?:@"" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:([UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(NO);
    }])];
    [alertController addAction:([UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(YES);
    }])];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * _Nullable))completionHandler{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:prompt message:@"" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.text = defaultText;
    }];
    [alertController addAction:([UIAlertAction actionWithTitle:@"完成" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(alertController.textFields[0].text?:@"");
    }])];
}




#pragma mark Whatsapp 点击
- (void) shareWhatsapp {
        
    NSString *str = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL,(CFStringRef)[CNApiManager apiNewsDetailWithChannel:_news.ID], NULL,CFSTR("!*'();:@&=+$,/?%#[]"),kCFStringEncodingUTF8));
    NSURL *whatsappURL = [NSURL URLWithString:[NSString stringWithFormat:@"whatsapp://send?text=%@",str]];
    
    if ([[UIApplication sharedApplication] canOpenURL: whatsappURL]) {
        [[UIApplication sharedApplication] openURL: whatsappURL];
    }
}

- (void) shareFacebook {
    FBSDKShareLinkContent *content = [[FBSDKShareLinkContent alloc] init];
    content.contentURL = [NSURL URLWithString:[CNApiManager apiNewsDetailWithChannel:_news.ID]];
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
    [self showHint:@"Failed" hide:2];
    
}
- (void)sharer:(id<FBSDKSharing>)sharer didCompleteWithResults:(NSDictionary *)results {
    //    NSLog(@"%@",[sharer.shareContent description]);
    if ([results allKeys].count == 0) {
        //        [self showHint:@"Cancel" hide:2];
        
    }else {
        [self showHint:@"Shared" hide:2];
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
        
        
        [composer setURL:[NSURL URLWithString:_news.url]];
        
        [composer setImage:self.imgShare];
        
        
        // Called from a UIViewController
        [composer showFromViewController:self completion:^(TWTRComposerResult result) {
            if (result == TWTRComposerResultCancelled) {
                [self showHint:@"Cancel" hide:2];
            }
            else {
                [self showHint:@"Shared" hide:2];
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

#pragma mark - Dealloc
/* 释放  dealloc 等处理
 // * 使用self.mywkView, 导致dealloc函数没有调用！？TODO！
 */
-(void)dealloc {
    NSLog(@"%@dealloc",[self class]);
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self.mywkView stopLoading];
}



@end
