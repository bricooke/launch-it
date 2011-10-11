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
  NSButton          *plusButton;
  NSCollectionView  *collectionView;
  NSView *containerView;
  NSTextField *nameField;
}

@property (nonatomic, strong) Group                      *group;
@property (nonatomic, strong) IBOutlet SRRecorderControl *shortcutRecorderControl;
@property (nonatomic, strong) IBOutlet NSButton          *plusButton;
@property (nonatomic, strong) IBOutlet NSCollectionView  *collectionView;
@property (nonatomic, strong) IBOutlet NSView *containerView;
@property (nonatomic, strong) IBOutlet NSTextField *nameField;
@property (nonatomic, assign) NSInteger                   shortcutCode;
@property (nonatomic, assign) NSUInteger                  shortcutFlags;

- (IBAction)plusButtonPushed:(id)sender;
- (IBAction)remove:(id)sender;

@end
