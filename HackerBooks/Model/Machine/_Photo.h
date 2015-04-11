// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Photo.h instead.

@import CoreData;

extern const struct PhotoAttributes {
	__unsafe_unretained NSString *photoData;
	__unsafe_unretained NSString *photoUrl;
} PhotoAttributes;

extern const struct PhotoRelationships {
	__unsafe_unretained NSString *annotation;
	__unsafe_unretained NSString *book;
} PhotoRelationships;

@class Annotation;
@class Book;

@interface PhotoID : NSManagedObjectID {}
@end

@interface _Photo : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) PhotoID* objectID;

@property (nonatomic, strong) NSData* photoData;

//- (BOOL)validatePhotoData:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* photoUrl;

//- (BOOL)validatePhotoUrl:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) Annotation *annotation;

//- (BOOL)validateAnnotation:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) Book *book;

//- (BOOL)validateBook:(id*)value_ error:(NSError**)error_;

@end

@interface _Photo (CoreDataGeneratedPrimitiveAccessors)

- (NSData*)primitivePhotoData;
- (void)setPrimitivePhotoData:(NSData*)value;

- (NSString*)primitivePhotoUrl;
- (void)setPrimitivePhotoUrl:(NSString*)value;

- (Annotation*)primitiveAnnotation;
- (void)setPrimitiveAnnotation:(Annotation*)value;

- (Book*)primitiveBook;
- (void)setPrimitiveBook:(Book*)value;

@end
