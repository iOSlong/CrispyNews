//
//  constantStr.h
//  CrispyNews
//
//  Created by xuewu.long on 16/8/9.
//  Copyright © 2016年 letv. All rights reserved.
//

#ifndef constantStr_h
#define constantStr_h


#import "NSString+CN.h"



#pragma mark - server 地址

#if 1
#define CN_NEWS_SERVER              @"http://api.topnews24.mobi/"         // 线上服务器
#define CN_TEST_NEWS_SERVER         @"http://10.154.250.99:8090/"         // 测试服务器
#define CN_SHARE_SERVER             @"http://m.topnews24.online/"         // 分享服务器
#else
//如果服务比较慢，试试这个机器http://10.121.145.233:8080（或1），0是dev ,1是online环境
#define CN_NEWS_SERVER              @"http://10.121.145.233:8081/"        // 线上服务器
#define CN_TEST_NEWS_SERVER         @"http://10.121.145.233:8080/"        // 测试服务器
#endif

#define CN_YAJUN_TEST_NEWS_SERVER         @"http://10.73.137.180:8080/"   // 亚军本地专线


//api.topnews24.mobi   域名 from +浩


#pragma mark - constant


#define APPVERSION                                          ([[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"])
#define KEYFROM                                             [NSString stringWithFormat:@"CrispyNews.%@.iPhone", APPVERSION]
#define CNAvalibleOS(os_version)                            ([[[UIDevice currentDevice] systemVersion] floatValue] >= os_version)


#define TOPNEWS_APP_ID                                 @"1234567890"
#define TOPNEWS_APP_NAME                               @"TopNews"
#define VENDOR                                         @"AppStore"
//http server time out setting.
#define TOPNEWS_HTTP_SERVER_TIMEOUT                    20.0
#define NEWSLIST_DOWNLOAD_TIMEOUT                      60.0
#define NAVBAROFFSETY                                  64       
#define PAGECOUNT_NEWS                                 15
#define DOWNLOAD_COUNT                                 25


#ifdef DEBUG
#define BUILD_MODE                           0 // 0 for test, 1 for online , 2 for local.
#define DEBUG_FLAG                           1
#else
#define BUILD_MODE                           1
#define DEBUG_FLAG                           0
#endif




#define DEV_MODELH5                 @"detail2"
#define DEV_PLACEHOLDERIMG          @"DEV_PLACEHOLDERIMG"


// 字符串为空判断
#define TextValid(text) (text == nil || [text isKindOfClass:[NSNull class]] || [text isEqualToString:@""]) ? NO : YES




#pragma mark - FileName About
static NSString *CACHE_DISK_NAMESPACE                   = @"fmy";
//static NSString *CACHE_DOWNLOAD_FULLNAMESPACE           = @"com.fmy.topnews.";
static NSString *CACHE_DISK_IMAGELIST                   = @"com.fmy.imagelist";
static NSString *CACHE_DISK_NEWSDETAIL                  = @"com.fmy.newsdetail";
static NSString *CACHE_DISK_DATABASE                    = @"com.fmy.database";



#pragma mark -
#pragma mark USER DEFAULT KEY
static NSString *cn_USER_DEFAULT_KEY_PUSHID                = @"pushID";
static NSString *cn_USER_DEFAULT_KEY_PHONE_NUMBER          = @"phoneNumber";
static NSString *cn_USER_DEFAULT_KEY_UUID                  = @"userDefaultsUUIDKey";
static NSString *USER_DEFAULT_KEY_SERVER_SETTING           = @"serverSetting"; // 暂时不设置成和phone绑定.
static NSString *USER_DEFAULT_KEY_WEBVIEW_TYPE             = @"webviewStyle";
static NSString *USER_DEFAULT_KEY_APNS_DEVICETOKEN         = @"deviceToken"; 
static NSString *USER_DEFAULT_KEY_UID                      = @"uid";
static NSString *USER_DEFAULT_KEY_TOKEN                    = @"token";
static NSString *USER_DEFAULT_KEY_USERSTATE                = @"userState";
static NSString *USER_DEFAULT_KEY_FACEBOOKTOKEN            = @"facebookToken";
static NSString *USER_DEFAULT_KEY_ACCOUNT                  = @"userAccount";
static NSString *USER_DEFAULT_KEY_CNSTATUS                 = @"appStatus";
static NSString *USER_DEFAULT_KEY_LOCLINECOLLECTIONCOUNT   = @"loclineCollectionCount";
static NSString *USER_CEFAULT_KEY_NOTIFICATION_TYPE        = @"notofocationStyle";
static NSString *USER_DEFAULT_KEY_IMGSHOWCONTROL           = @"imgShowControl";



