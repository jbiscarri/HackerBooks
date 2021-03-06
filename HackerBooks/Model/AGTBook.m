//
//  AGTBook.m
//  HackerBooks
//
//  Created by Joan on 28/03/15.
//  Copyright (c) 2015 Biscarri. All rights reserved.
//

#import "AGTBook.h"
#import "Settings.h"

@implementation AGTBook


- (instancetype)initWithDictionary:(NSDictionary*)dictionary{
    if (self = [super init])
    {
        _authors = dictionary[@"authors"];
        _image_url = [NSURL URLWithString:dictionary[@"image_url"]];
        _pdf_url = [NSURL URLWithString:dictionary[@"pdf_url"]];
        _tags = dictionary[@"tags"];
        _title = dictionary[@"title"];
    }
    return self;
}

- (void)setIsFavorite:(BOOL)isFavorite
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *favorites = [[userDefaults objectForKey:USER_DEFAULTS_FAVORITES] mutableCopy];
    favorites[[self.pdf_url.absoluteString lastPathComponent]] = @(isFavorite);
    [userDefaults setObject:favorites forKey:USER_DEFAULTS_FAVORITES];
    [userDefaults synchronize];
    
    [self.delegate book:self modifiedFavoriteValue:isFavorite];
    //Send notification to update
    NSDictionary *userInfo = @{NOT_BOOK_KEY:self};
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_FAVORITE_FOR_BOOK_CHANGED object:self userInfo:userInfo];

}

- (BOOL)isFavorite
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *favorites = [[userDefaults objectForKey:USER_DEFAULTS_FAVORITES] mutableCopy];
    if ([favorites objectForKey:[self.pdf_url.absoluteString lastPathComponent]])
    {
        return [[favorites objectForKey:[self.pdf_url.absoluteString lastPathComponent]] boolValue];
    }
    return NO;
 
}

@end