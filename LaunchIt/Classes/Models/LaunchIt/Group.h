#import "_Group.h"

@class SGHotKey;

@interface Group : _Group {
  SGHotKey *_hotkey;
}

@property (readonly) SGHotKey *hotkey;

+ (void)bindAllHotkeys;
+ (void)migrateExistingApplications;
- (void)bindHotkey;
- (void)bindHotkeyTo:(id) delegate action:(SEL)selector;
- (void)unbindHotkey;
- (NSString *)shortcutCodeStringForMenus;
- (NSString *)shortcutCodeString;
- (NSUInteger)modifierMask;
- (NSImage *)smallImage;
- (NSImage *)largeImage;

+ (NSArray *)allSortedByName;
@end
