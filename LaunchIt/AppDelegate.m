//
// AppDelegateDelegate.m
// LaunchIt
//
// Created by Brian Cooke on 1/15/11.
// Copyright 2011 Made By Rocket, Inc.. All rights reserved.
//

#import "AppDelegate.h"
#import "Group.h"
#import "CoreData+ActiveRecordFetching.h"
#import "LIConstants.h"
#import <ServiceManagement/SMLoginItem.h>
#import "LIWindowController.h"


@implementation AppDelegate

@synthesize window, windowController;


+ (AppDelegate *)sharedAppDelegate
{
  return (AppDelegate *)[NSApp delegate];
}


+ (void) initialize
{
  [super initialize];
  [[NSUserDefaults standardUserDefaults] registerDefaults:[NSDictionary dictionaryWithObjectsAndKeys:
                                                           [NSNumber numberWithBool:YES],
                                                           kLISettingFirstLaunch,
                                                           [NSNumber numberWithBool:YES],
                                                           kLISettingShowInMenubar,
                                                           nil]];
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
  [NSManagedObjectContext setDefaultContext:[self managedObjectContext]];
  [Group migrateExistingApplications];
  [Group bindAllHotkeys];
  
  [self.window setCollectionBehavior: NSWindowCollectionBehaviorCanJoinAllSpaces];
}



// this takes the NSPersistentStoreDidImportUbiquitousContentChangesNotification
// and transforms the userInfo dictionary into something that
// -[NSManagedObjectContext mergeChangesFromContextDidSaveNotification:] can consume
// then it posts a custom notification to let detail views know they might want to refresh.
// The main list view doesn't need that custom notification because the NSFetchedResultsController is
// already listening directly to the NSManagedObjectContext
- (void)mergeiCloudChanges:(NSDictionary*)noteInfo forContext:(NSManagedObjectContext*)moc {

  NSMutableDictionary *localUserInfo = [NSMutableDictionary dictionary];
  NSSet* allInvalidations = [noteInfo objectForKey:NSInvalidatedAllObjectsKey];
  
  if (nil == allInvalidations) {
    // (1) we always materialize deletions to ensure delete propagation happens correctly, especially with 
    // more complex scenarios like merge conflicts and undo.  Without this, future echoes may 
    // erroreously resurrect objects and cause dangling foreign keys
    // (2) we always materialize insertions to make new entries visible to the UI
    NSString* materializeKeys[] = { NSDeletedObjectsKey, NSInsertedObjectsKey };
    int c = (sizeof(materializeKeys) / sizeof(NSString*));
    for (int i = 0; i < c; i++) {
      NSSet* set = [noteInfo objectForKey:materializeKeys[i]];
      if ([set count] > 0) {
        NSMutableSet* objectSet = [NSMutableSet set];
        for (NSManagedObjectID* moid in set) {
          [objectSet addObject:[moc objectWithID:moid]];
        }
        [localUserInfo setObject:objectSet forKey:materializeKeys[i]];
      }
    }
    
    // (3) we do not materialize updates to objects we are not currently using
    // (4) we do not materialize refreshes to objects we are not currently using
    // (5) we do not materialize invalidations to objects we are not currently using
    NSString* noMaterializeKeys[] = { NSUpdatedObjectsKey, NSRefreshedObjectsKey, NSInvalidatedObjectsKey };
    c = (sizeof(noMaterializeKeys) / sizeof(NSString*));
    for (int i = 0; i < 2; i++) {
      NSSet* set = [noteInfo objectForKey:noMaterializeKeys[i]];
      if ([set count] > 0) {
        NSMutableSet* objectSet = [NSMutableSet set];
        for (NSManagedObjectID* moid in set) {
          NSManagedObject* realObj = [moc objectRegisteredForID:moid];
          if (realObj) {
            [objectSet addObject:realObj];
          }
        }
        [localUserInfo setObject:objectSet forKey:noMaterializeKeys[i]];
      }
    }
    
    NSNotification *fakeSave = [NSNotification notificationWithName:NSManagedObjectContextDidSaveNotification object:self  userInfo:localUserInfo];
    [moc mergeChangesFromContextDidSaveNotification:fakeSave]; 
    
  } else {
    [localUserInfo setObject:allInvalidations forKey:NSInvalidatedAllObjectsKey];
  }
  
  [self.windowController willChangeValueForKey:@"anyEntities"];

  [moc processPendingChanges];
  
  [self.windowController didChangeValueForKey:@"anyEntities"];
  [self.windowController.collectionView setContent:[Group allSortedByName]];
  
  NSLog(@"Synced with iCloud - should be displaying: %ld items", [[Group allSortedByName] count]);
}




