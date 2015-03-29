//
//  AGTTableViewController.h
//  HackerBooks
//
//  Created by Joan on 28/03/15.
//  Copyright (c) 2015 Biscarri. All rights reserved.
//

#import <UIKit/UIKit.h>

#define TAGS 0
#define ALPHABETICAL 1

@class AGTLibrary;
@class AGTTableViewController;
@class AGTBook;

@protocol AGTTableViewControllerDelegate <NSObject>
- (void)tableViewController:(AGTTableViewController*)tVC didSelectBook:(AGTBook*)book;
@end


@interface AGTTableViewController : UITableViewController<AGTTableViewControllerDelegate>

@property (nonatomic, strong) AGTLibrary *library;
@property (nonatomic, weak) id<AGTTableViewControllerDelegate> delegate;
@property (nonatomic, assign) BOOL currentOrder;
@property (nonatomic, strong) UIBarButtonItem *rightBarButtonItem;



- (instancetype)initWithLibrary:(AGTLibrary*)library style:(UITableViewStyle)style;

@end


