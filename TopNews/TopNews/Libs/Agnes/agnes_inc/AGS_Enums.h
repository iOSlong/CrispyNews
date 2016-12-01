//
//  AGS_Enums.h
//  garfield
//
//  Created by wuqigang on 8/22/15.
//  Copyright (c) 2015 wuqigang. All rights reserved.
//

#ifndef garfield_AGS_Enums_h
#define garfield_AGS_Enums_h

//#import <Foundation/Foundation.h>

typedef enum  {None=-1,Success,Failed,Canceled} EventResult;

typedef enum  {op_none,click,slide,drag,double_click} Operation;

typedef enum
{
    CN,
    HK,
    US,
    TH,
    IN,
    RU,//Russia
    SG,//Singapore
    MO,//macau
    ID,//indonesia
    TW,
    CA,//Canada
    NONE
    
}Area;
typedef enum
{
    ky_url,
    ky_input,
    ky_searchEngine,
    ky_from,
    ky_to,
    ky_des,
    ky_failType,
    ky_fileName,
    ky_fileType,
    ky_fileSize,
    ky_folderName,
    ky_appName,
    ky_packageName,
    ky_provider,
    ky_starttime,
    ky_endtime,
    ky_vid,
    ky_gid,
    ky_perc,
    ky_show,
    ky_content,
    ky_type,
    ky_method,
    ky_wName,
    ky_path,
    ky_scName,
    ky_num,
    ky_class1,
    ky_res,
    ky_op,
    ky_source,
    ky_productCode,
    ky_networkType,
    ky_auid
}KeyEnum;

typedef enum
{
    HeartbeatRequest,
    SemsMessage,
    LogFileBlock,
    EnvironmentRequest,
    AppRequest,
    EventRequest,
    PlayRequest,
    MusicPlayRequest,
    WidgetRequest,
    BatchRequest,
    ErrorRequest
}MessageType;

typedef enum
{
    sndSuc,
    conErr,
    sndErr,
    recErr
}SndRlt;

typedef enum
{
    evt_expose,
    evt_click,
    evt_install,
    evt_uninstall,
    evt_upgrade,
    evt_download,
    evt_jump,
    evt_sync,
    evt_upload,
    evt_searchRes,
    evt_book,
    evt_unbook,
    evt_follow,
    evt_exception,
    evt_push,
    evt_sort,
    evt_switchDesktop,
    evt_remove,
    evt_open,
    evt_unopen,
    evt_close,
    evt_back,
    evt_switchMode,
    evt_connect,
    evt_share,
    evt_switchMess,
    evt_switchApp,
    evt_set,
    evt_intercept,
    evt_reminder,
    evt_receive,
    evt_mute,
    evt_answer,
    evt_hangup,
    evt_loseConn,
    evt_callback,
    evt_shortcut,
    evt_photo,
    evt_record,
    evt_filter,
    evt_unlock,
    evt_showNoticebar,
    evt_clearMemory,
    evt_timeout,
    evt_comment,
    evt_up,
    evt_down,
    evt_popup,
    evt_top,
    evt_add,
    evt_callout,
    evt_copy,
    evt_move,
    evt_send,
    evt_delete,
    evt_compress,
    evt_decompress,
    evt_rename,
    evt_create,
    evt_switch,
    evt_subscrible,
    evt_unsubscrible,
    evt_accept,
    evt_refuse,
    evt_notsure,
    evt_play,
    evt_update,
    evt_refresh,
    evt_glide
}EventEnum;

typedef enum
{
    app_LeShop,
    app_LetvUltimateed,
    app_LePhoneDLNA,
    app_Weibo,
    app_WPS,
    app_WPSOffice,
    app_Letv,
    app_LeShot,
    app_BaiduInput,
    app_LeSearch,
    app_UnicomWo,
    app_WoStore,
    app_UnicomClient,
    app_Wo116114,
    app_ZhuoMian,
    app_ChaoJiZhiBo,
    app_WhatsLIVE,
    app_LEHAI,
    app_LeTing,
    app_Lesports,
    app_LePlay,
    app_LeSportsTV,
    app_LetvDpkk,
    app_LetvTvControl,
    app_ios_remoteControlClient,
    app_ios_DPKKClient,
    app_SuperVideo,
    app_Lemall_iOS,
    app_LeSportsHD,
    app_ZhangYuTV,
    app_FengYunZhiBo,
    app_FengYunTV,
    app_FengYunZhiBoHD,
    app_FengYunTVHD,
    app_Leski,
    app_LesportsLotteryIOS,
    app_LesportsMallSDKIOS
}AppEnum;

