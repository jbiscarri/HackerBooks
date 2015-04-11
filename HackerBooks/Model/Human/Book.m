#import "Book.h"
#import "Tag.h"
#import "Photo.h"
#import "Pdf.h"
@interface Book ()

// Private interface goes here.

@end

@implementation Book

+ (void)fillGroupsWithInitialData:(NSArray*)data context:(NSManagedObjectContext*)context
{
    for (NSDictionary *book in data)
    {
        Book *b = [self insertInManagedObjectContext:context];
        b.title =  book[@"title"];
        b.authors = book[@"authors"];
        
        b.photo = [Photo photoWithImageUrl:book[@"image_url"] context:context];
        b.pdf = [Pdf pdfWithPdfUrl:book[@"pdf_url"] context:context];
        
        NSArray *tags = [((NSString*)book[@"tags"]) componentsSeparatedByString:@","];
        for (NSString *tag in tags)
        {
            [b addTagsObject:[Tag TagWithName:[tag stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] context:context]];
        }
    }
}

@end