#pragma mark - APP Status Enum
#pragma mark - NOTIFICATION_NAME
typedef NS_ENUM(NSUInteger, CNStatus) {
    CNStatusNetNotReachable,
    CNStatusNetReachableViaWifi     = 1,
    CNStatusNetReachableViaWWAN     = 1 << 1,
    CNStatusNetReachableUnknown     = 1 << 2,
    CNStatusNetReachable2G          = 1 << 3,
    CNStatusNetReachable3G          = 1 << 4,
    CNStatusNetReachable4G          = 1 << 5,
    CNStatusNetReachableWifi        = CNStatusNetReachableViaWifi,
    CNStatusNetReachableNone        = 1 << 7,// 无网络

    CNStatusUserSignIn              = 3,
    CNStatusUserSignOut             = 3 << 1,
    CNStatusUserSignUnknown         = 3 << 2,
    // 且用不着
    CNStatusCombinSignInWithWifi        = CNStatusUserSignIn|CNStatusNetReachableViaWifi,
    CNStatusCombinSignInWithWWAN        = CNStatusUserSignIn|CNStatusNetReachableViaWWAN,
    CNStatusCombinSignInWithUnknown     = CNStatusUserSignIn|CNStatusNetReachableUnknown,
    CNStatusCombinSignOutWithWifi       = CNStatusUserSignOut|CNStatusNetReachableViaWifi,
    CNStatusCombinSignOutWithWWAN       = CNStatusUserSignOut|CNStatusNetReachableViaWWAN,
    CNStatusCombinSignOutWithUnknown    = CNStatusUserSignOut|CNStatusNetReachableUnknown,
};

#pragma mark - ViewJumpRelation
typedef NS_ENUM(NSUInteger , CNFrom) {
    CNFromFavesListVC,
    CNFromHomeListVC,
    CNFromPushNoti,
    CNFromOtherOri,
};


#pragma mark - NOTIFICATION_NAME
typedef NS_ENUM(NSUInteger, CNEventType) {
    CNEventTypeNotiLoginNeed,
    CNEventTypeNotiServerChange,
    CNEventTypeNotiNetStatusChange,
    CNEventTypeNotiLoginStateChange,
    CNEventTypeNotiMMDrawerGestureBan,
    CNEventTypeNotiMMDrawerGestureKeep,
    CNEventTypeNotiDownLoadNewsOver,
};
static NSString *notiEvent                                 = @"notiEvent";
static NSString *notiSenter                                = @"notiSenter";
static NSString *notiBool                                  = @"notiBool";


static NSString *NOTI_CHANGESERVER_POST                    = @"serverpostChanged";
static NSString *NOTI_NETWORKSTATUSCHAGNE                  = @"netstatusChange";
static NSString *NOTI_NEWSDOWNLOAD_OVER                    = @"news_detail_listDownOver";
static NSString *NOTI_MMDRAWERSTOP_GUESTURE_COMPLEX        = @"mmdrawer_guesture_stop";
static NSString *NOTI_NEEDLOGIN_POST                       = @"needlogin_notification";
static NSString *NOTI_USERLOGINSTATE_CHANGE                = @"userloginstate_change";
static NSString *NOTI_SOURCE_DETAIL_NEEDLOAD               = @"SOURCE_DETAIL_NEEDLOAD";



#pragma mark - OTHER STATUS FOR POPSHOW MSG
static NSString *networknotAvailable                        = @"Network unavailable";
static NSString *MSG_DOWNLOAD_FAILD                         = @"Failed to download";
static NSString *AUTHORIZATION_KEY                          = @"Authorization";
static NSString *MSG_DETAIL_MARK_SUCCESS                    = @"Bookmarked";
static NSString *MSG_DETAIL_DISMARK_SUCCESS                 = @"Bookmark removed";
static NSString *MSG_DETAIL_COMMENT_SUCCESS                 = @"Comments sent";
static NSString *MSG_NEWSLIST_NOMORENEWS                    = @"No more news";
static NSString *MSG_LOGIN_SUCCESS                          = @"Login successfully";
static NSString *MSG_LOGIN_FAILED                           = @"Failed to log in";
static NSString *MSG_LOGIN_CAMCELED                         = @"Login canceled";
static NSString *MSG_NOTIFICATIONS                          = @"Notifications";
static NSString *MSG_NOTIFICATIONS_CLOSE                    = @"Important news may miss when off";
static NSString *MSG_NEKWORK_CELLUAR                        = @"No image under celluar network";
static NSString *MSG_CLEAR_CACHE                            = @"Clear cache";
static NSString *MSG_APPSTORE_COMMENT                       = @"Rate us";
static NSString *MSG_VERSION                                = @"Version";
static NSString *MSG_LOGOUT                                 = @"Log Out";
static NSString *MSG_LOGOUT_FLIP                            = @"Log out?";

