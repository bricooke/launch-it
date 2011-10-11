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
  NSWindow *__unsafe_unretained window;
  LIWindowController *windowController;
  NSPersistentStoreCoordinator *persistentStoreCoordinator;
  NSManagedObjectModel *managedObjectModel;
  NSManagedObjectContext *managedObjectContext;
}

@property (unsafe_unretained) IBOutlet NSWindow *window;
@property (nonatomic, strong) IBOutlet LIWindowController *windowController;
@property (nonatomic, strong, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (nonatomic, strong, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, strong, readonly) NSManagedObjectContext *managedObjectContext;

+ (AppDelegate *)sharedAppDelegate;
- (IBAction)saveAction:sender;

@end
