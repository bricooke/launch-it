//
//  LIEditApplicationViewController.m
//  LaunchIt
//
//  Created by Brian Cooke on 1/15/11.
//  Copyright 2011 Made By Rocket, Inc.. All rights reserved.
//

#import "LIEditApplicationViewController.h"
#import <ShortcutRecorder/ShortcutRecorder.h>

@implementation LIEditApplicationViewController

- (void)dealloc {
  self.application = nil;
  [super dealloc];
}


@synthesize application=_application;
@synthesize shortcutCode, shortcutFlags, shortcutRecorderControl, applicationName, applicationPath;
@end