// NSNotifications are posted synchronously on the caller's thread
// make sure to vector this back to the thread we want, in this case
// the main thread for our views & controller
- (void)mergeChangesFrom_iCloud:(NSNotification *)notification {
  NSDictionary* ui = [notification userInfo];
	NSManagedObjectContext* moc = [self managedObjectContext];
  
  dispatch_async(dispatch_get_main_queue(), ^{
    [self mergeiCloudChanges:ui forContext:moc];
  });
}




/**
 *   Returns the support directory for the application, used to store the Core Data store file.  This code uses a directory named "LaunchIt" for the content, either in the NSApplicationSupportDirectory location or (if the former cannot be found), the system's temporary directory.
 */
- (NSString *)applicationSupportDirectory {
  NSArray  *paths    = NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES);
  NSString *basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : NSTemporaryDirectory();

  return [basePath stringByAppendingPathComponent:@"Launch it!"];
}


/**
 *   Creates, retains, and returns the managed object model for the application by merging all of the models found in the application bundle.
 */
- (NSManagedObjectModel *)managedObjectModel {
  if (managedObjectModel) {
    return managedObjectModel;
  }

  NSString *path   = [[NSBundle mainBundle] pathForResource:@"LaunchIt" ofType:@"momd"];
  NSURL    *momURL = [NSURL fileURLWithPath:path];
  managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:momURL];

  return managedObjectModel;
}


/**
 *   Returns the persistent store coordinator for the application.  This implementation will create and return a coordinator, having added the store for the application to it.  (The directory for the store is created, if necessary.)
 */
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
  if (persistentStoreCoordinator) {
    return persistentStoreCoordinator;
  }

  NSManagedObjectModel *mom = [self managedObjectModel];

  if (!mom) {
    NSAssert(NO, @"Managed object model is nil");
    NSLog(@"%@:psc No model to generate a store from", [self class]);
    return nil;
  }

  NSFileManager *fileManager                 = [NSFileManager defaultManager];
  NSString      *applicationSupportDirectory = [self applicationSupportDirectory];
  NSError       *error                       = nil;

  if ( ![fileManager fileExistsAtPath:applicationSupportDirectory isDirectory:NULL] ) {
    if (![fileManager createDirectoryAtPath:applicationSupportDirectory withIntermediateDirectories:NO attributes:nil error:&error]) {
      NSAssert(NO, ([NSString stringWithFormat:@"Failed to create App Support directory %@ : %@", applicationSupportDirectory, error]));
      NSLog(@"Error creating application support directory at %@ : %@", applicationSupportDirectory, error);
      return nil;
    }
  }

  NSURL *url = [NSURL fileURLWithPath:[applicationSupportDirectory stringByAppendingPathComponent:@"launchables.sqlite3"]];
  persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:mom];

  
  // iCloud
  // do this asynchronously since if this is the first time this particular device is syncing with preexisting
  // iCloud content it may take a long long time to download
  dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSURL *storeUrl = url;
    // this needs to match the entitlements and provisioning profile
    NSURL *cloudURL = [fileManager URLForUbiquityContainerIdentifier:nil];
    NSString* coreDataCloudContent = [[cloudURL path] stringByAppendingPathComponent:@"launchit"];
    cloudURL = [NSURL fileURLWithPath:coreDataCloudContent];
    
    //  The API to turn on Core Data iCloud support here.
    NSDictionary* options = [NSDictionary dictionaryWithObjectsAndKeys:
                             @"com.madebyrocket.launchables-helper.1", NSPersistentStoreUbiquitousContentNameKey, 
                             cloudURL, NSPersistentStoreUbiquitousContentURLKey, 
                             [NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption,
                             [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption,nil];
    
    NSError *error = nil;    
    NSPersistentStoreCoordinator *psc = persistentStoreCoordinator;    
    [psc lock];
    [self.windowController willChangeValueForKey:@"anyEntities"];

    if (![psc addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeUrl options:options error:&error]) {
      [[NSApplication sharedApplication] presentError:error];
    } 
    [self.windowController didChangeValueForKey:@"anyEntities"];
    [self.windowController.collectionView setContent:[Group allSortedByName]];
    [psc unlock];
  });

  return persistentStoreCoordinator;
}


