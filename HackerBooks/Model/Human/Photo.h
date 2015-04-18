#import "_Photo.h"
@import UIKit;

@interface Photo : _Photo {}
@property (nonatomic, strong) UIImage *image;


+ (instancetype)photoWithImageUrl:(NSString*)imageUrl
                          context:(NSManagedObjectContext*)context;

- (void)loadImageCompletion:(void(^)(UIImage *image))completionBlock;

@end
