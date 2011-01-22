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
#import "LIEditGroupViewController.h"
#import "MACollectionUtilities.h"
#import "LIMenubarView.h"
#import "Group.h"


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
  
  self.editGroupController = [[[LIEditGroupViewController alloc] initWithNibName:@"LIEditGroupView" bundle:nil] autorelease];
  
  [self.containerView setWantsLayer:YES];
  [[self.containerView layer] setOpaque:YES];
  [[self.containerView layer] setBackgroundColor:(CGColorRef)[NSColor colorWithPatternImage:[NSImage imageNamed:@"bg_middle.png"]]];
  
  [self.collectionView setBackgroundColors:[NSArray arrayWithObject:[NSColor colorWithPatternImage:[NSImage imageNamed:@"bg_middle.png"]]]];
  
  [self.collectionView setContent:[Group allSortedByName]];
  
  float width = 22.0;
  float height = [[NSStatusBar systemStatusBar] thickness];
  NSRect viewFrame = NSMakeRect(0, 0, width, height);
  self.statusItem = [[[NSStatusBar systemStatusBar] statusItemWithLength:width] retain];
  [self.statusItem setView:[[[LIMenubarView alloc] initWithFrame:viewFrame controller:self] autorelease]];
}


- (IBAction)addGroup:(id)sender
{
  Group *group = [Group createEntity];
  
  self.editGroupController.group = group;
  
  [self slideInEditView];  
}


- (void) editGroup:(Group *)aGroup
{
  self.editGroupController.group = aGroup;
  [self.editGroupController.group unbindHotkey];

  [self slideInEditView];
}


#pragma mark -
#pragma mark animations
- (void) setSaveAndCancelVisible:(BOOL)visible
{
  for (NSButton *but in ARRAY(self.cancelButton, self.saveButton, self.deleteButton)) {
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
  [self.editGroupController.view setFrame:NSOffsetRect(current, current.size.width, 0)];
  
  if ([self.editGroupController.view superview] == nil)
    [[[self window] contentView] addSubview:self.editGroupController.view];
  
  [[self.editGroupController.view animator] setFrame:current];

  [self setSaveAndCancelVisible:YES];
}


- (void) slideBackToMainView
{
  NSRect current = [self.containerView frame];
  [[self.containerView animator] setFrame:NSOffsetRect(current, current.size.width, 0)];
  [[self.editGroupController.view animator] setFrame:NSOffsetRect(current, current.size.width*2, 0)];

  [self setSaveAndCancelVisible:NO];
}


#pragma mark -
#pragma mark actions
- (IBAction)cancel:(id)sender
{
  [self.editGroupController.group willChangeValueForKey:@"shortcutCodeString"];
  [self.editGroupController.group willChangeValueForKey:@"shortcutCodeStringForMenus"];
  [self.editGroupController.group willChangeValueForKey:@"largeImage"];
  [self.editGroupController.group willChangeValueForKey:@"smallImage"];
  [[NSManagedObjectContext defaultContext] rollback];
  self.editGroupController.group.renderedImage = nil;
  [self.editGroupController.group didChangeValueForKey:@"smallImage"];
  [self.editGroupController.group didChangeValueForKey:@"largeImage"];
  [self.editGroupController.group didChangeValueForKey:@"shortcutCodeString"];
  [self.editGroupController.group didChangeValueForKey:@"shortcutCodeStringForMenus"];
  
  [self.editGroupController.group bindHotkey];

  [self slideBackToMainView];
}


- (IBAction)save:(id)sender
{
  [self.editGroupController.group bindHotkey];
  
  [[NSManagedObjectContext defaultContext] save];
  
  [self.collectionView setContent:[Group allSortedByName]];

  [self slideBackToMainView];  
}


- (IBAction)delete:(id)sender
{
  NSAlert *alert = [NSAlert alertWithMessageText:@"Are you sure you want to delete this shortcut?" defaultButton:@"Yes, delete it" alternateButton:@"Don't delete" otherButton:nil informativeTextWithFormat:[NSString stringWithFormat:@"Really delete the shortcut for %@?", self.editGroupController.group.name]];
  if ([alert runModal] == 1) {
    [self.editGroupController.group deleteEntity];
    [[NSManagedObjectContext defaultContext] save];  
    [self.collectionView setContent:[Group allSortedByName]];
    [self slideBackToMainView];
  }
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
@synthesize editGroupController;
@synthesize cancelButton;
@synthesize deleteButton;
@synthesize saveButton;
@synthesize addButton;
@synthesize settingsButton;
@synthesize statusItem;

@end