typedef enum
{
    leui_Desktop,
    leui_Browser,
    leui_FileManagement,
    leui_Message,
    leui_Phone,
    leui_Photo,
    leui_LockBar,
    leui_NoticeBar,
    leui_ControlCenter,
    leui_SystemSetting,
    leui_AppManagement,
    leui_DialPanel,
    leui_Calendar,
    leui_Notepaper,
    leui_Calculator,
    leui_Weather,
    leui_Map,
    leui_Clock,
    leui_Email,
    leui_Wallpaper,
    leui_Recorder,
    leui_Video,
    leui_Contacts,
    leui_Telecontroller,
    leui_Music,
    leui_SIMCardApp,
    leui_Download,
    leui_Feedback,
    leui_SystemUpgrade,
    leui_RecordMemo,
    leui_Camera,
    leui_Calling,
    leui_VoiceAssist,
    leui_Sports,
    leui_LeStoreMobile,
    leui_Huangye,
    leui_PackageInstaller
}LeUIApp;

typedef enum
{
    as_360,             // 360 Phone assistant
    as_baidu,              // Baidu Phone assistant
    as_wandoujia,      // Wandoujia
    as_AndroidMarket,      // Android Market
    as_anzhi,              // Anzhi Market
    as_googleplay,         // Google Play
    as_91zhushou,           // 91 Phone assistant
    as_xiaomi,             // Xiaomi Store
    as_tencentyyb,         // Tencent yingyongbao
    as_yingyonghui,     // Yingyonghui
    as_jifeng,              // Jifeng Market
    as_Nduo,               // N More Market
    as_mobileMM,        // China-Mobile mobile market
    as_youyi,          // Youyi Market
    as_woshangcheng,     // China-Unicom WO Store
    as_3GAndroid,         // 3G Android Market
    as_mumayi,            // Mumayi Market
    as_163App,          // 163 Application Center
    as_sogoumarket,  // Sogou Market
    as_sogoutools,    // Sogou Phone assistant
    as_paojiao,          // Paojiao Net
    as_taobao,         // Taobao Application Center
    as_leStore,         // Lenovo Le Store
    as_nearme,            // Nearme market
    as_coolmart,        // CoolPad market
    as_gioneestore,    // Gionee Application Store
    as_huawei,           // Huawei Application Store
    as_samsung,          // Samsung Store
    as_meizu,              // Meizu App Store
    as_vivo,           // Vivo App Store
    as_htcstore        // HTC Application Store
}AppStore;

typedef enum
{
    nm_none,
    nm_2G,
    nm_3G,
    nm_4G,
    nm_LTE,
    nm_Auto,
    nm_Wifi,
    nm_Wired
}NetworkModel;

typedef enum
{
    mp_Single,
    mp_Circle,
    mp_Random,
    mp_Order
}MusicPlayMode;

typedef enum
{
    bc_none,
    bc_BlockNormalPlay,
    bc_InitPlay,
    bc_Drag,
    bc_SwitchStation,
    bc_SwitchBitStream
}BufferCause;

typedef enum
{
    pt_none,
    pt_demand,
    pt_live,
    pt_carousels,
    pt_cache,
    pt_local
}PlayType;

typedef enum
{
    ut_none,
    ut_male,
    ut_female,
    ut_child
}UserType;

