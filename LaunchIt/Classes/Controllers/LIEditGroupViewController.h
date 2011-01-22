//
// LIEditApplicationViewController.h
// LaunchIt
//
// Created by Brian Cooke on 1/15/11.
// Copyright 2011 Made By Rocket, Inc.. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class Group;
@class SRRecorderControl;

@interface LIEditGroupViewController : NSViewController {
  Group *_group;

  SRRecorderControl *shortcutRecorderControl;
  NSInteger          shortcutCode;
  NSUInteger         shortcutFlags;
  NSButton *plusButton;
}

@property (nonatomic, retain) Group                      *group;
@property (nonatomic, retain) IBOutlet SRRecorderControl *shortcutRecorderControl;
@property (nonatomic, assign) NSInteger                   shortcutCode;
@property (nonatomic, assign) NSUInteger                  shortcutFlags;
@property (nonatomic, retain) IBOutlet NSButton *plusButton;

- (IBAction)plusButtonPushed:(id)sender;

@end
