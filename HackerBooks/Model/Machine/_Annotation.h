// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Annotation.h instead.

@import CoreData;

extern const struct AnnotationAttributes {
	__unsafe_unretained NSString *creationDate;
	__unsafe_unretained NSString *modificationDate;
	__unsafe_unretained NSString *text;
} AnnotationAttributes;

extern const struct AnnotationRelationships {
	__unsafe_unretained NSString *book;
	__unsafe_unretained NSString *localization;
	__unsafe_unretained NSString *photo;
} AnnotationRelationships;

@class Book;
@class Localization;
@class Photo;

@interface AnnotationID : NSManagedObjectID {}
@end

@interface _Annotation : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) AnnotationID* objectID;

@property (nonatomic, strong) NSDate* creationDate;

//- (BOOL)validateCreationDate:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSDate* modificationDate;

//- (BOOL)validateModificationDate:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* text;

//- (BOOL)validateText:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) Book *book;

//- (BOOL)validateBook:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) Localization *localization;

//- (BOOL)validateLocalization:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) Photo *photo;

//- (BOOL)validatePhoto:(id*)value_ error:(NSError**)error_;

@end

@interface _Annotation (CoreDataGeneratedPrimitiveAccessors)

- (NSDate*)primitiveCreationDate;
- (void)setPrimitiveCreationDate:(NSDate*)value;

- (NSDate*)primitiveModificationDate;
- (void)setPrimitiveModificationDate:(NSDate*)value;

- (NSString*)primitiveText;
- (void)setPrimitiveText:(NSString*)value;

- (Book*)primitiveBook;
- (void)setPrimitiveBook:(Book*)value;

- (Localization*)primitiveLocalization;
- (void)setPrimitiveLocalization:(Localization*)value;

- (Photo*)primitivePhoto;
- (void)setPrimitivePhoto:(Photo*)value;

@end
