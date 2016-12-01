//
//  AGS_Widget.h
//  garfield
//
//  Created by wuqigang on 8/23/15.
//  Copyright (c) 2015 wuqigang. All rights reserved.
//

#ifndef garfield_AGS_Widget_h
#define garfield_AGS_Widget_h

#import <Foundation/Foundation.h>
#import "AGS_Ver.h"
#import "AGS_Event.h"
#import "AGS_Enums.h"
#import "AGS_VideoPlay.h"
#import "AGS_MusicPlay.h"

@interface AGS_Widget : NSObject
@property void* mpwdt;

-(id)initWidget:(NSString*)appId rid:(NSString*)runId ver:(AGS_Ver*)pver wid:(NSString*)pwid;
-(NSString*)getId;
-(NSString*)getAppId;
-(NSString*)getAppVersion;
-(NSString*)getAppRunId;
-(long)getTimestamp;
-(void)addPropwithStr:(NSString*)pname propVal:(NSString*)pval;
-(void)addPropwitEnum:(KeyEnum)pname propVal:(NSString*)pval;
-(NSMutableDictionary*)getProps;

-(AGS_Event*)createEventwithEnum:(EventEnum) type;
-(AGS_Event*)createEventwitStr:(NSString*) type;

-(AGS_VideoPlay*)createVideoPlay;
-(AGS_MusicPlay*)createMusicPlay;

@end

#endif
