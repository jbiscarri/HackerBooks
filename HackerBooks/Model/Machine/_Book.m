// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Book.m instead.

#import "_Book.h"

const struct BookAttributes BookAttributes = {
	.authors = @"authors",
	.lastReadPage = @"lastReadPage",
	.title = @"title",
};

const struct BookRelationships BookRelationships = {
	.annotations = @"annotations",
	.pdf = @"pdf",
	.photo = @"photo",
	.tags = @"tags",
};

@implementation BookID
@end

@implementation _Book

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"Book" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"Book";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"Book" inManagedObjectContext:moc_];
}

- (BookID*)objectID {
	return (BookID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];

	if ([key isEqualToString:@"lastReadPageValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"lastReadPage"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}

@dynamic authors;

@dynamic lastReadPage;

- (int32_t)lastReadPageValue {
	NSNumber *result = [self lastReadPage];
	return [result intValue];
}

- (void)setLastReadPageValue:(int32_t)value_ {
	[self setLastReadPage:@(value_)];
}

- (int32_t)primitiveLastReadPageValue {
	NSNumber *result = [self primitiveLastReadPage];
	return [result intValue];
}

- (void)setPrimitiveLastReadPageValue:(int32_t)value_ {
	[self setPrimitiveLastReadPage:@(value_)];
}

@dynamic title;

@dynamic annotations;

- (NSMutableSet*)annotationsSet {
	[self willAccessValueForKey:@"annotations"];

	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"annotations"];

	[self didAccessValueForKey:@"annotations"];
	return result;
}

@dynamic pdf;

@dynamic photo;

@dynamic tags;

- (NSMutableSet*)tagsSet {
	[self willAccessValueForKey:@"tags"];

	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"tags"];

	[self didAccessValueForKey:@"tags"];
	return result;
}

@end

