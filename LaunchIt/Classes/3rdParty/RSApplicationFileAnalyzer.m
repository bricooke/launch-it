//
// RSApplicationFileAnalyzer.m
// testCCUnit
//
// Created by Brian Cooke on 3/25/06.
// Copyright 2006 roobasoft, LLC. All rights reserved.
//

#import "RSApplicationFileAnalyzer.h"
#import "MLog.h"

@interface RSApplicationFileAnalyzer (Private)

- (NSString *)applicationCacheFolder;
- (NSString *)applicationDefinedMappingFile;
- (NSString *)applicationSupportFolder;
- (NSString *)applicationLibraryFolder;
- (NSXMLDocument *)createXMLDocumentFromFile:(NSString *)file;
- (NSString *)plist;
- (NSString *)preferencesFile;

@end


@implementation RSApplicationFileAnalyzer


// ------------------------------------------------------------
- (id)initWithApplication:(NSString *)app
{
  if ((self = [super init]) == nil ) {
    return self;
  }

  if ( [[NSFileManager defaultManager] fileExistsAtPath:app] == NO ) {
    // bail
    application = nil;
    return self;
  }

  application = app;

  return self;
}


// ------------------------------------------------------------
- (NSArray *)applicationFiles
{
  if ( [self isValid] == NO ) {
    return nil;
  }

  //
  // see if the application is found in the users AppSupport/rooSwitch/CustomAppMappings.xml file
  //
  NSMutableArray *xmlFiles = [NSMutableArray array];
  NSArray        *paths    = NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES);

  if ( [self applicationDefinedMappingFile] ) {
    [xmlFiles addObject:[self applicationDefinedMappingFile]];
  }

  if ( [paths objectAtIndex:0] != nil ) {
    [xmlFiles addObject:[[paths objectAtIndex:0] stringByAppendingString:@"/rooSwitch/CustomAppMappings.xml"]];
  }


  [xmlFiles addObject:[[NSBundle mainBundle] pathForResource:@"CustomAppMappings" ofType:@"xml"]];

  NSEnumerator *walker = [xmlFiles objectEnumerator];
  NSString     *cur;

  while ((cur = [walker nextObject])) {
    if ( [[NSFileManager defaultManager] fileExistsAtPath:cur] == YES ) {
      NSXMLDocument *xmlDoc = [self createXMLDocumentFromFile:cur];

      if ( xmlDoc ) {
        NSError *err;
        NSArray *matches = [xmlDoc nodesForXPath:[NSString stringWithFormat:@".//ApplicationMappings//application[name=\"%@\"]//path", [self name]] error:&err];

        if ( [matches count] > 0 ) {
          MLog(@"found %@ in a custom mapping", [self name]);
          NSMutableArray *files = [NSMutableArray array];

          NSEnumerator *walker = [matches objectEnumerator];
          NSXMLNode    *cur;

          while ((cur = [walker nextObject]))	{
            [files addObject:[[cur stringValue] stringByExpandingTildeInPath]];
          }

          if (([self preferencesFile] != nil) && ([files containsObject:[self preferencesFile]] == NO)) {
            [files addObject:[self preferencesFile]];
          }

          [files addObject:[self applicationCacheFolder]];

          return files;
        }
      }
    }
  }


  //
  // nothing? try our best w/ what we got
  //
  NSMutableArray *ourBest = [NSMutableArray arrayWithObjects:[self applicationCacheFolder], [self applicationSupportFolder], [self preferencesFile], [self applicationLibraryFolder], nil];

  // is it an AIR application
  if ([[NSFileManager defaultManager] fileExistsAtPath:[[self path] stringByAppendingString:@"/Contents/Resources/META-INF/Air"]]) {
    MLog(@"Working with an Adobe AIR application");

    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES);
    [ourBest addObject:[[paths objectAtIndex:0] stringByAppendingFormat:@"/Adobe/AIR/ELS/%@", [self bundleID]]];


    paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    [ourBest addObject:[[paths objectAtIndex:0] stringByAppendingString:[NSString stringWithFormat:@"/Preferences/%@", [self bundleID]]]];
  }

  return ourBest;
}


