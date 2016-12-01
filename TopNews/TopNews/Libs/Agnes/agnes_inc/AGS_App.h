//
//  AGS_App.h
//  garfield
//
//  Created by wuqigang on 8/23/15.
//  Copyright (c) 2015 wuqigang. All rights reserved.
//

#ifndef garfield_AGS_App_h
#define garfield_AGS_App_h

#import <Foundation/Foundation.h>
#import "AGS_Event.h"
#import "AGS_Widget.h"
#import "AGS_VideoPlay.h"
#import "AGS_MusicPlay.h"
#import "AGS_Ver.h"
#import "AGS_Enums.h"
#import "AGS_Batch.h"

@interface AGS_App : NSObject
@property void* mpapp;

-(id)initAppwithStr:(NSString*)pid;
-(id)initAppwithEnum:(AppEnum)appType;
-(id)initAppwithLeUI:(LeUIApp)leApp;
-(void)setSignedUserId:(NSString*)uid;
-(NSString*)getSignedUserId;

-(void)setAppStore:(AppStore)store;
-(NSString*)getAppStore;
-(void)setChannel:(NSString*)ch;
-(void)setStartFrom:(NSString*)from;
-(void)addPropwithStr:(NSString*)pname propVal:(NSString*)pval;

-(void)addPropwithEnum:(KeyEnum)pname propVal:(NSString*)pval;
-(void)addStatswithStr:(NSString*)pname propVal:(NSString*)pval;
-(void)addStatswithEnum:(KeyEnum)pname propVal:(NSString*)pval;

-(void)run;
-(void)ready;
-(void)deactive;
-(void)deactive:(NSString*)location;
-(void)exit;
-(void)exit:(NSString*)location;
-(void)login:(NSString*)username;
-(void)logout;

-(AGS_Event*)createEventwithEnum:(EventEnum)type;
-(AGS_Event*)createEventwithStr:(NSString*)type;
-(AGS_Widget*)createWidget:(NSString*)widgetId;
-(AGS_VideoPlay*)createVideoPlay;
-(AGS_MusicPlay*)createMusicPlay;
-(AGS_Batch*)createBatch;

-(NSMutableDictionary*)getProps;
-(NSMutableArray*)getActs;

-(long long)getCurTime;
-(NSString*)getId;
-(NSString*)getAppVersion;
-(NSString*)getRunId;
-(AGS_Ver*)getVersion;

-(bool)getUserHolder;
-(void)setUserHolder:(bool)puh;
-(bool)getStoreHolder;
-(void)setStoreHolder:(bool)psh;

@end

#endif
