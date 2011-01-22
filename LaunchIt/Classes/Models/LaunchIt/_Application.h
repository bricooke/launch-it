// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Application.h instead.

#import <CoreData/CoreData.h>


@class Group;

@interface ApplicationID : NSManagedObjectID {}
@end

@interface _Application : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (ApplicationID*)objectID;



@property (nonatomic, retain) NSNumber *isEnabled;

@property BOOL isEnabledValue;
- (BOOL)isEnabledValue;
- (void)setIsEnabledValue:(BOOL)value_;

//- (BOOL)validateIsEnabled:(id*)value_ error:(NSError**)error_;



@property (nonatomic, retain) NSString *path;

//- (BOOL)validatePath:(id*)value_ error:(NSError**)error_;



@property (nonatomic, retain) NSData *renderedImage;

//- (BOOL)validateRenderedImage:(id*)value_ error:(NSError**)error_;



@property (nonatomic, retain) NSString *name;

//- (BOOL)validateName:(id*)value_ error:(NSError**)error_;



@property (nonatomic, retain) NSNumber *shortcutCode;

@property int shortcutCodeValue;
- (int)shortcutCodeValue;
- (void)setShortcutCodeValue:(int)value_;

//- (BOOL)validateShortcutCode:(id*)value_ error:(NSError**)error_;



@property (nonatomic, retain) NSNumber *toggle;

@property BOOL toggleValue;
- (BOOL)toggleValue;
- (void)setToggleValue:(BOOL)value_;

//- (BOOL)validateToggle:(id*)value_ error:(NSError**)error_;



@property (nonatomic, retain) NSNumber *shortcutFlags;

@property int shortcutFlagsValue;
- (int)shortcutFlagsValue;
- (void)setShortcutFlagsValue:(int)value_;

//- (BOOL)validateShortcutFlags:(id*)value_ error:(NSError**)error_;




@property (nonatomic, retain) Group* group;
//- (BOOL)validateGroup:(id*)value_ error:(NSError**)error_;



@end

@interface _Application (CoreDataGeneratedAccessors)

@end
