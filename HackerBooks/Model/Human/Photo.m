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

- (void)loadImageCompletion:(void(^)(UIImage *image, Photo *photo))completionBlock{
    dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INTERACTIVE, 0), ^{
        if (!self.photoData){
            NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:self.photoUrl]];
            //dispatch_async(dispatch_get_main_queue(), ^{
                self.photoData = data;
            //});

        }
        if (completionBlock){
            UIImage *image = [UIImage imageWithData:self.photoData];
            dispatch_async(dispatch_get_main_queue(), ^{
                completionBlock(image, self);
            });
        }
    });
}

-(void) setImage:(UIImage *)image{
    
    // Convertir la UIImage en un NSData
    self.photoData = UIImageJPEGRepresentation(image, 0.9);
}

-(UIImage *) image{
    
    // Convertir la NSData en UIImage
    return [UIImage imageWithData:self.photoData];
}



@end
