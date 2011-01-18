//
//  AppDelegateDelegate.h
//  LaunchIt
//
//  Created by Brian Cooke on 1/15/11.
//  Copyright 2011 Made By Rocket, Inc.. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class LIWindowController;

@interface AppDelegate : NSObject <NSApplicationDelegate> {
  NSWindow *window;
  LIWindowController *windowController;
  NSPersistentStoreCoordinator *persistentStoreCoordinator;
  NSManagedObjectModel *managedObjectModel;
  NSManagedObjectContext *managedObjectContext;
}

@property (assign) IBOutlet NSWindow *window;
@property (nonatomic, retain) IBOutlet LIWindowController *windowController;
@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;

+ (AppDelegate *)sharedAppDelegate;
- (IBAction)saveAction:sender;

@end
