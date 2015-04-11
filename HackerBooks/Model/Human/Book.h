#import "_Book.h"

@interface Book : _Book {}

+ (void)fillGroupsWithInitialData:(NSArray*)data context:(NSManagedObjectContext*)context;

@end
