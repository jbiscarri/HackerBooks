//
//  AGTBookViewController.h
//  HackerBooks
//
//  Created by Joan on 28/03/15.
//  Copyright (c) 2015 Biscarri. All rights reserved.
//

@class AGTBook;
@class AGTBookViewController;

#import <UIKit/UIKit.h>
#import "AGTTableViewController.h"

@interface AGTBookViewController : UIViewController<AGTTableViewControllerDelegate, UISplitViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UISwitch *switchFavorite;
@property (weak, nonatomic) IBOutlet UIImageView *bookImageView;
@property (weak, nonatomic) IBOutlet UILabel *bookTitle;
@property (weak, nonatomic) IBOutlet UILabel *bookAuthors;
@property (weak, nonatomic) IBOutlet UILabel *bookTags;
@property (strong, nonatomic) AGTBook *book;


- (instancetype)initWithBook:(AGTBook*)book;
- (IBAction)switchValueChanged:(id)sender;
- (IBAction)showPDF:(id)sender;



@end
