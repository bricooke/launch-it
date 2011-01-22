// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Group.m instead.

#import "_Group.h"

@implementation GroupID
@end

@implementation _Group

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"Group" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"Group";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"Group" inManagedObjectContext:moc_];
}

- (GroupID*)objectID {
	return (GroupID*)[super objectID];
}




@dynamic shortcutCode;



- (int)shortcutCodeValue {
	NSNumber *result = [self shortcutCode];
	return result ? [result intValue] : 0;
}

- (void)setShortcutCodeValue:(int)value_ {
	[self setShortcutCode:[NSNumber numberWithInt:value_]];
}






@dynamic name;






@dynamic renderedImage;






@dynamic shortcutFlags;



- (int)shortcutFlagsValue {
	NSNumber *result = [self shortcutFlags];
	return result ? [result intValue] : 0;
}

- (void)setShortcutFlagsValue:(int)value_ {
	[self setShortcutFlags:[NSNumber numberWithInt:value_]];
}






@dynamic websites;

	
- (NSMutableSet*)websitesSet {
	[self willAccessValueForKey:@"websites"];
	NSMutableSet *result = [self mutableSetValueForKey:@"websites"];
	[self didAccessValueForKey:@"websites"];
	return result;
}
	

@dynamic applications;

	
- (NSMutableSet*)applicationsSet {
	[self willAccessValueForKey:@"applications"];
	NSMutableSet *result = [self mutableSetValueForKey:@"applications"];
	[self didAccessValueForKey:@"applications"];
	return result;
}
	



@end
