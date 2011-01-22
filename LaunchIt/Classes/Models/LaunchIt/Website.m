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

@end
