//
//  AGS_Action.h
//  garfield
//
//  Created by wuqigang on 9/2/15.
//  Copyright (c) 2015 wuqigang. All rights reserved.
//

#ifndef garfield_AGS_Action_h
#define garfield_AGS_Action_h

#import <Foundation/Foundation.h>

@interface AGS_Action : NSObject
@property void* mpact;

-(id)initAct:(NSString*)pact;
-(long)getTime;
-(NSString*)getAction;
-(void)setDes:(NSString*)pdes;
-(NSString*)getDes;
-(void)addProp:(NSString*)pname propValue:(NSString*)pval;
@end

#endif
