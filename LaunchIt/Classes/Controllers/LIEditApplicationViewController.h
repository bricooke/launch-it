//
//  LIEditApplicationViewController.h
//  LaunchIt
//
//  Created by Brian Cooke on 1/15/11.
//  Copyright 2011 Made By Rocket, Inc.. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class Application;
@class SRRecorderControl;

@interface LIEditApplicationViewController : NSViewController {
  Application *_application;
  
  SRRecorderControl          *shortcutRecorderControl;
  NSString                   *applicationName;
  NSString                   *applicationPath;
  NSInteger                   shortcutCode;
  NSUInteger                  shortcutFlags;  
}

@property (nonatomic, retain) Application *application;
@property (nonatomic, retain) IBOutlet SRRecorderControl *shortcutRecorderControl;
@property (nonatomic, retain) NSString                   *applicationName;
@property (nonatomic, retain) NSString                   *applicationPath;
@property (nonatomic, assign) NSInteger                   shortcutCode;
@property (nonatomic, assign) NSUInteger                  shortcutFlags;

@end
