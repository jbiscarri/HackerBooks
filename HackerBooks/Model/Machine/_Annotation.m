// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Annotation.m instead.

#import "_Annotation.h"

const struct AnnotationAttributes AnnotationAttributes = {
	.creationDate = @"creationDate",
	.modificationDate = @"modificationDate",
	.text = @"text",
};

const struct AnnotationRelationships AnnotationRelationships = {
	.book = @"book",
	.localization = @"localization",
	.photo = @"photo",
};

@implementation AnnotationID
@end

@implementation _Annotation

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"Annotation" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"Annotation";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"Annotation" inManagedObjectContext:moc_];
}

- (AnnotationID*)objectID {
	return (AnnotationID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];

	return keyPaths;
}

@dynamic creationDate;

@dynamic modificationDate;

@dynamic text;

@dynamic book;

@dynamic localization;

@dynamic photo;

@end

