#import "_Book.h"
@class Book;

@interface Book : _Book {}

@property (nonatomic, assign) BOOL isFavorite;

+ (void)fillGroupsWithInitialData:(NSArray*)data context:(NSManagedObjectContext*)context;
- (NSString*)tagsString;

@end
