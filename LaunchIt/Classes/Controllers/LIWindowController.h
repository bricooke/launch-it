//
// LIWindowController.h
// LaunchIt
//
// Created by Brian Cooke on 1/15/11.
// Copyright 2011 Made By Rocket, Inc.. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Group, LIEditGroupViewController;

@interface LIWindowController : NSWindowController {
  NSCollectionView                *collectionView;
  NSView                          *containerView;
  LIEditGroupViewController *editGroupController;
  NSButton                        *cancelButton;
  NSButton                        *deleteButton;
  NSButton                        *saveButton;
  NSButton *addButton;
  NSButton *settingsButton;
  NSStatusItem *statusItem;
}

@property (nonatomic, retain) IBOutlet NSCollectionView       *collectionView;
@property (nonatomic, retain) IBOutlet NSView                 *containerView;
@property (nonatomic, retain) LIEditGroupViewController *editGroupController;
@property (nonatomic, retain) IBOutlet NSButton               *cancelButton;
@property (nonatomic, retain) IBOutlet NSButton               *deleteButton;
@property (nonatomic, retain) IBOutlet NSButton               *saveButton;
@property (nonatomic, retain) IBOutlet NSButton *addButton;
@property (nonatomic, retain) IBOutlet NSButton *settingsButton;
@property (nonatomic, retain) NSStatusItem *statusItem;

- (void)editGroup:(Group *)anApp;
- (IBAction)addGroup:(id)sender;
- (IBAction)cancel:(id)sender;
- (IBAction)save:(id)sender;
- (IBAction)delete:(id)sender;
- (void)toggleWindowAtPoint:(NSPoint)pt makeVisible:(BOOL)visible;
- (BOOL)anyEntities;

@end
