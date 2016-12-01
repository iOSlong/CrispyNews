//
//  AGS_Batch.h
//  garfield
//
//  Created by 林琳 on 16/9/21.
//  Copyright © 2016年 wuqigang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AGS_Event.h"

@interface AGS_Batch : NSObject

@property void *mbtc;

-(id)initBatch:(NSString*)appId rid:(NSString*)runId ver:(AGS_Ver*)pver;

-(long long)getTimestamp;
-(NSString*)getAppId;
-(NSString*)getAppRunId;
-(NSString*)getAppVersion;

-(void)addEvent:(AGS_Event*)evt;
-(int)getMsgLen;
-(int)getMsgNum;
@end
