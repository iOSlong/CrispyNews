//
//  AGS_Event.h
//  garfield
//
//  Created by wuqigang on 8/22/15.
//  Copyright (c) 2015 wuqigang. All rights reserved.
//

#ifndef garfield_AGS_Event_h
#define garfield_AGS_Event_h

#import <Foundation/Foundation.h>
#import "AGS_Ver.h"
#import "AGS_Enums.h"

@interface AGS_Event : NSObject
@property void *mpevt;

-(id)initEvent:(NSString*)appId rid:(NSString*)runId ver:(AGS_Ver*) pver evt:(EventEnum) eventtype;
-(id)initEvent:(NSString*)appId rid:(NSString*)runId ver:(AGS_Ver*) pver evtid:(NSString*) eventId;
-(id)initEvent:(NSString*)appId rid:(NSString*)runId ver:(AGS_Ver*) pver wid:(NSString*)pwid evt:(EventEnum) type;
-(id)initEvent:(NSString*)appId rid:(NSString*)runId ver:(AGS_Ver*) pver wid:(NSString*)wid evtid:(NSString*)eventId;

-(long long)getTimestamp;
-(NSString*)getId;
-(NSString*)getAppId;
-(NSString*)getAppRunId;
-(NSString*)getAppVersion;
-(NSString*)getWidgetId;
-(void)setPushId:(NSString*) pushId;
-(NSString*)getPushId;
-(void)setResult:(EventResult)res;
-(EventResult)getResult;
-(void)setOperationMethod:(Operation)op;
-(void)addPropwithStr:(NSString*)pname propVal:(NSString*)pval;
-(void)addPropwitEnum:(KeyEnum)pname propVal:(NSString*)pval;
-(NSMutableDictionary*)getProps;
@end

#endif
