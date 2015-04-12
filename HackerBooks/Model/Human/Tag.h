#import "_Tag.h"

@interface Tag : _Tag {}
+ (instancetype)TagWithName:(NSString*)tag
                  favorites:(BOOL)favorite
                    context:(NSManagedObjectContext*)context;
@end
