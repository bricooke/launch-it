//
//  AboutWindowController.m
//  Launch it!
//
//  Created by Brian Cooke on 12/15/10.
//  Copyright 2010 Made By Rocket, Inc. All rights reserved.
//

#import "AboutWindowController.h"

static AboutWindowController *sharedAboutWindowController = nil;


@implementation AboutWindowController

+ (AboutWindowController *) sharedAboutWindowController
{
  if (sharedAboutWindowController)
    return sharedAboutWindowController;
  
  
  sharedAboutWindowController = [[self alloc] initWithWindowNibName:@"AboutWindow"];
	[sharedAboutWindowController window];
	return sharedAboutWindowController;
}


- (void) awakeFromNib
{
  [self.versionLabel setStringValue:[NSString stringWithFormat:@"Version %@", [[[NSBundle mainBundle] infoDictionary] valueForKey:@"CFBundleShortVersionString"]]];
}


- (IBAction) mbr:(id)sender
{
  [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:@"http://madebyrocket.com"]];
}


@synthesize versionLabel = _versionLabel;
@end
