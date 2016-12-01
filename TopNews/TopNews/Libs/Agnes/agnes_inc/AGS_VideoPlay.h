//
//  AGS_VideoPlay.h
//  garfield
//
//  Created by wuqigang on 8/23/15.
//  Copyright (c) 2015 wuqigang. All rights reserved.
//

#ifndef garfield_AGS_VideoPlay_h
#define garfield_AGS_VideoPlay_h

#import <Foundation/Foundation.h>
#import "AGS_Ver.h"
#include "AGS_Enums.h"

@interface AGS_VideoPlay : NSObject
@property void *mpvideoplay;

-(id)initVideoPlay:(NSString*)appId rid:(NSString*)runId ver:(AGS_Ver*)pver;
-(id)initVideoPlay:(NSString *)appId rid:(NSString *)runId ver:(AGS_Ver *)pver wid:(NSString*)pwid;
-(NSString*)getAppVersion;
-(void)setBitStreamwithType:(StreamType)stream;
-(void)setBitStreamwithStr:(NSString*)stream;
-(NSString*)getType;
-(void)addPropwithStr:(NSString*)pname propVal:(NSString*)pval;
-(void)addPropwithEnum:(KeyEnum)pname propVal:(NSString*)pval;
-(NSString*)getUserType;
-(NSString*)getNetworkModel;
-(void)launch;
-(void)startInit;
-(void)midstartInit;
-(void)endInit;
-(void)startUserCenter;
-(void)endUserCenter;
-(void)startTheatreChain;
-(void)endTheatreChain;
-(void)startAD;
-(void)endAD;
-(void)startMediaSource;
-(void)endMediaSource;
-(void)startGslb;
-(void)endGslb;
-(void)startCload;
-(void)endCload;
-(void)startPlay:(PlayStart)ps;
-(void)midPlay:(int)prg with:(PlayStart)startType;
-(void)switchBitStreamwithType:(StreamType)bitStream;
-(void)switchBitStreamwithStr:(NSString*)bitStream;
-(void)switchStation:(NSString*)stationId;
-(void)switchNetworkModel:(NetworkModel)networkModdel;
-(void)sendHeartbeat:(int)prg interval:(int)pitv;
-(void)moveTo:(int)from to:(int)pto opr:(Operation)op;
-(void)beginBuffer:(int)prg cause:(BufferCause)pcause;
-(void)endBuffer;
-(void)cancel:(int)prg;
-(void)finish;
-(void)failedwithCause:(int)prg cause:(FailedCause)pcause;
-(void)failedwithStr:(int)prg casue:(NSString*)pcause;
-(void)failedwithCauseErr:(int)prg cause:(FailedCause)pcause errMsg:(NSString*)perrMsg;
-(void)failedwithStrErr:(int)prg cause:(NSString*)pcause errMsg:(NSString*)perrMsg;
-(void)pause:(int)prg;
-(void)resume:(int)prg;
-(void)addAction:(int)prg acName:(NSString*)pacName duartion:(int)pdur;
-(void)addAction:(int)prg acName:(NSString*)pacName duration:(int)pdur props:(NSMutableDictionary*)prps;
-(void)startPhase:(NSString*)phaseName;
-(void)endPhase:(NSString*)phaseName;

-(NSMutableArray*)getActs;
-(NSMutableDictionary*)getProps;
-(long long)getCurTime;
-(NSString*)getId;
-(NSString*)getWidgetId;
-(NSString*)getAppRunId;
-(NSString*)getAppId;

-(NSString*)getVideoId;
-(void)setVideoId:(NSString*)pid;

-(int)getVideoLength;
-(void)setVideoLength:(int)plen;

-(NSString*)getUrl;
-(void)setUrl:(NSString*)purl;

-(NSString*)getFrom;
-(void)setFrom:(NSString*)pfrom;

-(NSString*)getPlayerVersion;
-(void)setPlayerVersion:(NSString*)pver;

-(NSString*)getStation;
-(void)setStation:(NSString*) pst;

-(NSString*)getLiveId;
-(void)setLiveId:(NSString*)pid;

-(PlayType)getPlayType;
-(void)setPlayType:(PlayType)ptype;

-(NSString*)getBitStream;
-(void)setBitStream:(NSString*)pst;

-(void)setUserType:(UserType)put;

-(void)setNetworkModel:(NetworkModel)pnw;

-(NSString*)getCaller;
-(void)setCaller:(NSString*)pcaller;

//letv_base
-(void)setProductCode:(NSString*) pcode;
-(void)setAuid:(NSString*) pauid;
-(void)setChannelId:(NSString*) pcid;
-(void)setAlbumId:(NSString*) paid;
-(void)setSubjectId:(NSString*) psid;
-(void)setAdType:(NSString*) padtype;
-(void)setMemberType:(NSString*) pmtype;
-(void)setPayType:(NSString*) ptype;
-(void)setPush:(NSString*) ispush;
-(void)setCdeAppId:(NSString*) paid;
-(void)setCdeVersion:(NSString*) pver;
-(void)setInvokePlayType:(NSString*) ptype;


@end

#endif
