//
//  AGTTableViewCell.h
//  HackerBooks
//
//  Created by Joan on 28/03/15.
//  Copyright (c) 2015 Biscarri. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AGTBook;

@interface AGTTableViewCell : UITableViewCell

//@property (strong, nonatomic) AGTBook *book;

@property (weak, nonatomic) IBOutlet UILabel *cellTitle;
@property (weak, nonatomic) IBOutlet UILabel *cellAuthors;
@property (weak, nonatomic) IBOutlet UILabel *cellTags;
@property (weak, nonatomic) IBOutlet UIImageView *favoriteImage;

- (void)configureCellWithBook:(AGTBook*)book;


@end
