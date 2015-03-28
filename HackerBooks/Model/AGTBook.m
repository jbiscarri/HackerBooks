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
        _image_url = dictionary[@"pdf_url"];
        _pdf_url = dictionary[@"pdf_url"];
        _tags = dictionary[@"tags"];
        _title = dictionary[@"title"];
        
        //check if is favorite
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        NSMutableDictionary *favorites = [[userDefaults objectForKey:USER_DEFAULTS_FAVORITES] mutableCopy];
        if ([favorites objectForKey:self.pdf_url])
        {
            self.isFavorite = [[favorites objectForKey:self.pdf_url] boolValue];
        }else{
            self.isFavorite = NO;
            favorites[self.pdf_url] = @(NO);
        }
    }
    return self;
}

@end