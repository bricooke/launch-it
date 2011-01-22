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
}

@property (nonatomic, retain) Group                      *group;
@property (nonatomic, retain) IBOutlet SRRecorderControl *shortcutRecorderControl;
@property (nonatomic, retain) IBOutlet NSButton          *plusButton;
@property (nonatomic, retain) IBOutlet NSCollectionView  *collectionView;
@property (nonatomic, retain) IBOutlet NSView *containerView;
@property (nonatomic, assign) NSInteger                   shortcutCode;
@property (nonatomic, assign) NSUInteger                  shortcutFlags;

- (IBAction)plusButtonPushed:(id)sender;

@end
