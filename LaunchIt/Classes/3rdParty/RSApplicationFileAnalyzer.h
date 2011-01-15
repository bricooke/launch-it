//
//  RSApplicationFileAnalyzer.h
//  rooSwitch
//
//  Created by Brian Cooke on 3/25/06.
//  Copyright 2006 roobasoft, LLC. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#define RS_ANALYZER_TYPE_APPLICATION_SUPPORT    1
#define RS_ANALYZER_TYPE_PREFERENCE             2
#define RS_ANALYZER_TYPE_MISC                   3


@interface RSApplicationFileAnalyzer : NSObject 
{
    NSString *application;
}


- (id)          initWithApplication:(NSString *)app;

- (NSArray *)   applicationFiles;
- (NSString *)  bundleID;
- (NSString *)  iconPath;
- (BOOL)		isRooSwitchLiveEnabled;
- (BOOL)        isSystemPreference;
- (BOOL)        isValid;
- (NSString *)  name;
- (NSString *)  path;

@end
