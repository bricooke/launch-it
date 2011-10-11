//
//  Mlog.m
//  rooVid
//
//  Created by Brian Cooke on 1/18/06.
//  Copyright 2006 Made By Rocket, Inc.. All rights reserved.
//

#import "MLog.h"

#ifdef DEBUG
static BOOL __MLogOn=YES;
#else
static BOOL __MLogOn=NO;
#endif
@implementation MLogInner

//----------------------------------------------------------
+(void)initialize
{
    char * env=getenv("MLogOn");
    
    if( env == NULL ) return;
    
    if(strcmp(env,"NO")!=0)
        __MLogOn=YES;
}


//----------------------------------------------------------
+(void)logFile:(char*)sourceFile lineNumber:(int)lineNumber format:(NSString*)format, ...;
{
        va_list ap;
        NSString *print,*file;
        if(__MLogOn==NO)
                return;
        va_start(ap,format);
        file=[[NSString alloc] initWithBytes:sourceFile 
                  length:strlen(sourceFile) 
                  encoding:NSUTF8StringEncoding];
        print=[[NSString alloc] initWithFormat:format arguments:ap];
        va_end(ap);
        //NSLog handles synchronization issues
        NSLog(@"%s:%d %@",[[file lastPathComponent] UTF8String],
              lineNumber,print);
        
        return;
}


//----------------------------------------------------------
+(void)setLogOn:(BOOL)logOn
{
        __MLogOn=logOn;
}



@end
