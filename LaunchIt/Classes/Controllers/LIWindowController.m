//
// LIWindowController.m
// LaunchIt
//
// Created by Brian Cooke on 1/15/11.
// Copyright 2011 Made By Rocket, Inc.. All rights reserved.
//

#import "LIWindowController.h"
#import "Application.h"
#import "CoreData+ActiveRecordFetching.h"
#import "AppDelegate.h"
#import "LIEditApplicationViewController.h"
#import "MACollectionUtilities.h"
#import "LIMenubarView.h"

@interface LIWindowController(private)
- (void) slideInEditView;
- (void) slideBackToMainView;
@end


@implementation LIWindowController

- (void)dealloc {
  self.collectionView = nil;
  self.containerView = nil;

  [super dealloc];
}

- (void) awakeFromNib
{
  [NSManagedObjectContext setDefaultContext:[[AppDelegate sharedAppDelegate] managedObjectContext]];
  
  self.editAppController = [[[LIEditApplicationViewController alloc] initWithNibName:@"LIEditApplicationView" bundle:nil] autorelease];
  
  [self.containerView setWantsLayer:YES];
  [[self.containerView layer] setOpaque:YES];
  [[self.containerView layer] setBackgroundColor:(CGColorRef)[NSColor colorWithPatternImage:[NSImage imageNamed:@"bg_middle.png"]]];
  
  [self.collectionView setBackgroundColors:[NSArray arrayWithObject:[NSColor colorWithPatternImage:[NSImage imageNamed:@"bg_middle.png"]]]];
  
  [self.collectionView setContent:[Application findAll]];
  
  float width = 22.0;
  float height = [[NSStatusBar systemStatusBar] thickness];
  NSRect viewFrame = NSMakeRect(0, 0, width, height);
  self.statusItem = [[[NSStatusBar systemStatusBar] statusItemWithLength:width] retain];
  [self.statusItem setView:[[[LIMenubarView alloc] initWithFrame:viewFrame controller:self] autorelease]];
}


- (void) editApplication:(Application *)anApp
{
  self.editAppController.application = anApp;
  [self.editAppController.application unbindHotkey];

  [self slideInEditView];
}


#pragma mark -
#pragma mark animations
- (void) setSaveAndCancelVisible:(BOOL)visible
{
  for (NSButton *but in ARRAY(self.cancelButton, self.saveButton)) {
    [[but animator] setHidden:!visible];
  }
  
  for (NSButton *but in ARRAY(self.addButton, self.settingsButton)) {
    [[but animator] setHidden:visible];
  }
}


- (void) slideInEditView
{
  NSRect current = [self.containerView frame];
  [[self.containerView animator] setFrame:NSOffsetRect(current, -current.size.width, 0)];
  
  // make sure it's off screen, to the right.
  [self.editAppController.view setFrame:NSOffsetRect(current, current.size.width, 0)];
  
  if ([self.editAppController.view superview] == nil)
    [[[self window] contentView] addSubview:self.editAppController.view];
  
  [[self.editAppController.view animator] setFrame:current];

  [self setSaveAndCancelVisible:YES];
}


- (void) slideBackToMainView
{
  NSRect current = [self.containerView frame];
  [[self.containerView animator] setFrame:NSOffsetRect(current, current.size.width, 0)];
  [[self.editAppController.view animator] setFrame:NSOffsetRect(current, current.size.width*2, 0)];

  [self setSaveAndCancelVisible:NO];
}


#pragma mark -
#pragma mark actions
- (IBAction)cancel:(id)sender
{
  [self.editAppController.application willChangeValueForKey:@"shortcutCodeString"];
  [self.editAppController.application willChangeValueForKey:@"shortcutCodeStringForMenus"];
  [self.editAppController.application willChangeValueForKey:@"appIcon"];
  [self.editAppController.application willChangeValueForKey:@"smallAppIcon"];
  [[NSManagedObjectContext defaultContext] rollback];
  self.editAppController.application.renderedImage = nil;
  [self.editAppController.application didChangeValueForKey:@"appIcon"];
  [self.editAppController.application didChangeValueForKey:@"smallAppIcon"];
  [self.editAppController.application didChangeValueForKey:@"shortcutCodeString"];
  [self.editAppController.application didChangeValueForKey:@"shortcutCodeStringForMenus"];
  
  [self.editAppController.application bindHotkey];

  [self slideBackToMainView];
}


- (IBAction)save:(id)sender
{
  [self.editAppController.application bindHotkey];
  
  [[NSManagedObjectContext defaultContext] save];
  [self slideBackToMainView];  
}


- (void)toggleWindowAtPoint:(NSPoint)pt makeVisible:(BOOL)visible
{
  pt.x -= [self.window frame].size.width/2;
  pt.y -= [self.window frame].size.height;
  
  [self.window setFrameOrigin:pt];
  if (visible) {
    [NSApp activateIgnoringOtherApps:YES];
    [self.window makeKeyAndOrderFront:self];
  } else {
    [self.window orderOut:self];
  }
}



@synthesize collectionView, containerView;
@synthesize editAppController;
@synthesize cancelButton;
@synthesize saveButton;
@synthesize addButton;
@synthesize settingsButton;
@synthesize statusItem;

@end
