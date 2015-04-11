// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Pdf.h instead.

@import CoreData;

extern const struct PdfAttributes {
	__unsafe_unretained NSString *pdfData;
	__unsafe_unretained NSString *pdfUrl;
} PdfAttributes;

extern const struct PdfRelationships {
	__unsafe_unretained NSString *book;
} PdfRelationships;

@class Book;

@interface PdfID : NSManagedObjectID {}
@end

@interface _Pdf : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) PdfID* objectID;

@property (nonatomic, strong) NSData* pdfData;

//- (BOOL)validatePdfData:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* pdfUrl;

//- (BOOL)validatePdfUrl:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) Book *book;

//- (BOOL)validateBook:(id*)value_ error:(NSError**)error_;

@end

@interface _Pdf (CoreDataGeneratedPrimitiveAccessors)

- (NSData*)primitivePdfData;
- (void)setPrimitivePdfData:(NSData*)value;

- (NSString*)primitivePdfUrl;
- (void)setPrimitivePdfUrl:(NSString*)value;

- (Book*)primitiveBook;
- (void)setPrimitiveBook:(Book*)value;

@end
