#import "_Book.h"
@class Book;

@interface Book : _Book {}

@property (nonatomic, assign) BOOL isFavorite;

+ (void)fillGroupsWithInitialData:(NSArray*)data context:(NSManagedObjectContext*)context;
- (NSString*)tagsString;
- (NSData*)archiveURIRepresentation;
+ (instancetype)objectWithArchivedURIRepresentation:(NSData*)archivedURI
                                            context:(NSManagedObjectContext*)context;
@end
