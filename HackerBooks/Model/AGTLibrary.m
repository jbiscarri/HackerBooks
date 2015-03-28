//
//  AGTLibrary.m
//  HackerBooks
//
//  Created by Joan on 28/03/15.
//  Copyright (c) 2015 Biscarri. All rights reserved.
//

#import "AGTLibrary.h"
#import "AGTBook.h"
#import "Settings.h"

@implementation AGTLibrary

- (instancetype)initWithJSONData:(NSData*)jsonData{
    if (self = [super init])
    {
        _allBooks = [NSMutableArray array];
        _tagsDictionary = [NSMutableDictionary dictionary];
        self.tagsDictionary[FAVORITE_KEY] = [NSMutableArray array];
        
        NSError *error;
        id jsonObject = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingAllowFragments
                                                          error:&error];
        
        if (jsonObject &&
            [jsonObject isKindOfClass:[NSArray class]]){
            NSArray *books = (NSArray*)jsonObject;
            [self fillTagsDictionaryWithBooks:books];
        }else{
            NSLog(@"Error parsing json: %@", error.userInfo);
        }
    }
    return self;
}

- (NSUInteger)booksCount{
    return self.allBooks.count;
}

- (NSArray*)tags{
    NSArray *keys = [self.tagsDictionary.allKeys sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
        NSString *first = (NSString*)a;
        NSString *second = (NSString*)b;
        if ([first isEqualToString:FAVORITE_KEY])
            return NSOrderedAscending;
        if ([second isEqualToString:FAVORITE_KEY])
            return NSOrderedDescending;
        return [first localizedCompare:second];
    }];
    return keys;
}

- (NSUInteger)booksCountForTag:(NSString*)tag{
    if (self.tagsDictionary[tag])
        return ((NSArray*)self.tagsDictionary[tag]).count;
    else
        return 0;
}

- (NSArray*)booksForTag:(NSString*)tag{
    if (self.tagsDictionary[tag])
    {
        NSArray *books = self.tagsDictionary[tag];
        NSArray *orderedBooks = [books sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
            AGTBook *first = (AGTBook*)a;
            AGTBook *second = (AGTBook*)b;
            return [first.title localizedCompare:second.title];
        }];
        return orderedBooks;
    }else{
        return nil;
    }
}

- (AGTBook*)bookForTag:(NSString*)tag atIndex:(NSUInteger)index{
    if (self.tagsDictionary[tag])
    {
        NSArray *books = self.tagsDictionary[tag];
        NSArray *orderedBooks = [books sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
            AGTBook *first = (AGTBook*)a;
            AGTBook *second = (AGTBook*)b;
            return [first.title localizedCompare:second.title];
        }];
        if (index < orderedBooks.count)
            return orderedBooks[index];
    }
    return nil;
}

#pragma mark - Utils

- (void)fillTagsDictionaryWithBooks:(NSArray*)booksDictionary
{
    for (NSDictionary *bookDictionary in booksDictionary)
    {
        AGTBook *book = [[AGTBook alloc] initWithDictionary:bookDictionary];
        
        //I add this book in list
        [self.allBooks addObject:book];
        
        //Should I have to add this book to favorites
        if (book.isFavorite)
            [((NSMutableArray*)self.tagsDictionary[FAVORITE_KEY]) addObject:book];
        
        //I add this book in tags dictionary
        NSArray *tagsArray = [book.tags componentsSeparatedByString:@","];
        for (NSString *tag in tagsArray)
        {
            NSString *trimmedTag = [tag stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            
            if (!self.tagsDictionary[trimmedTag])
                self.tagsDictionary[trimmedTag] = [NSMutableArray array];
            
            [((NSMutableArray*)self.tagsDictionary[trimmedTag]) addObject:book];
        }
    }
}

@end
