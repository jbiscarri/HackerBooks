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
            [b addTagsObject:[Tag TagWithName:[tag stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] context:context]];
        }
    }
}

- (void)setIsFavorite:(BOOL)isFavorite
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *favorites = [[userDefaults objectForKey:USER_DEFAULTS_FAVORITES] mutableCopy];
    favorites[[self.pdf.pdfUrl lastPathComponent]] = @(isFavorite);
    [userDefaults setObject:favorites forKey:USER_DEFAULTS_FAVORITES];
    [userDefaults synchronize];
    
    //Send notification to update
    NSDictionary *userInfo = @{NOT_BOOK_KEY:self};
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_FAVORITE_FOR_BOOK_CHANGED object:self userInfo:userInfo];
    
}

- (BOOL)isFavorite
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *favorites = [[userDefaults objectForKey:USER_DEFAULTS_FAVORITES] mutableCopy];
    if ([favorites objectForKey:[self.pdf.pdfUrl lastPathComponent]])
    {
        return [[favorites objectForKey:[self.pdf.pdfUrl lastPathComponent]] boolValue];
    }
    return NO;
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