// ------------------------------------------------------------
- (NSString *)applicationCacheFolder
{
  NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);

  if ( [paths objectAtIndex:0] == nil ) {
    return nil;
  }

  NSString *basePath = [paths objectAtIndex:0];
  NSString *try1     = [basePath stringByAppendingFormat:@"/%@", [self name]];
  NSString *try2     = [basePath stringByAppendingFormat:@"/%@", [self bundleID]];

  if ( [[NSFileManager defaultManager] fileExistsAtPath:try1] == YES ) {
    return try1;
  }

  return try2;
}


// ------------------------------------------------------------
- (NSString *)applicationDefinedMappingFile
{
  // figure out if this app has the rooSwitchCustomMapping info
  id infoPlist = [self plist];

  if ( [infoPlist valueForKey:@"rooSwitchCustomMapping"] == nil ) {
    return nil;
  }

  NSString *customMappingFile = [[infoPlist valueForKey:@"rooSwitchCustomMapping"] stringByDeletingPathExtension];
  customMappingFile = [[NSBundle bundleWithPath:[self path]] pathForResource:customMappingFile ofType:@"xml"];
  return customMappingFile;
}


// ------------------------------------------------------------
- (NSString *)applicationLibraryFolder
{
  if ( [[NSFileManager defaultManager] fileExistsAtPath:[[NSString stringWithFormat:@"~/Library/%@", [self name]] stringByExpandingTildeInPath]] == YES ) {
    return [NSString stringWithFormat:@"~/Library/%@", [self name]];
  }

  return nil;
}


// ------------------------------------------------------------
- (NSString *)applicationSupportFolder
{
  // assume the app support files for this app are in
  NSArray *paths = NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES);

  if ( [paths objectAtIndex:0] == nil ) {
    return nil;
  }

  NSString *basePath = [paths objectAtIndex:0];
  // TODO: make this smarter, search for matches or something.
  NSString *appFolder = [basePath stringByAppendingFormat:@"/%@", [self name]];

  return appFolder;
}


// ------------------------------------------------------------
- (NSString *)bundleID
{
  @try
  {
    // find the prefs file via the Info.plist
    id infoPlist = [self plist];

    if ( [infoPlist valueForKey:@"CFBundleIdentifier"] == nil ) {
      return nil;
    }

    return [infoPlist valueForKey:@"CFBundleIdentifier"];
  }
  @catch ( NSException *exception )
  {
    MLog(@"Error parsing info.plist - %@", exception);
  }

  return nil;
}


// ------------------------------------------------------------
- (NSXMLDocument *)createXMLDocumentFromFile:(NSString *)file
{
  NSXMLDocument *xmlDoc = nil;
  NSError       *err    = nil;
  NSURL         *furl   = [NSURL fileURLWithPath:file];

  if (!furl) {
    return nil;
  }

  xmlDoc = [[NSXMLDocument alloc] initWithContentsOfURL:furl options:(NSXMLNodePreserveWhitespace | NSXMLNodePreserveCDATA) error:&err];

  if ( xmlDoc == nil ) {
    xmlDoc = [[NSXMLDocument alloc] initWithContentsOfURL:furl options:NSXMLDocumentTidyXML error:&err];
  }

  return xmlDoc;
}


// ------------------------------------------------------------
- (NSString *)plist
{
  NSString            *infoDotPlist = [application stringByAppendingString:@"/Contents/Info.plist"];
  NSData              *plistData;
  NSString            *error;
  NSPropertyListFormat format;
  id                   plist;

  plistData = [NSData dataWithContentsOfFile:infoDotPlist];

  plist = [NSPropertyListSerialization propertyListFromData:plistData
                                           mutabilityOption:NSPropertyListImmutable
                                                     format:&format
                                           errorDescription:&error];

  if (!plist) {
    NSLog(@"%@", error);
  }

  return plist;
}


