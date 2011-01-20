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

+ (void) bindAllHotkeys
{
  for (Application *app in [Application findAll]) {
    [app unbindHotkey];
    [app bindHotkey];
  }  
}


- (IBAction) edit:(id)sender
{
  [[AppDelegate sharedAppDelegate].windowController editApplication:self];
}

- (NSImage *) appIcon
{
  if (self.name == nil) {
    return [NSImage imageNamed:@"icon_launchit.png"];
  }
  if (self.renderedImage == nil) {
    self.renderedImage = [[self appIconForSize:NSMakeSize(48, 48)] TIFFRepresentation];
  }
  return [[[NSImage alloc] initWithData:self.renderedImage] autorelease];
}


- (NSImage *) smallAppIcon
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


- (NSString *) shortcutCodeStringForMenus
{
  SRRecorderControl *shortcutRecorder = [[SRRecorderControl alloc] init];
  SGKeyCombo *combo = [SGKeyCombo keyComboWithKeyCode:[self shortcutCodeValue] modifiers:[shortcutRecorder cocoaToCarbonFlags:[self shortcutFlagsValue]]];
  [shortcutRecorder release];
  
  NSString *code = [combo keyCodeString];

  unichar ch[4];  
  if ([code isEqualToString:@"F1"]) {
    ch[0] = NSF1FunctionKey;
  } else if ([code isEqualToString:@"F2"]) {
    ch[0] = NSF2FunctionKey;
  } else if ([code isEqualToString:@"F3"]) {
    ch[0] = NSF3FunctionKey;
  } else if ([code isEqualToString:@"F4"]) {
    ch[0] = NSF4FunctionKey;
  } else if ([code isEqualToString:@"F5"]) {
    ch[0] = NSF5FunctionKey;
  } else if ([code isEqualToString:@"F6"]) {
    ch[0] = NSF6FunctionKey;
  } else if ([code isEqualToString:@"F7"]) {
    ch[0] = NSF7FunctionKey;
  } else if ([code isEqualToString:@"F8"]) {
    ch[0] = NSF8FunctionKey;
  } else if ([code isEqualToString:@"F9"]) {
    ch[0] = NSF9FunctionKey;
  } else if ([code isEqualToString:@"F10"]) {
    ch[0] = NSF10FunctionKey;
  } else if ([code isEqualToString:@"F11"]) {
    ch[0] = NSF11FunctionKey;
  } else if ([code isEqualToString:@"F12"]) {
    ch[0] = NSF12FunctionKey;
  } else if ([code isEqualToString:@"F13"]) {
    ch[0] = NSF13FunctionKey;
  } else if ([code isEqualToString:@"F14"]) {
    ch[0] = NSF14FunctionKey;
  } else if ([code isEqualToString:@"F15"]) {
    ch[0] = NSF15FunctionKey;
  } else if ([code isEqualToString:@"F16"]) {
    ch[0] = NSF16FunctionKey;
  } else if ([code isEqualToString:@"F17"]) {
    ch[0] = NSF17FunctionKey;
  } else if ([code isEqualToString:@"F18"]) {
    ch[0] = NSF18FunctionKey;
  } else if ([code isEqualToString:@"F19"]) {
    ch[0] = NSF19FunctionKey;
  } else {
    return code;
  }
  
  NSString *ret = [NSString stringWithCharacters:ch length:1];
  NSLog(@"%@", ret);
  return ret;
}


- (NSString *) shortcutCodeString
{
  return SRStringForCocoaModifierFlagsAndKeyCode([self shortcutFlagsValue], [self shortcutCodeValue]);
}

- (NSUInteger) modifierMask
{
  SRRecorderControl *shortcutRecorder = [[SRRecorderControl alloc] init];
  SGKeyCombo *combo = [SGKeyCombo keyComboWithKeyCode:[self shortcutCodeValue] modifiers:[shortcutRecorder cocoaToCarbonFlags:[self shortcutFlagsValue]]];
  [shortcutRecorder release];
  return [combo modifierMask];
}


- (SGHotKey *) hotkey
{
  if (_hotkey)
    return _hotkey;
  
  SRRecorderControl *shortcutRecorder = [[SRRecorderControl alloc] init];
  _hotkey = [[SGHotKey alloc] initWithIdentifier:self.path keyCombo:[SGKeyCombo keyComboWithKeyCode:[self shortcutCodeValue] modifiers:[shortcutRecorder cocoaToCarbonFlags:[self shortcutFlagsValue]]]];
  
  [shortcutRecorder release];
  
  [_hotkey setTarget: self];
  [_hotkey setAction: @selector(launch:)];
  
  return _hotkey;
}

- (void) bindHotkey
{
  [[SGHotKeyCenter sharedCenter] registerHotKey:[self hotkey]];
}

- (void) bindHotkeyTo:(id)delegate action:(SEL)selector
{
  SGHotKey *hotkey = [self hotkey];
  [hotkey setTarget:delegate];
  [hotkey setAction:selector];
  [[SGHotKeyCenter sharedCenter] registerHotKey:hotkey];
}

- (void) unbindHotkey
{
  [[SGHotKeyCenter sharedCenter] unregisterHotKey:[self hotkey]];
  _hotkey = nil;
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
    // TODO: Put back the flames.
    // [[[NSApp delegate] menuBarController].statusItem setImage:[NSImage imageNamed:@"menubar_flames.png"]];
    [[NSWorkspace sharedWorkspace] launchApplication:self.path];
  }

  [self performSelector:@selector(backToBlackStatusItem) withObject:nil afterDelay:0.25];
}


- (void) backToBlackStatusItem
{
  // TODO: Put back the flames
  // [[[NSApp delegate] menuBarController].statusItem setImage:[NSImage imageNamed:@"menubar_bw.png"]];
}



@synthesize hotkey = _hotkey;
@end
