//
//  AGS_MusicPlay.h
//  garfield
//
//  Created by wuqigang on 8/23/15.
//  Copyright (c) 2015 wuqigang. All rights reserved.
//

#ifndef garfield_AGS_MusicPlay_h
#define garfield_AGS_MusicPlay_h

#import <Foundation/Foundation.h>
#import "AGS_Enums.h"
#import "AGS_Ver.h"

@interface AGS_MusicPlay : NSObject
@property void* mpMusicPlay;

-(id)initMusicPlay:(NSString*)appId rid:(NSString*)runId ver:(AGS_Ver*)pver;
-(id)initMusicPlay:(NSString *)appId rid:(NSString *)runId ver:(AGS_Ver *)pver wid:(NSString*)widgetId;
-(NSString*)getAppVersion;
-(void)setPreMusic:(AGS_MusicPlay *)preMusicId;
-(void)setPlayMode:(MusicPlayMode) mode;
-(void)addPropwithStr:(NSString*)pname propVal:(NSString*)pval;
-(void)addPropwitEnum:(KeyEnum)pname propVal:(NSString*)pval;
-(void)launch;
-(void)startInit;
-(void)endInit;
-(void)startLoad;
-(void)endLoad;
-(void)startPlay;
-(void)switchBitStream:(NSString*)bitstream;
-(void)switchStation:(NSString*)stationId;
-(void)switchNetworkModel:(NetworkModel)pnw;
-(void)switchPlayMode:(MusicPlayMode) playMode;
-(void)moveTo:(int)prg pos:(int)moment;
-(void)beginBuffer:(int)prg cause:(BufferCause)pcs;
-(void)endBuffer;
-(void)cancel:(int)prg;
-(void)finish;
-(void)failed:(int)prg err:(NSString*)errMsg;
-(void)pause:(int)prg;
-(void)resume:(int)prg;
-(void)addAction:(int)prg name:(NSString*)pname duration:(int)pdur;
-(void)addAction:(int)prg name:(NSString *)pname duration:(int)pdur props:(NSMutableDictionary*)prps;
-(NSString*)getId;
-(NSString*)getAppId;
-(NSString*)getAppRunId;
-(NSMutableDictionary*)getProps;
-(NSMutableArray*)getActs;
-(long)getCurTime;

-(NSString*) getSongId;
-(void)setSongId:(NSString*)pid;

-(bool)getSongIdReported;

-(NSString*)getAlbumId;
-(void)setAlbumId:(NSString*)pid;

-(int)getMusicLength;
-(void)setMusicLength:(int)plen;

-(NSString*)getBitStream;
-(void)setBitStream:(NSString*)pbitStream;

-(NSString*)getFrom;
-(void)setFrom:(NSString*)pfrom;

-(NSString*)getStation;
-(void)setStation:(NSString*)ps;

-(NetworkModel)getNetworkModel;
-(void)setNetworkModel:(NetworkModel)pnw;

-(NSString*)getPreMusicId;

@end

#endif
