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
  NSLog(@"%@", anApp);
  
  NSRect current = [self.containerView frame];
  [[self.containerView animator] setFrame:NSOffsetRect(current, -current.size.width, 0)];
  
  [self.editAppController.view setFrame:NSOffsetRect(current, current.size.width, 0)];

  if ([self.editAppController.view superview] == nil)
    [[[self window] contentView] addSubview:self.editAppController.view];
  
  [[self.editAppController.view animator] setFrame:current];
}


@synthesize collectionView, containerView;
@synthesize editAppController;
@synthesize cancelButton;
@synthesize saveButton;


@end
