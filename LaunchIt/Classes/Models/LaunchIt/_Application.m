// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Application.m instead.

#import "_Application.h"

@implementation ApplicationID
@end

@implementation _Application

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"Application" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"Application";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"Application" inManagedObjectContext:moc_];
}

- (ApplicationID*)objectID {
	return (ApplicationID*)[super objectID];
}




@dynamic isEnabled;



- (BOOL)isEnabledValue {
	NSNumber *result = [self isEnabled];
	return result ? [result boolValue] : 0;
}

- (void)setIsEnabledValue:(BOOL)value_ {
	[self setIsEnabled:[NSNumber numberWithBool:value_]];
}






@dynamic path;






@dynamic renderedImage;






@dynamic name;






@dynamic shortcutCode;



- (int)shortcutCodeValue {
	NSNumber *result = [self shortcutCode];
	return result ? [result intValue] : 0;
}

- (void)setShortcutCodeValue:(int)value_ {
	[self setShortcutCode:[NSNumber numberWithInt:value_]];
}






@dynamic toggle;



- (BOOL)toggleValue {
	NSNumber *result = [self toggle];
	return result ? [result boolValue] : 0;
}

- (void)setToggleValue:(BOOL)value_ {
	[self setToggle:[NSNumber numberWithBool:value_]];
}






@dynamic shortcutFlags;



- (int)shortcutFlagsValue {
	NSNumber *result = [self shortcutFlags];
	return result ? [result intValue] : 0;
}

- (void)setShortcutFlagsValue:(int)value_ {
	[self setShortcutFlags:[NSNumber numberWithInt:value_]];
}








@end
