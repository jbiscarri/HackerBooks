#import "_Pdf.h"

@interface Pdf : _Pdf {}

@property (nonatomic,assign) BOOL cancelDownload;

+ (instancetype)pdfWithPdfUrl:(NSString*)pdfUrl
                      context:(NSManagedObjectContext*)context;
- (void)loadPdfCompletion:(void(^)(NSData *pdf))completionBlock;

@end