#define MSG_DOWNLOAD_COUNT(A)   [NSString stringWithFormat:@"%ld stories downloaded",A]





#pragma mark - Agnes About
static NSString *WIDGET_APPON                   = @"1.1";
static NSString *WIDGET_APPOFF                  = @"1.2";
static NSString *WIDGET_APPENBACK               = @"1.3";
static NSString *WIDGET_APPHOMEBACK             = @"1.4";
static NSString *WIDGET_DOWNLOAD_CLICK          = @"2";
static NSString *WIDGET_DOWNLOAD_FAIL           = @"2.1";
//新闻feed流
static NSString *WIDGET_CHANNEL_RECOMMED_EXPOSE = @"3";         //推荐频道新闻的曝光
static NSString *WIDGET_CHANNEL_EXPOSE          = @"3.1";       //除推荐外，其他频道新闻的曝光
static NSString *WIDGET_NEWS_SLIPED_EXPOSE      = @"3.2";       //划过的新闻的曝光（划过是指划的很快，中间没有停止）
static NSString *WIDGET_NEWS_CLICK              = @"3.3";       //新闻的点击
static NSString *WIDGET_NEWSLIST_LOAD           = @"3.4";       //请求数据
static NSString *WIDGET_NEWSLIST_FRESHHEADER    = @"3.5";       //请求数据（用户主动下拉刷新）
static NSString *WIDGET_NEWSLIST_FRESHFOOTER    = @"3.6";       //请求数据（用户向上滑动时如果没有新数据了会进行刷新）
//频道列表
static NSString *WIDGET_BUTTON_CHANNEL_EDIT     = @"4";         //点击频道编辑页按钮
static NSString *WIDGET_CHANNEL_CLICK           = @"4.1";       //频道选中
static NSString *WIDGET_CHANNEL_DRAG            = @"4.2";       //拖动
//首页
static NSString *WIDGET_HOMEVIEW_MENU_CLICK     = @"5";         //点击 首页列表中的功能页入口『+』
// 抽屉功能菜单页面
static NSString *WIDGET_MENUVIEW_EXPOSE             = @"5.1";       //功能页主界面曝光
static NSString *WIDGET_MENU_FAVES_CLICK            = @"6";         //功能页主界面点击收藏
static NSString *WIDGET_FAVESLIST_EXPOSE            = @"6.1";       //收藏界面曝光次数
static NSString *WIDGET_FAVESLIST_EDIT_CLICK        = @"6.3";       //点击收藏列表中的编辑按钮
static NSString *WIDGET_FAVESLIST_DEL_CLICK         = @"6.4";       //点击收藏删除按钮
static NSString *WIDGET_MENU_FEEDBACK_CLICK         = @"7";         //功能页主界面-feedback
static NSString *WIDGET_MENU_USERAVATAR_CLICK       = @"8";         //功能页主界面-用户头像
static NSString *WIDGET_MENU_SET_CLICK              = @"9";         //功能页主界面-设置

// 详情页面
static NSString *WIDGET_DETAIL_EXPOSE               = @"3.7";       //从首页feed 流点击进详情页
static NSString *WIDGET_DETAIL_FROM_RECOMMEND       = @"3.8";       //从相关推荐点击进详情页
static NSString *WIDGET_DETAIL_RECOMMEND_EXPOSE     = @"10";        //曝光次数
static NSString *WIDGET_DETAIL_RECOMMEND_CLICK      = @"10.1";      //对相关推荐新闻的点击
static NSString *WIDGET_DETAIL_FAVES_CLICK          = @"12";        //点击收藏的次数与人数
static NSString *WIDGET_DETAIL_FAVES_CANCEL         = @"12.1";      //点击收藏的次数与人数
static NSString *WIDGET_DETAIL_SHARES_CLICK         = @"11";        //点击分享的次数与人数
static NSString *WIDGET_DETAIL_SHARES_FACEBOOK      = @"11.1";      //点击 Facebook 分享的次数与人数
static NSString *WIDGET_DETAIL_SHARES_TWITTER       = @"11.3";      //点击 Twitter 分享的次数与人数
static NSString *WIDGET_DETAIL_SHARES_WHATSAPP      = @"11.2";      //点击 WhatsApp 分享的次数与人数







#endif /* constantStr_h */






