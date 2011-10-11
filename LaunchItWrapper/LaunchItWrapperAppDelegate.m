//
//  LIAppDelegate.m
//  Launch it!
//
//  Created by Brian Cooke on 10/11/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "LaunchItWrapperAppDelegate.h"
#import <ServiceManagement/SMLoginItem.h>


#define kLIHelperBundle (CFStringRef)@"com.madebyrocket.launchables-helper"

@implementation LaunchItWrapperAppDelegate

@synthesize window = _window;

+ (void) initialize
{
  [[NSUserDefaults standardUserDefaults] registerDefaults:
   [NSDictionary dictionaryWithObjectsAndKeys:
    [NSNumber numberWithBool:YES], @"LaunchItWrapperFirstLaunch",
    [NSNumber numberWithBool:NO], @"LaunchItWrapperStartOnLogin", nil]];
}


- (BOOL) helperIsRunning
{
  for (NSRunningApplication *app in [[NSWorkspace sharedWorkspace] runningApplications]) {    
    if ([[app bundleIdentifier] isEqualToString:@"com.madebyrocket.launchables-helper"]) {
      return YES;
    }
  }
  return NO;
}


- (void) killIfHelperIsntRunning:(NSTimer *)aTimer
{
  if ([self helperIsRunning] == NO)
    [NSApp terminate:self];
}


- (void) startWatchDog
{
  [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(killIfHelperIsntRunning:) userInfo:nil repeats:YES];
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
  NSBundle* b=[NSBundle mainBundle];
	NSString* p=[b bundlePath];
	NSURL* url=[NSURL fileURLWithPath:p];
  LSRegisterURL((__bridge CFURLRef)url,true); // this always fails...but it doesn't seem to matter.
  // now the helper
  p=[p stringByAppendingString:@"/Contents/Library/LoginItems/LaunchItHelper.app"];
	url=[NSURL fileURLWithPath:p];
  LSRegisterURL((__bridge CFURLRef)url,true);

	
  //
  // there's a problem:
  // if the helper was running on it's own, 
  // and the user quit it or it crashed
  // if we say SMLoginItemSetEnabled(true) it doesn't start it
  // 
  // toggling it like this does.
  //
  if ([self helperIsRunning] == NO) {
    SMLoginItemSetEnabled(kLIHelperBundle,false); 
    BOOL launched=SMLoginItemSetEnabled(kLIHelperBundle,true);
    if(!launched)
    {
      NSLog(@"FATAL ERROR: Unable to open LaunchItHelper, please report to launchit@madebyrocket.com");
    }
  }
    
  if ([[NSUserDefaults standardUserDefaults] boolForKey:@"LaunchItWrapperFirstLaunch"] == YES) {
    [self.window makeKeyAndOrderFront:self];
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"LaunchItWrapperFirstLaunch"];
  }
  
  // don't do this till at least 5 seconds have passed...to hopefully avoid a race condition.
  [self performSelector:@selector(startWatchDog) withObject:nil afterDelay:5];
}


- (BOOL)applicationShouldHandleReopen:(NSApplication *)theApplication hasVisibleWindows:(BOOL)flag
{
  if (flag == NO) {
    [self.window makeKeyAndOrderFront:self];
  }
  return YES;
}


- (void)applicationWillTerminate:(NSNotification *)notification
{
  if ([[NSUserDefaults standardUserDefaults] boolForKey:@"LaunchItWrapperStartOnLogin"] == NO) {
    // shut her down!
    SMLoginItemSetEnabled(kLIHelperBundle,false);
  }
}


- (IBAction)continue:(id)sender 
{
  [self.window orderOut:self];
}

@end
