#import "_Photo.h"
@import UIKit;

@interface Photo : _Photo {}

+ (instancetype)photoWithImageUrl:(NSString*)imageUrl
                          context:(NSManagedObjectContext*)context;

- (void)loadImageCompletion:(void(^)(UIImage *image))completionBlock;

@end
