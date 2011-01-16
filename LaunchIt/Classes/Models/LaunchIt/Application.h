#import "_Application.h"
#import "SGHotKey.h"

@interface Application : _Application {
  SGHotKey *_hotkey;
}

@property (readonly) SGHotKey *hotkey;

+ (void)        bindAllHotkeys;
- (NSImage *)   appIcon;
- (NSImage *)   smallAppIcon;
- (void)        bindHotkey;
- (void)        bindHotkeyTo:(id)delegate action:(SEL)selector;
- (void)        unbindHotkey;
- (void)        launch;
- (NSString *)  shortcutCodeStringForMenus;
- (NSString *)  shortcutCodeString;
- (NSUInteger)  modifierMask;
@end
