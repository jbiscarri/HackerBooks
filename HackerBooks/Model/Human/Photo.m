#import "Photo.h"

@interface Photo ()

// Private interface goes here.

@end

@implementation Photo

+ (instancetype)photoWithImageUrl:(NSString*)imageUrl
                          context:(NSManagedObjectContext*)context
{
    Photo *p = [self insertInManagedObjectContext:context];
    p.photoUrl = imageUrl;
    return p;
}

- (void)setImage:(UIImage *)image{
    
    self.photoData = UIImageJPEGRepresentation(image, 0.9);
}

- (UIImage *)image{
    
    return [UIImage imageWithData:self.photoData];
}

@end
