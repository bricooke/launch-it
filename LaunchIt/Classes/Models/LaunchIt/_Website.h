// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Website.h instead.

#import <CoreData/CoreData.h>


@class Group;

@interface WebsiteID : NSManagedObjectID {}
@end

@interface _Website : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (WebsiteID*)objectID;



@property (nonatomic, retain) NSString *url;

//- (BOOL)validateUrl:(id*)value_ error:(NSError**)error_;



@property (nonatomic, retain) NSData *favicon;

//- (BOOL)validateFavicon:(id*)value_ error:(NSError**)error_;




@property (nonatomic, retain) Group* group;
//- (BOOL)validateGroup:(id*)value_ error:(NSError**)error_;



@end

@interface _Website (CoreDataGeneratedAccessors)

@end
