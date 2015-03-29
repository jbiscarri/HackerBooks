//
//  AGTLibrary.h
//  HackerBooks
//
//  Created by Joan on 28/03/15.
//  Copyright (c) 2015 Biscarri. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AGTBook;

@interface AGTLibrary : NSObject

@property (nonatomic, strong) NSMutableDictionary* tagsDictionary;
@property (nonatomic, strong) NSMutableArray* allBooks;


- (instancetype)initWithJSONData:(NSData*)jsonData;

- (NSUInteger)booksCount;
- (NSArray*)tags;
- (NSUInteger)booksCountForTag:(NSString*)tag;
- (NSArray*)booksForTag:(NSString*)tag;
- (AGTBook*)bookForTag:(NSString*)tag atIndex:(NSUInteger)index;
- (NSArray*)allBooksOrdered;
- (void)updateFavorites;

@end
