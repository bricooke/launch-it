//
//  Mlog.h
//  rooVid
//
//  Created by Brian Cooke on 1/18/06.
//  Copyright 2006 Made By Rocket, Inc.. All rights reserved.
//
// see http://www.borkware.com/rants/agentm/mlog/

#import <Cocoa/Cocoa.h>

#define MLog(s,...) \
    [MLogInner logFile:__FILE__ lineNumber:__LINE__ \
          format:(s),##__VA_ARGS__]


@interface MLogInner : NSObject 
{

}

+(void)logFile:(char*)sourceFile lineNumber:(int)lineNumber 
       format:(NSString*)format, ...;
+(void)setLogOn:(BOOL)logOn;


@end