#import "Website.h"

@implementation Website

- (void) setUrl:(NSString *)url
{
  [self willChangeValueForKey:@"url"];
  [self willChangeValueForKey:@"name"];
  [self setPrimitiveValue:url forKey:@"url"];
  [self didChangeValueForKey:@"name"];
  [self didChangeValueForKey:@"url"];
}

- (NSString *)name
{
  // TODO: make this the part after the http:// and www.
  return self.url;
}


- (void)setName:(NSString *)aNewURL
{
  self.url = aNewURL;
  [[NSNotificationCenter defaultCenter] postNotificationName:@"WebsiteUpdated" object:nil];
}

- (NSImage *)smallImage
{
  return [NSImage imageNamed:@"NSApplicationIcon"];
}

- (NSImage *)largeImage
{
  return [NSImage imageNamed:@"NSApplicationIcon"];
}

- (BOOL) isWebsite
{
  return YES;
}


- (BOOL) isApplication
{
  return NO;
}


@end
