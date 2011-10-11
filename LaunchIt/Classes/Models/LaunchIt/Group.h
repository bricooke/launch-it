#import "_Group.h"

@class SGHotKey;

@interface Group : _Group {
  SGHotKey *_hotkey;
}

@property (unsafe_unretained, readonly) SGHotKey *hotkey;

+ (void)bindAllHotkeys;
+ (void)migrateExistingApplications;
+ (NSArray *)allSortedByName;

- (NSArray *)applicationsAndWebsites;
- (void)bindHotkey;
- (void)bindHotkeyTo:(id) delegate action:(SEL)selector;
- (void)unbindHotkey;
- (NSString *)shortcutCodeStringForMenus;
- (NSString *)shortcutCodeString;
- (NSUInteger)modifierMask;
- (NSImage *)smallImage;
- (NSImage *)largeImage;
@end
