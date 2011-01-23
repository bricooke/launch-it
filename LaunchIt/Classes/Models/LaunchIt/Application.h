#import "_Application.h"
#import "SGHotKey.h"

@interface Application : _Application {}
- (NSImage *)   largeImage;
- (NSImage *)   smallImage;
- (void)        launch;
- (BOOL) isWebsite;
- (BOOL) isApplication;

@end
