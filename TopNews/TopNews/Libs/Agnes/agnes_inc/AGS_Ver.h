//
//  AGS_Ver.h
//  garfield
//
//  Created by wuqigang on 8/22/15.
//  Copyright (c) 2015 wuqigang. All rights reserved.
//

#ifndef garfield_AGS_Ver_h
#define garfield_AGS_Ver_h

#import <Foundation/Foundation.h>
//class Version
//{
//public:
//    int major;
//    int minor;
//    int patch;
//    string build;
//    string version;
//    
//    Version();
//    void setVersion(const int major, const int minor, const int patch);
//    void setVersion(const int major, const int minor, const int patch, const string build);
//    void setVersion(const string version);
//    string toString();
//    bool hasRequiredFields();
//    
//};

@interface AGS_Ver : NSObject

@property void *mpver;

-(void)setVersion:(int)major minor:(int)pmnr patch:(int)ptch;
-(void)setVersion:(int)major minor:(int)pmnr patch:(int)ptch build:(NSString*)pbld;
-(void)setVersion:(NSString *)version;
-(NSString*)toString;
-(bool)hasRequiredFields;
@end

#endif