/**
 *   Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
 */
- (NSManagedObjectContext *)managedObjectContext {
  if (managedObjectContext) {
    return managedObjectContext;
  }

  NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];

  if (!coordinator) {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:@"Failed to initialize the store" forKey:NSLocalizedDescriptionKey];
    [dict setValue:@"There was an error building up the data file." forKey:NSLocalizedFailureReasonErrorKey];
    NSError *error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
    [[NSApplication sharedApplication] presentError:error];
    return nil;
  }

  managedObjectContext = [[NSManagedObjectContext alloc] init];
  [managedObjectContext setPersistentStoreCoordinator:coordinator];

  [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(mergeChangesFrom_iCloud:) name:NSPersistentStoreDidImportUbiquitousContentChangesNotification object:coordinator];
  
  return managedObjectContext;
}


/**
 *   Returns the NSUndoManager for the application.  In this case, the manager
 *   returned is that of the managed object context for the application.
 */
- (NSUndoManager *)windowWillReturnUndoManager:(NSWindow *)window {
  return [[self managedObjectContext] undoManager];
}


/**
 *   Performs the save action for the application, which is to send the save:
 *   message to the application's managed object context.  Any encountered errors are presented to the user.
 */
- (IBAction)saveAction:(id)sender {
  NSError *error = nil;

  if (![[self managedObjectContext] commitEditing]) {
    NSLog(@"%@:%@ unable to commit editing before saving", [self class], NSStringFromSelector(_cmd));
  }

  if (![[self managedObjectContext] save:&error]) {
    [[NSApplication sharedApplication] presentError:error];
  }
}


/**
 *   Implementation of the applicationShouldTerminate: method, used here to handle the saving of changes in the application managed object context before the application terminates.
 */
- (NSApplicationTerminateReply)applicationShouldTerminate:(NSApplication *)sender {
  if (!managedObjectContext) {
    return NSTerminateNow;
  }

  if (![managedObjectContext commitEditing]) {
    NSLog(@"%@:%@ unable to commit editing to terminate", [self class], NSStringFromSelector(_cmd));
    return NSTerminateCancel;
  }

  if (![managedObjectContext hasChanges]) {
    return NSTerminateNow;
  }

//  NSError *error = nil;
//
//  if (![managedObjectContext save:&error]) {
//    // This error handling simply presents error information in a panel with an
//    // "Ok" button, which does not include any attempt at error recovery (meaning,
//    // attempting to fix the error.)  As a result, this implementation will
//    // present the information to the user and then follow up with a panel asking
//    // if the user wishes to "Quit Anyway", without saving the changes.
//
//    // Typically, this process should be altered to include application-specific
//    // recovery steps.
//
//    BOOL result = [sender presentError:error];
//
//    if (result) {
//      return NSTerminateCancel;
//    }
//
//    NSString *question     = NSLocalizedString(@"Could not save changes while quitting.  Quit anyway?", @"Quit without saves error question message");
//    NSString *info         = NSLocalizedString(@"Quitting now will lose any changes you have made since the last successful save", @"Quit without saves error question info");
//    NSString *quitButton   = NSLocalizedString(@"Quit anyway", @"Quit anyway button title");
//    NSString *cancelButton = NSLocalizedString(@"Cancel", @"Cancel button title");
//    NSAlert  *alert        = [[NSAlert alloc] init];
//    [alert setMessageText:question];
//    [alert setInformativeText:info];
//    [alert addButtonWithTitle:quitButton];
//    [alert addButtonWithTitle:cancelButton];
//
//    NSInteger answer = [alert runModal];
//    [alert release];
//    alert = nil;
//
//    if (answer == NSAlertAlternateReturn) {
//      return NSTerminateCancel;
//    }
//  }

  return NSTerminateNow;
}




@end
