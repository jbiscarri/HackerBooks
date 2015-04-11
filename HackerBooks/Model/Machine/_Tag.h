// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Tag.h instead.

@import CoreData;

extern const struct TagAttributes {
	__unsafe_unretained NSString *tag;
} TagAttributes;

extern const struct TagRelationships {
	__unsafe_unretained NSString *books;
} TagRelationships;

@class Book;

@interface TagID : NSManagedObjectID {}
@end

@interface _Tag : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) TagID* objectID;

@property (nonatomic, strong) NSString* tag;

//- (BOOL)validateTag:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSSet *books;

- (NSMutableSet*)booksSet;

@end

@interface _Tag (BooksCoreDataGeneratedAccessors)
- (void)addBooks:(NSSet*)value_;
- (void)removeBooks:(NSSet*)value_;
- (void)addBooksObject:(Book*)value_;
- (void)removeBooksObject:(Book*)value_;

@end

@interface _Tag (CoreDataGeneratedPrimitiveAccessors)

- (NSString*)primitiveTag;
- (void)setPrimitiveTag:(NSString*)value;

- (NSMutableSet*)primitiveBooks;
- (void)setPrimitiveBooks:(NSMutableSet*)value;

@end