typedef enum  {
    flv_350,
    _3gp_320X240,
    flv_enp,
    chinafilm_350,
    flv_vip,
    flv_live,
    union_low,
    union_high,
    mp4_800,
    flv_1000,
    flv_1300,
    flv_720p,
    mp4_1080p,
    flv_1080p6m,
    mp4_350,
    mp4_1300,
    mp4_800_db,
    mp4_1300_db,
    mp4_720p_db,
    mp4_1080p6m_db,
    flv_yuanhua,
    mp4_yuanhua,
    flv_720p_3d,
    mp4_720p_3d,
    flv_1080p6m_3d,
    mp4_1080p6m_3d,
    flv_1080p_3d,
    mp4_1080p_3d,
    flv_1080p3m,
    flv_4k,
    flv_4k_265,
    flv_3m_3d,
    h265_flv_800,
    h265_flv_1300,
    h265_flv_720p,
    h265_flv_1080p,
    mp4_720p,
    mp4_1080p3m,
    mp4_1080p6m,
    mp4_4k,
    mp4_4k_15m,
    flv_180,
    mp4_180,
    mp4_4k_db,
    baseline_marlin,
    baseline_access,
    _180_marlin,
    _180_access,
    _350_marlin,
    _350_access,
    _800_marlin,
    _800_access,
    _1300_marlin,
    _1300_access,
    _720p_marlin,
    _720p_access,
    _1080p3m_marlin,
    _1080p3m_access,
    _1080p6m_marlin,
    _1080p6m_access,
    _1080p15m_marlin,
    _1080p15m_access,
    _4k_marlin,
    _4k_access,
    _4k15m_marlin,
    _4k15m_access,
    _4k30m_marlin,
    _4k30m_access,
    _800_db_marlin,
    _800_db_access,
    _1300_db_marlin,
    _1300_db_access,
    _720p_db_marlin,
    _720p_db_access,
    _1080p3m_db_marlin,
    _1080p3m_db_access,
    _1080p6m_db_marlin,
    _1080p6m_db_access,
    _1080p15m_db_marlin,
    _1080p15m_db_access,
    _4k_db_marlin,
    _4k_db_access,
    _4k15m_db_marlin,
    _4k15m_db_access,
    _4k30m_db_marlin,
    _4k30m_db_access,
    _720p_3d_marlin,
    _720p_3d_access,
    _1080p3m_3d_marlin,
    _1080p3m_3d_access,
    _1080p6m_3d_marlin,
    _1080p6m_3d_access,
    _1080p15m_3d_marlin,
    _1080p15m_3d_access,
    _4k_3d_marlin,
    _4k_3d_access,
    _4k15m_3d_marlin,
    _4k15m_3d_access,
    _4k30m_3d_marlin,
    _4k30m_3d_access,
    mp4_180_logo,
    mp4_350_logo,
    mp4_800_logo,
    mp4_180_h265,
    mp4_350_h265,
    mp4_800_h265,
    mp4_1300_h265,
    mp4_720p_h265,
    mp4_1080p3m_h265,
    mp4_1080p6m_h265,
    mp4_2k_h265,
    mp4_4k_m_h265,
    mp4_4k_h_h2h65
}StreamType;

typedef enum  {
    fc_none,
    fc_1,
    fc_2,
    fc_3,
    fc_4,
    fc_5,
    fc_6,
    fc_10,
    fc_11,
    fc_12,
    fc_13,
    fc_14,
    fc_15 ,
    fc_50,
    fc_51,
    fc_52,
    fc_53,
    fc_54,
    fc_100,
    fc_101,
    fc_102,
    fc_103,
    fc_104,
    fc_150,
    fc_151,
    fc_152,
    fc_153,
    fc_154,
    fc_200,
    fc_201,
    fc_420,
    fc_421,
    fc_422,
    fc_423,
    fc_429,
    fc_450,
    fc_451,
    fc_452,
    fc_453,
    fc_459,
    fc_460,
    fc_461,
    fc_462,
    fc_463,
    fc_469,
    fc_470,
    fc_471,
    fc_472,
    fc_473,
    fc_474,
    fc_479,
    fc_480,
    fc_481,
    fc_482,
    fc_483,
    fc_487,
    fc_488,
    fc_489,
    fc_540,
    fc_541,
    fc_542,
    fc_543,
    fc_549,
    fc_550,
    fc_551,
    fc_552,
    fc_553,
    fc_554,
    fc_555,
    fc_558,
    fc_559,
    fc_560,
    fc_561,
    fc_998,
    fc_999
}FailedCause;

typedef enum
{
    ps_auto,
    ps_manual
}PlayStart;

typedef enum
{
    hw_phone,
    hw_router
}HWType;

typedef enum
{
    os_Android,
    os_iOS
}OpSType;

typedef enum
{
    opr_CMCC,
    opr_CU
}Optor;

#endif
