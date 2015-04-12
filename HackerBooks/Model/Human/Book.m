#import "Book.h"
#import "Tag.h"
#import "Photo.h"
#import "Pdf.h"

#import "Settings.h"
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
            [b addTagsObject:[Tag TagWithName:[tag stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]
                                    favorites:NO
                                      context:context]];
        }
    }
}

- (void)setIsFavorite:(BOOL)isFavorite
{
    
    Tag *favoriteTag = [Tag TagWithName:@"Favorites"
                              favorites:NO
                                context:self.managedObjectContext];
    if (isFavorite)
        [self addTagsObject:favoriteTag];
    else
        [self removeTagsObject:favoriteTag];
}

- (BOOL)isFavorite
{
    Tag *favoriteTag = [Tag TagWithName:@"Favorites"
                              favorites:NO
                                context:self.managedObjectContext];
    return ([self.tags.allObjects containsObject:favoriteTag]);
}

- (NSString*)tagsString
{
    NSMutableString *tagsString = [NSMutableString string];
    for (Tag *t in self.tags)
    {
        [tagsString appendFormat:@"%@, ", t.tag];
    }
    [tagsString deleteCharactersInRange:NSMakeRange(tagsString.length-2, 2)];
    return tagsString;
}

@end
