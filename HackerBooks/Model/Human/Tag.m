#import "Tag.h"

@interface Tag ()

// Private interface goes here.

@end

@implementation Tag

+ (instancetype)TagWithName:(NSString*)tag
                    context:(NSManagedObjectContext*)context
{
    NSFetchRequest *req = [NSFetchRequest fetchRequestWithEntityName:[Tag entityName]];
    req.predicate = [NSPredicate predicateWithFormat:@"tag = %@", tag];
    NSError *err;
    Tag *t = [[context executeFetchRequest:req error:&err] lastObject];
    if (!t){
        t = [self insertInManagedObjectContext:context];
        t.tag = tag;
    }
    return t;
}

@end
