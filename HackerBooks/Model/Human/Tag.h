#import "_Tag.h"

@interface Tag : _Tag {}
+ (instancetype)TagWithName:(NSString*)tag
                    context:(NSManagedObjectContext*)context;
@end
