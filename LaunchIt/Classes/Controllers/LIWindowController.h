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
  NSMenu *settingsMenu;
  NSMenuItem *startOnLoginMenuItem;
}

@property (nonatomic, strong) IBOutlet NSCollectionView       *collectionView;
@property (nonatomic, strong) IBOutlet NSView                 *containerView;
@property (nonatomic, strong) LIEditGroupViewController *editGroupController;
@property (nonatomic, strong) IBOutlet NSButton               *cancelButton;
@property (nonatomic, strong) IBOutlet NSButton               *deleteButton;
@property (nonatomic, strong) IBOutlet NSButton               *saveButton;
@property (nonatomic, strong) IBOutlet NSButton *addButton;
@property (nonatomic, strong) IBOutlet NSButton *settingsButton;
@property (nonatomic, strong) IBOutlet NSMenu *settingsMenu;
@property (nonatomic, strong) IBOutlet NSMenuItem *startOnLoginMenuItem;
@property (nonatomic, strong) NSStatusItem *statusItem;

- (void)editGroup:(Group *)anApp;
- (IBAction)addGroup:(id)sender;
- (IBAction)cancel:(id)sender;
- (IBAction)save:(id)sender;
- (IBAction)settings:(id)sender;
- (IBAction)delete:(id)sender;
- (IBAction)about:(id)sender;
- (IBAction)setStartOnLogin:(id)sender;
- (IBAction)quit:(id)sender;
- (IBAction)faq:(id)sender;
- (IBAction)contact:(id)sender;
- (void)toggleWindowAtPoint:(NSPoint)pt makeVisible:(BOOL)visible;
- (BOOL)anyEntities;

@end
