// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Photo.m instead.

#import "_Photo.h"

const struct PhotoAttributes PhotoAttributes = {
	.photoData = @"photoData",
	.photoUrl = @"photoUrl",
};

const struct PhotoRelationships PhotoRelationships = {
	.annotation = @"annotation",
	.book = @"book",
};

@implementation PhotoID
@end

@implementation _Photo

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"Photo" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"Photo";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"Photo" inManagedObjectContext:moc_];
}

- (PhotoID*)objectID {
	return (PhotoID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];

	return keyPaths;
}

@dynamic photoData;

@dynamic photoUrl;

@dynamic annotation;

@dynamic book;

@end

