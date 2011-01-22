// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Group.h instead.

#import <CoreData/CoreData.h>


@class Website;
@class Application;

@interface GroupID : NSManagedObjectID {}
@end

@interface _Group : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (GroupID*)objectID;



@property (nonatomic, retain) NSNumber *shortcutCode;

@property int shortcutCodeValue;
- (int)shortcutCodeValue;
- (void)setShortcutCodeValue:(int)value_;

//- (BOOL)validateShortcutCode:(id*)value_ error:(NSError**)error_;



@property (nonatomic, retain) NSString *name;

//- (BOOL)validateName:(id*)value_ error:(NSError**)error_;



@property (nonatomic, retain) NSData *renderedImage;

//- (BOOL)validateRenderedImage:(id*)value_ error:(NSError**)error_;



@property (nonatomic, retain) NSNumber *shortcutFlags;

@property int shortcutFlagsValue;
- (int)shortcutFlagsValue;
- (void)setShortcutFlagsValue:(int)value_;

//- (BOOL)validateShortcutFlags:(id*)value_ error:(NSError**)error_;




@property (nonatomic, retain) NSSet* websites;
- (NSMutableSet*)websitesSet;



@property (nonatomic, retain) NSSet* applications;
- (NSMutableSet*)applicationsSet;



@end

@interface _Group (CoreDataGeneratedAccessors)

- (void)addWebsites:(NSSet*)value_;
- (void)removeWebsites:(NSSet*)value_;
- (void)addWebsitesObject:(Website*)value_;
- (void)removeWebsitesObject:(Website*)value_;

- (void)addApplications:(NSSet*)value_;
- (void)removeApplications:(NSSet*)value_;
- (void)addApplicationsObject:(Application*)value_;
- (void)removeApplicationsObject:(Application*)value_;

@end
