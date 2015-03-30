//
//  AGTTableViewController.m
//  HackerBooks
//
//  Created by Joan on 28/03/15.
//  Copyright (c) 2015 Biscarri. All rights reserved.
//

#import "AGTTableViewController.h"
#import "AGTLibrary.h"
#import "AGTBook.h"
#import "AGTTableViewCell.h"
#import "AGTBookViewController.h"
#import "Settings.h"

@interface AGTTableViewController ()

@end

@implementation AGTTableViewController

- (instancetype)initWithLibrary:(AGTLibrary*)library style:(UITableViewStyle)style{
    if (self = [super initWithStyle:style])
    {
        _library = library;
        self.title = @"Library";
        self.currentOrder = TAGS;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [self.tableView reloadData];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notifiedThatFavoriteChanged:) name:NOTIFICATION_FAVORITE_FOR_BOOK_CHANGED object:nil];
    
    [self updateRightButton];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.currentOrder == TAGS)
        return self.library.tags.count;
    else
        return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.currentOrder == TAGS){
        NSString *tag = self.library.tags[section];
        NSArray *books = self.library.tagsDictionary[tag];
        return books.count;
    }else{
        return self.library.allBooks.count;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellId = @"AGTBookCellId";
    AGTTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        [tableView registerNib:[UINib nibWithNibName:@"AGTTableViewCell" bundle:nil] forCellReuseIdentifier:cellId];
        cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    }
    AGTBook *book;
    if (self.currentOrder == TAGS){
        NSString *tag = self.library.tags[indexPath.section];
        book = [self.library bookForTag:tag atIndex:indexPath.row];
    }else{
        book = self.library.allBooks[indexPath.row];
    }
    [cell configureCellWithBook:book];
    return cell;
}

- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (self.currentOrder == TAGS){
        NSString *tag = self.library.tags[section];
        return tag;
    }else{
        return @"All books";
    }
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    AGTBook *book;
    if (self.currentOrder == TAGS){
        NSString *tag = self.library.tags[indexPath.section];
        book = [self.library bookForTag:tag atIndex:indexPath.row];
    }else{
        book = self.library.allBooks[indexPath.row];
    }
    
    [self.delegate tableViewController:self didSelectBook:book];
    
    NSDictionary *userInfo = @{NOT_BOOK_KEY:book};
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_SELECTED_BOOK_CHANGED object:self userInfo:userInfo];
    
}

#pragma mark - AGTTableViewControllerDelegate

- (void)tableViewController:(AGTTableViewController*)tVC didSelectBook:(AGTBook*)book{
    AGTBookViewController * bookViewController = [[AGTBookViewController alloc] initWithBook:book];
    [self.navigationController pushViewController:bookViewController animated:YES];
    
}

#pragma mark - NOTIFICATIONS

//NOTIFICATION_SELECTED_BOOK_CHANGED
- (void)notifiedThatFavoriteChanged:(NSNotification*)notification
{
    [self.tableView reloadData];
}

#pragma mark - Right Button
- (void)updateRightButton
{
    //Add right button to navigator to change Book Order
    if (!self.navigationItem.rightBarButtonItem){
        UIBarButtonItem *button = [[UIBarButtonItem alloc] initWithTitle:@""
                                                                   style:UIBarButtonItemStylePlain
                                                                  target:self
                                                                  action:@selector(changeBooksOrder:)];
        self.navigationItem.rightBarButtonItem = button;
    }
    [self.navigationItem.rightBarButtonItem setTitle:(self.currentOrder == ALPHABETICAL)?@"Tags":@"Alphabetical" ];
    
}

- (void)changeBooksOrder:(id)sender
{
    if (self.currentOrder == ALPHABETICAL)
        self.currentOrder = TAGS;
    else
        self.currentOrder = ALPHABETICAL;
    [self.tableView reloadData];
    [self updateRightButton];
        
}


@end



