#import "Pdf.h"

@interface Pdf ()

// Private interface goes here.

@end

@implementation Pdf
@synthesize cancelDownload;

+ (instancetype)pdfWithPdfUrl:(NSString*)pdfUrl
                      context:(NSManagedObjectContext*)context
{
    Pdf *p = [self insertInManagedObjectContext:context];
    p.pdfUrl = pdfUrl;
    return p;
}

- (void)loadPdfCompletion:(void(^)(NSData *pdf))completionBlock{
    dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INTERACTIVE, 0), ^{
        if (!self.pdfData){
            NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:self.pdfUrl]];
            if (data){
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (!self.cancelDownload)
                        self.pdfData = data;
                });
            }
        }
        if (completionBlock){
            dispatch_async(dispatch_get_main_queue(), ^{
                if (!self.cancelDownload)
                    completionBlock(self.pdfData);
            });
        }
    });
}


@end
