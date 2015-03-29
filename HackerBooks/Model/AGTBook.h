//
//  AGTBook.h
//  HackerBooks
//
//  Created by Joan on 28/03/15.
//  Copyright (c) 2015 Biscarri. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AGTBook;

@protocol AGTBookDelegate <NSObject>

- (void)book:(AGTBook*)book modifiedFavoriteValue:(BOOL)favorite;

@end

@interface AGTBook : NSObject

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *authors;
@property (nonatomic, strong) NSString *tags;
@property (nonatomic, strong) NSURL *image_url;
@property (nonatomic, strong) NSURL *pdf_url;
@property (nonatomic, assign) BOOL isFavorite;
@property (nonatomic, weak) id<AGTBookDelegate> delegate;


- (instancetype)initWithDictionary:(NSDictionary*)dictionary;

@end
