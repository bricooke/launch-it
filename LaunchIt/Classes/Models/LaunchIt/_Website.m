// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Website.m instead.

#import "_Website.h"

@implementation WebsiteID
@end

@implementation _Website

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"Website" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"Website";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"Website" inManagedObjectContext:moc_];
}

- (WebsiteID*)objectID {
	return (WebsiteID*)[super objectID];
}




@dynamic url;






@dynamic favicon;






@dynamic group;

	



@end
