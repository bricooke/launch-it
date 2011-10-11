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

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
  if ([[NSUserDefaults standardUserDefaults] boolForKey:@"LaunchItWrapperFirstLaunch"] == YES) {
    [self.window makeKeyAndOrderFront:self];
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"LaunchItWrapperFirstLaunch"];
  }
  NSBundle* b=[NSBundle mainBundle];
	NSString* p=[[b bundlePath] stringByAppendingString:@"/Contents/Library/LoginItems/LaunchItHelper.app"];
	NSURL* url=[NSURL fileURLWithPath:p];
  
  LSRegisterURL((__bridge CFURLRef)url,true); // this always fails...but it doesn't seem to matter.
	
	BOOL launched=SMLoginItemSetEnabled(kLIHelperBundle,true);
	if(!launched)
	{
		NSLog(@"FATAL ERROR: Unable to open LaunchItHelper, please report to launchit@madebyrocket.com");
	}
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
