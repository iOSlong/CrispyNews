//
//  CNDataSchema.h
//  CrispyNews
//
//  Created by xuewu.long on 16/8/12.
//  Copyright © 2016年 letv. All rights reserved.
//

#ifndef CNDataSchema_h
#define CNDataSchema_h



/// 数据库
#define k_DB_FILE_NAME           @"cnNews.sqlite"  // or  letvCN.db

/// 表
#define k_TABLE_NAME_CHANNEL        @"channel_list"


static NSString *tableNewsChannel    = @"newschannel_list";
static NSString *tableNewsFaves      = @"newsfaves_list";
static NSString *tableNewsDetail     = @"newsdetail_list";



static NSString *imgSepMark         = @"|-|";

// 存储主题选项
static NSString *const CNStoreThemeJson         = @"themeJson";
static NSString *const CNStoreThemeImage         = @"themeImage";
static NSString *const CNStoreThemeChannel       = @"themeChannel";
static NSString *const CNStoreThemeNewsDesc      = @"themeNewsDesc";
static NSString *const CNStoreThemeNewsDetail    = @"themeNewsDetail";
// 存储解析数据类型
static NSString *const CNStoreTypeJson           = @"typeJson";     //Data - > Json
static NSString *const CNStoreTypeText           = @"typeText";     //Data - > Text
static NSString *const CNStoreTypeImage          = @"typeImage";    //Data - > Image



/// 建表
#define k_SQL_CREATE_TABLE_CHANNEL  @"create table if not exists channel_list (order_id integer primary key autoincrement,ID text,channelState integer, sortLoc integer,chinaName text,englishName text, createBy text, createTime text, modiyBy text, modiyTime text,userId text)"


#define SQL_CREATETABLE_NEWS_CHANNEL @"create table if not exists newschannel_list (order_id integer primary key autoincrement, ID text, channel text, timerLoc integer, data blob)"
#define SQL_CREATETABLE_NEWS_FAVES   @"create table if not exists newsfaves_list (order_id integer primary key autoincrement, ID text, channel text, timerLoc integer, data blob)"
#define SQL_CREATETABLE_NEWS_DETAIL  @"create table if not exists newsdetail_list (order_id integer primary key autoincrement, ID text, channel text, timerLoc integer, data blob)"




/// 添加数据
#define k_SQL_INSERT_CHANNEL_FORMAT @"insert into channel_list (ID,channelState, sortLoc,chinaName,englishName, createBy,createTime,modiyBy,modiyTime,userId) values (?,?,?,?,?,?,?,?,?,?)"

#define k_SQL_INSERT_DATA_FORMAT    @"insert into data_list (theme, type, identifier, content) values (?,?,?,?)"

#define SQL_INSERT_NEWS_CHANNEL_FORMAT  @"insert into newschannel_list(ID, channel, timerLoc, data) values (?,?,?,?)"
#define SQL_INSERT_NEWS_FAVES_FORMAT    @"insert into newsfaves_list(ID, channel, timerLoc, data) values (?,?,?,?)"
#define SQL_INSERT_NEWS_DETAIL_FORMAT   @"insert into newsdetail_list(ID, channel, timerLoc, data) values (?,?,?,?)"




/// 删除
#define k_SQL_DELETE_CHANNEL_FORMAT             @"delete from channel_list where ID = ?"
#define k_SQL_CLEAR_STATEONCHANNEL_FORMAT       @"delete from channel_list where channel_list.channelState='1'"
#define k_SQL_CLEAR_STATEOFFCHANNEL_FORMAT      @"delete from channel_list where channel_list.channelState='0'"
#define k_SQL_CLEAR_CHANNEL_LIST_FORMAT         @"delete from channel_list"

#define SQL_DELETE_NEWSCHANNEL_BYCHANNEL_FORMAT @"delete from newschannel_list where channel = ?"
#define SQL_DELETE_NEWSFAVES_BYCHANNEL_FORMAT   @"delete from newsfaves_list where channel = ?"


#define SQL_CLEAR_NEWSFAVES_LIST            @"delete from newsfaves_list"
#define SQL_CLEAR_NEWSCHANNEL_LIST          @"delete from newschannel_list"
#define SQL_CLEAR_NEWSDETAIL_LIST           @"delete from newsdetail_list"




#define SQL_DELETE_NEWSCHANNEL_FORMAT           @"delete from newschannel_list where ID = ?"
#define SQL_DELETE_NEWSFAVES_FORMAT             @"delete from newsfaves_list where ID = ?"
#define SQL_DELETE_NEWSDETAIL_FORMAT            @"delete from newsdetail_list where ID = ?"


/// 查询
#define k_SQL_QUERY_CHANNEL_ASC_LISTALL_FORMAT   @"select * from channel_list order by sortLoc ASC"
#define k_SQL_QUERY_CHANNEL_DESC_LISTALL_FORMAT  @"select * from channel_list order by sortLoc DESC"
#define k_SQL_QUERY_CHANNEL_ASC_STATE_ON_LISTALL_FORMAT @"select * from channel_list where channel_list.channelState='1' order by sortLoc ASC"
#define k_SQL_QUERY_CHANNEL_DESC_STATEON_ON_LISTALL_FORMAT @"select * from channel_list where channel_list.channelState='0' order by sortLoc DESC"



#define SQL_QUERY_NEWSDETAIL_BYID_FROMAT        @"select * from newsdetail_list where ID = ?"











#endif /* CNDataSchema_h */
