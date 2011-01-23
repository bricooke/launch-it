#import "Application.h"
#import "SGHotKey.h"
#import "SGHotKeyCenter.h"
#import "RSApplicationFileAnalyzer.h"
#import <ShortcutRecorder/ShortcutRecorder.h>
#import "CoreData+ActiveRecordFetching.h"
#import "AppDelegate.h"
#import "LIWindowController.h"


@interface Application(private)
- (void) launch:(SGHotKey *)aHotKey;
- (NSImage *) appIconForSize:(NSSize)aSize;
@end


@implementation Application


- (NSImage *) largeImage
{
  if (self.name == nil) {
    return [NSImage imageNamed:@"icon_launchit.png"];
  }
  if (self.renderedImage == nil) {
    self.renderedImage = [[self appIconForSize:NSMakeSize(48, 48)] TIFFRepresentation];
  }
  return [[[NSImage alloc] initWithData:self.renderedImage] autorelease];
}


- (NSImage *) smallImage
{
  RSApplicationFileAnalyzer *analyzer = [[RSApplicationFileAnalyzer alloc] initWithApplication:self.path];
  NSImage *icon = [[NSImage alloc] initWithContentsOfFile:[analyzer iconPath]];
  [icon setSize:NSMakeSize(20,20)];
  [analyzer release];
  return [icon autorelease];
}


- (NSImage *) appIconForSize:(NSSize)aSize
{
  RSApplicationFileAnalyzer *analyzer = [[RSApplicationFileAnalyzer alloc] initWithApplication:self.path];
  NSImage *icon = [[NSImage alloc] initWithContentsOfFile:[analyzer iconPath]];
  
  NSImageRep *sourceImageRep = [icon bestRepresentationForRect:NSMakeRect(0, 0, aSize.width, aSize.height) context:nil hints:nil];
  NSImage *newImage = [[NSImage alloc] initWithSize:aSize];    
  [newImage setFlipped:NO];
  [newImage lockFocus];
  {
    [[NSGraphicsContext currentContext] setImageInterpolation: NSImageInterpolationHigh];
    [sourceImageRep drawInRect:NSMakeRect(0, 0, aSize.width, aSize.height)];
    // those numbers should match the numbers above
  }
  [newImage unlockFocus];
  
  [icon release];
  [analyzer release];  
  
  return [newImage autorelease];
}


//-------------------------------------------------
- (void) launch
{
  [self launch:nil];
}
- (void) launch:(SGHotKey *)aHotKey
{
  NSDictionary *active = [[NSWorkspace sharedWorkspace] activeApplication];
  
  NSString *script = nil;
  if (self.toggleValue && [[active valueForKey:@"NSApplicationPath"] isEqualToString:self.path]) {
    // hide it
    NSString *appName = [[self.path stringByDeletingPathExtension] lastPathComponent];
    script = [NSString stringWithFormat:@"tell application \"Finder\" to set visible of process \"%@\" to false", appName];
    NSDictionary *err = nil;
    [[[[NSAppleScript alloc] initWithSource:script] autorelease] executeAndReturnError:&err];  
  } else {
    [[NSWorkspace sharedWorkspace] launchApplication:self.path];
  }

  [self performSelector:@selector(backToBlackStatusItem) withObject:nil afterDelay:0.25];
}


- (BOOL) isWebsite
{
  return NO;
}


- (BOOL) isApplication
{
  return YES;
}



@end
