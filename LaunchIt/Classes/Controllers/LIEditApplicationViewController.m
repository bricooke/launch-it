//
//  LIEditApplicationViewController.m
//  LaunchIt
//
//  Created by Brian Cooke on 1/15/11.
//  Copyright 2011 Made By Rocket, Inc.. All rights reserved.
//

#import "LIEditApplicationViewController.h"
#import <ShortcutRecorder/ShortcutRecorder.h>
#import "RSApplicationFileAnalyzer.h"
#import "Application.h"


@interface LIEditApplicationViewController(private)
- (void) setFile:(NSString *)file;
@end


@implementation LIEditApplicationViewController

- (void)dealloc {
  self.application = nil;
  [super dealloc];
}


- (IBAction)chooseApplication:(id)sender
{
  NSMenu *runningAppsMenu = [[NSMenu alloc] initWithTitle:@"Running Applications"];
  
  // create menu items for each .app the workspace knows about
  NSArray *apps = [[NSWorkspace sharedWorkspace] launchedApplications];
  NSArrayController *appsController = [[NSArrayController alloc] initWithContent:apps];
  [appsController setSortDescriptors:[NSArray arrayWithObject:[[[NSSortDescriptor alloc] initWithKey:@"NSApplicationName" ascending:YES selector:@selector(caseInsensitiveCompare:)] autorelease]]];
  
  NSMenuItem *newMenu = [[NSMenuItem alloc] initWithTitle:@"Choose Application..." action:@selector(chooseApplicationFromFilesystem:) keyEquivalent:@""];
  [newMenu setTarget:self];
  [runningAppsMenu addItem:newMenu];
  [newMenu release];
  
  [runningAppsMenu addItem:[NSMenuItem separatorItem]];
  
  for (NSDictionary *appInfo in [appsController arrangedObjects]) {
    newMenu = [[NSMenuItem alloc] initWithTitle:[appInfo valueForKey:@"NSApplicationName"] action:@selector(addApplicationFromMenu:) keyEquivalent:@""];
    NSImage *icon = [[NSWorkspace sharedWorkspace] iconForFile:[appInfo valueForKey:@"NSApplicationPath"]];
    [icon setScalesWhenResized:YES];
    [icon setSize:NSMakeSize(16,16)];
    
    [newMenu setImage:icon];
    [newMenu setRepresentedObject:appInfo];
    [newMenu setTarget:self];
    [newMenu setAction:@selector(chooseRunningApplication:)];
    
    [runningAppsMenu addItem:newMenu];
    
    [newMenu release];
  }
  
  [appsController release];
  
  NSRect frame = [self.chooseApplicationButton frame];
  NSPoint menuOrigin = [[self.chooseApplicationButton superview] convertPoint:NSMakePoint(frame.origin.x, frame.origin.y+frame.size.height+40)
                                                                       toView:nil];
  
  NSEvent *event =  [NSEvent mouseEventWithType:NSLeftMouseDown
                                       location:menuOrigin
                                  modifierFlags:NSLeftMouseDownMask // 0x100
                                      timestamp:0
                                   windowNumber:[[self.chooseApplicationButton window] windowNumber]
                                        context:[[self.chooseApplicationButton window] graphicsContext]
                                    eventNumber:0
                                     clickCount:1
                                       pressure:1];
  
  [NSMenu popUpContextMenu:runningAppsMenu withEvent:event forView:self.chooseApplicationButton];
  
  [runningAppsMenu release];
}


- (void) chooseRunningApplication:(id)sender
{
  [self setFile:[[sender representedObject] valueForKey:@"NSApplicationPath"]];
}



- (void) chooseApplicationFromFilesystem:(id)sender
{
  NSOpenPanel *panel = [NSOpenPanel openPanel];
  [panel setCanChooseFiles:YES];
  [panel setCanChooseDirectories:NO];
  [panel setCanCreateDirectories:NO];
  [panel setAllowsMultipleSelection:NO];
  
  [panel beginSheetForDirectory:@"/Applications" 
                           file:nil 
                          types:[NSArray arrayWithObject:@"app"] 
                 modalForWindow:[[self view] window] 
                  modalDelegate:self 
                 didEndSelector:@selector(didChooseApplication:returnCode:contextInfo:)
                    contextInfo:nil];    
}


- (void) didChooseApplication:(NSOpenPanel *)panel returnCode:(NSInteger)returnCode contextInfo:(void *)contextInfo
{
  [self setFile:[[panel filenames] objectAtIndex:0]];
}



- (void) setFile:(NSString *)aFile
{
  RSApplicationFileAnalyzer *analyzer = [[RSApplicationFileAnalyzer alloc] initWithApplication:aFile];

  [self.application willChangeValueForKey:@"smallAppIcon"];
  [self.application willChangeValueForKey:@"appIcon"];
  self.application.renderedImage = nil;
  self.application.name = [analyzer name];
  self.application.path = [analyzer path];
  [self.application didChangeValueForKey:@"appIcon"];
  [self.application didChangeValueForKey:@"smallAppIcon"];
  
  [analyzer release];  
}


@synthesize application=_application;
@synthesize shortcutCode, shortcutFlags, shortcutRecorderControl, applicationName, applicationPath, chooseApplicationButton;
@end
