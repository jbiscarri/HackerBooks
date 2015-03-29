//
//  AGTTableViewCell.m
//  HackerBooks
//
//  Created by Joan on 28/03/15.
//  Copyright (c) 2015 Biscarri. All rights reserved.
//

#import "AGTTableViewCell.h"
#import "AGTBook.h"

@implementation AGTTableViewCell

- (void)awakeFromNib {
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)configureCellWithBook:(AGTBook*)book
{
    self.cellTitle.text = book.title;
    self.cellAuthors.text = book.authors;
    self.cellTags.text = book.tags;
    self.favoriteImage.hidden = !book.isFavorite;
}

@end
