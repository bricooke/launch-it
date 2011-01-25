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
  if ([self.url rangeOfString:@"http://"].location == 0)
    return [self.url substringFromIndex:7];
  if ([self.url rangeOfString:@"https://"].location == 0)
    return [self.url substringFromIndex:8];
  return self.url;
}


- (void)setName:(NSString *)aNewURL
{
  if ([aNewURL rangeOfString:@"://"].location == NSNotFound) 
    aNewURL = [@"http://" stringByAppendingString:aNewURL];
  self.url = aNewURL;
  [[NSNotificationCenter defaultCenter] postNotificationName:@"WebsiteUpdated" object:nil];
}

- (NSImage *)smallImage
{
  return [NSImage imageNamed:@"icon_web.png"];
}

- (NSImage *)largeImage
{
  return [NSImage imageNamed:@"icon_web.png"];
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