// ----------------------------------------------------------
- (NSString *)iconPath
{
  // open the plist, get the icon name and then it's APP_FILE/Contents/Resources/${blah}.icns
  id infoPlist = [self plist];

  if ( [infoPlist valueForKey:@"CFBundleIconFile"] == nil ) {
    return nil;
  }

  NSString *iconName = [infoPlist valueForKey:@"CFBundleIconFile"];

  if ( [[iconName pathExtension] isEqualToString:@""] ) {
    iconName = [iconName stringByAppendingPathExtension:@"icns"];
  }

  return [application stringByAppendingFormat:@"/Contents/Resources/%@", iconName];
}


// ------------------------------------------------------------
- (BOOL)isRooSwitchLiveEnabled
{
  @try
  {
    // find the prefs file via the Info.plist
    id infoPlist = [self plist];

    if ( [infoPlist valueForKey:@"rooSwitchLiveEnabled"] == nil ) {
      return NO;
    }

    return YES;
  }
  @catch ( NSException *exception )
  {
    MLog(@"Error parsing info.plist - %@", exception);
  }

  return NO;
}


// ------------------------------------------------------------
- (BOOL)isSystemPreference
{
  if ( [[application pathExtension] isEqualToString:@"prefPane"] ) {
    return YES;
  }

  return NO;
}


// ------------------------------------------------------------
- (BOOL)isValid
{
  // if there's an entry in either of the CustomAppMappings, then it's a valid file.
  //
  // see if the application is found in the users AppSupport/rooSwitch/CustomAppMappings.xml file
  //
  NSMutableArray *xmlFiles = [NSMutableArray array];
  NSArray        *paths    = NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES);

  if ( [paths objectAtIndex:0] != nil ) {
    [xmlFiles addObject:[[paths objectAtIndex:0] stringByAppendingString:@"/rooSwitch/CustomAppMappings.xml"]];
  }

  [xmlFiles addObject:[[NSBundle mainBundle] pathForResource:@"CustomAppMappings" ofType:@"xml"]];

  NSEnumerator *walker = [xmlFiles objectEnumerator];
  NSString     *cur;

  while ((cur = [walker nextObject])) {
    if ( [[NSFileManager defaultManager] fileExistsAtPath:cur] == YES ) {
      NSXMLDocument *xmlDoc = [self createXMLDocumentFromFile:cur];

      if ( xmlDoc ) {
        NSError *err;
        NSArray *matches = [xmlDoc nodesForXPath:[NSString stringWithFormat:@".//ApplicationMappings//application[name=\"%@\"]//path", [self name]] error:&err];

        if ( [matches count] > 0 ) {
          return YES;
        }
      }
    }
  }


  // checks for a bundle identifier in the .plist
  id infoPlist = [self plist];

  if ( [infoPlist valueForKey:@"CFBundleIdentifier"] == nil ) {
    return NO;
  } else {
    return YES;
  }
}


// ------------------------------------------------------------
- (NSString *)name
{
  @try
  {
    // find the prefs file via the Info.plist
    id infoPlist = [self plist];

    if ( [infoPlist valueForKey:@"CFBundleName"] != nil ) {
      NSString *appName = [infoPlist valueForKey:@"CFBundleName"];

      if ( [[appName pathComponents] count] > 0 ) {
        appName = [[appName pathComponents] componentsJoinedByString:@""];
      }

      return appName;
    }
  }
  @catch ( NSException *exception )
  {
    MLog(@"Error parsing info.plist - %@", exception);
  }

  return [[[NSFileManager defaultManager] displayNameAtPath:application] stringByDeletingPathExtension];
}


// ------------------------------------------------------------
- (NSString *)path
{
  return application;
}


// ------------------------------------------------------------
- (NSString *)preferencesFile
{
  NSString *bundleID = [self bundleID];

  if ( bundleID == nil ) {
    return nil;
  }

  NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);

  if ( [paths objectAtIndex:0] == nil ) {
    return nil;
  }

  return [[paths objectAtIndex:0] stringByAppendingString:[NSString stringWithFormat:@"/Preferences/%@.plist", [self bundleID]]];
}


@end
