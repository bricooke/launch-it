//
// LIWindowController.m
// LaunchIt
//
// Created by Brian Cooke on 1/15/11.
// Copyright 2011 roobasoft, LLC. All rights reserved.
//

#import "LIWindowController.h"
#import "Application.h"
#import "CoreData+ActiveRecordFetching.h"
#import "AppDelegate.h"
#import "LIEditApplicationViewController.h"
#import "MACollectionUtilities.h"


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
}


- (void) editApplication:(Application *)anApp
{
  [self slideInEditView];
}


#pragma mark -
#pragma mark animations
- (void) slideInEditView
{
  NSRect current = [self.containerView frame];
  [[self.containerView animator] setFrame:NSOffsetRect(current, -current.size.width, 0)];
  
  // make sure it's off screen, to the right.
  [self.editAppController.view setFrame:NSOffsetRect(current, current.size.width, 0)];
  
  if ([self.editAppController.view superview] == nil)
    [[[self window] contentView] addSubview:self.editAppController.view];
  
  [[self.editAppController.view animator] setFrame:current];

  for (NSButton *but in ARRAY(self.cancelButton, self.saveButton)) {
    [[but animator] setHidden:NO];
  }
  
  for (NSButton *but in ARRAY(self.addButton, self.settingsButton)) {
    [[but animator] setHidden:YES];
  }
}


- (void) slideBackToMainView
{
  NSRect current = [self.containerView frame];
  [[self.containerView animator] setFrame:NSOffsetRect(current, current.size.width, 0)];
  [[self.editAppController.view animator] setFrame:NSOffsetRect(current, current.size.width*2, 0)];
  
  for (NSButton *but in ARRAY(self.cancelButton, self.saveButton)) {
    [[but animator] setHidden:YES];
  }
  
  for (NSButton *but in ARRAY(self.addButton, self.settingsButton)) {
    [[but animator] setHidden:NO];
  }
}


#pragma mark -
#pragma mark actions
- (IBAction)cancel:(id)sender
{
  [self slideBackToMainView];
}


- (IBAction)save:(id)sender
{
  [self slideBackToMainView];  
}


@synthesize collectionView, containerView;
@synthesize editAppController;
@synthesize cancelButton;
@synthesize saveButton;
@synthesize addButton;
@synthesize settingsButton;

@end
