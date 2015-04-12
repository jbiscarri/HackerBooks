//
//  AGTTableViewCell.m
//  HackerBooks
//
//  Created by Joan on 28/03/15.
//  Copyright (c) 2015 Biscarri. All rights reserved.
//

#import "AGTTableViewCell.h"
#import "Book.h"
#import "Tag.h"
//#import "AGTBook.h"

@implementation AGTTableViewCell

- (void)awakeFromNib {
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)configureCellWithBook:(Book*)book
{
    self.cellTitle.text = book.title;
    self.cellAuthors.text = book.authors;
    
    self.cellTags.text = [book tagsString];
    self.favoriteImage.hidden = !book.isFavorite;
}

@end
