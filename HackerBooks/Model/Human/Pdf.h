#import "_Pdf.h"

@interface Pdf : _Pdf {}

+ (instancetype)pdfWithPdfUrl:(NSString*)pdfUrl
                      context:(NSManagedObjectContext*)context;

@end