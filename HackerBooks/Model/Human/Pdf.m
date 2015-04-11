#import "Pdf.h"

@interface Pdf ()

// Private interface goes here.

@end

@implementation Pdf

+ (instancetype)pdfWithPdfUrl:(NSString*)pdfUrl
                      context:(NSManagedObjectContext*)context
{
    Pdf *p = [self insertInManagedObjectContext:context];
    p.pdfUrl = pdfUrl;
    return p;
}

/*
 [self.webView loadData:self.pdfData
 MIMEType:@"application/pdf"
 textEncodingName:@"UTF-8"
 baseURL:nil];
 */

@end
