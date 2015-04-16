//
//  AGTTableViewController.h
//  HackerBooks
//
//  Created by Joan on 28/03/15.
//  Copyright (c) 2015 Biscarri. All rights reserved.
//

#import <UIKit/UIKit.h>
@import CoreData;

#define TAGS 0
#define ALPHABETICAL 1

@class AGTLibrary;
@class AGTTableViewController;
@class Book;

@protocol AGTTableViewControllerDelegate <NSFetchedResultsControllerDelegate>
- (void)tableViewController:(AGTTableViewController*)tVC didSelectBook:(Book*)book;
@end


@interface AGTTableViewController : UITableViewController <AGTTableViewControllerDelegate, UISearchBarDelegate>
@property (strong, nonatomic) NSFetchedResultsController *tagsFetchedResultsController;
@property (strong, nonatomic) NSFetchedResultsController *alphabeticFetchedResultsController;

@property (nonatomic, weak) id<AGTTableViewControllerDelegate> delegate;
@property (nonatomic, assign) BOOL currentOrder;
@property (nonatomic, strong) UIBarButtonItem *rightBarButtonItem;
@property (nonatomic, assign) BOOL shouldSelectFirstBook;


@end


