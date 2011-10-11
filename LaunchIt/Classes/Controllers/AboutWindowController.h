//
//  AboutWindowController.h
//  Launch it!
//
//  Created by Brian Cooke on 12/15/10.
//  Copyright 2010 Made By Rocket, Inc. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface AboutWindowController : NSWindowController {
  NSTextField *_versionLabel;
}

@property (nonatomic, strong) IBOutlet NSTextField *versionLabel;

+ (AboutWindowController *) sharedAboutWindowController;
- (IBAction) mbr:(id)sender;
@end
