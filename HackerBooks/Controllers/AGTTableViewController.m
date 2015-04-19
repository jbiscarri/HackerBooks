//
//  AGTTableViewController.m
//  HackerBooks
//
//  Created by Joan on 28/03/15.
//  Copyright (c) 2015 Biscarri. All rights reserved.
//

#import "AGTTableViewController.h"
#import "Tag.h"
#import "Book.h"
#import "AGTTableViewCell.h"
#import "AGTBookViewController.h"
#import "Settings.h"

@interface AGTTableViewController ()
@property (nonatomic) BOOL beganUpdates;
@property (nonatomic, assign) BOOL suspendAutomaticTrackingOfChangesInManagedObjectContext;
@property (nonatomic, strong) UISearchBar* searchBar;
@property (nonatomic, strong) UIButton *overlayButton;
@end

@implementation AGTTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UISearchBar *tempSearchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 0)];
    self.searchBar = tempSearchBar;
    self.searchBar.delegate = self;
    [self.searchBar sizeToFit];

    self.tableView.tableHeaderView = self.searchBar;
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
    [self hideKeyboard];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.currentOrder == TAGS){
        return self.tagsFetchedResultsController.fetchedObjects.count;
    }else{
        return 1;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (self.currentOrder == TAGS){
        Tag *tag = self.tagsFetchedResultsController.fetchedObjects[section];
        return [tag.tag uppercaseString];
    }else{
        return @"All";
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.currentOrder == TAGS){
        Tag *tag = self.tagsFetchedResultsController.fetchedObjects[section];
        return tag.books.count;
    }else{
        return self.alphabeticFetchedResultsController.fetchedObjects.count;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellId = @"AGTBookCellId";
    AGTTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        [tableView registerNib:[UINib nibWithNibName:@"AGTTableViewCell" bundle:nil] forCellReuseIdentifier:cellId];
        cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    }
    
    Book *b;
    if (self.currentOrder == TAGS){
        NSArray *books = [self getBooksWithTagsAtIndexPath:indexPath];
        b = books[indexPath.row];
    }else{
        b = [self.alphabeticFetchedResultsController objectAtIndexPath:indexPath];
    }
    [cell configureCellWithBook:b];
    return cell;
}



#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Book *b;
    if (self.currentOrder == TAGS){
        NSArray *books = [self getBooksWithTagsAtIndexPath:indexPath];
        b = books[indexPath.row];
    }else{
        b = [self.alphabeticFetchedResultsController objectAtIndexPath:indexPath];
    }
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:[b archiveURIRepresentation] forKey:USER_DEFAULTS_LAST_BOOK];
    [userDefaults synchronize];
    
    [self.delegate tableViewController:self didSelectBook:b];
    
    NSDictionary *userInfo = @{NOT_BOOK_KEY:b};
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_SELECTED_BOOK_CHANGED object:self userInfo:userInfo];
    
}

#pragma mark - Books lists helper
- (NSArray*)getBooksWithTagsAtIndexPath:(NSIndexPath*)indexPath
{
    NSArray *books;
    Tag *tag = self.tagsFetchedResultsController.fetchedObjects[indexPath.section];
    NSArray *tempBooks = [tag.books allObjects];
    books = [tempBooks sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        Book *b1 = obj1; Book *b2 = obj2;
        return [b1.title localizedCaseInsensitiveCompare:b2.title];
    }];

    return books;
}

#pragma mark - AGTTableViewControllerDelegate

- (void)tableViewController:(AGTTableViewController*)tVC didSelectBook:(Book*)book{
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

#pragma mark - Setters

- (void)setTagsFetchedResultsController:(NSFetchedResultsController *)newfrc
{
    NSFetchedResultsController *oldfrc = _tagsFetchedResultsController;
    if (newfrc != oldfrc) {
        _tagsFetchedResultsController = newfrc;
        newfrc.delegate = self;
        if ((!self.title || [self.title isEqualToString:oldfrc.fetchRequest.entity.name]) && (!self.navigationController || !self.navigationItem.title)) {
            self.title = newfrc.fetchRequest.entity.name;
        }
        if (newfrc) {
            [self performTagsFetch];
        } else {
            [self.tableView reloadData];
        }
    }
}

- (void)performTagsFetch
{
    if (self.tagsFetchedResultsController) {
        NSError *error;
        [self.tagsFetchedResultsController performFetch:&error];
        if (error) NSLog(@"[%@ %@] %@ (%@)", NSStringFromClass([self class]), NSStringFromSelector(_cmd), [error localizedDescription], [error localizedFailureReason]);
    }
}

- (void)setAlphabeticFetchedResultsController:(NSFetchedResultsController *)newfrc
{
    NSFetchedResultsController *oldfrc = _alphabeticFetchedResultsController;
    if (newfrc != oldfrc) {
        _alphabeticFetchedResultsController = newfrc;
        newfrc.delegate = self;
        if ((!self.title || [self.title isEqualToString:oldfrc.fetchRequest.entity.name]) && (!self.navigationController || !self.navigationItem.title)) {
            self.title = newfrc.fetchRequest.entity.name;
        }
        if (newfrc) {
            [self performAlphabeticFetch];
        } else {
            [self.tableView reloadData];
        }
    }
}

- (void)performAlphabeticFetch
{
    if (self.alphabeticFetchedResultsController) {
        NSError *error;
        [self.alphabeticFetchedResultsController performFetch:&error];
        if (error) NSLog(@"[%@ %@] %@ (%@)", NSStringFromClass([self class]), NSStringFromSelector(_cmd), [error localizedDescription], [error localizedFailureReason]);
    }
}


#pragma mark - NSFetchedResultsControllerDelegate

- (void)controller:(NSFetchedResultsController *)controller
   didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath
     forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath
{
    if (!self.suspendAutomaticTrackingOfChangesInManagedObjectContext)
    {
        [self.tableView reloadData];
        if (self.shouldSelectFirstBook)
        {
            //[self performSelector:@selector(selectFirstBook) withObject:nil afterDelay:.1];
            [self selectFirstBook];
            
        }
            
    }
}

#pragma mark - select first book in none selected before
- (void)selectFirstBook
{
    [self tableView:self.tableView didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
    self.shouldSelectFirstBook = NO;
}


#pragma mark - UISearchBarDelegate
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [self changePredicatesWithSearch:searchBar.text];
    [self hideKeyboard];
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar{
 if ([searchBar.text isEqualToString:@""])
    [self changePredicatesWithSearch:@""];
    [self hideKeyboard];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    [self changePredicatesWithSearch:@""];
    [self hideKeyboard];
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    //Hack for dismiss Bar purposes
    [self.overlayButton removeFromSuperview];
    // add the button to the main view
    self.overlayButton = [[UIButton alloc] initWithFrame:self.view.frame];
    // set the background to black and have some transparency
    self.overlayButton.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
    // add an event listener to the button
    [self.overlayButton addTarget:self action:@selector(hideKeyboard) forControlEvents:UIControlEventTouchUpInside];
    // add to main view
    [self.view.superview addSubview:self.overlayButton];
    
    self.overlayButton.translatesAutoresizingMaskIntoConstraints = NO;

    int offset = self.navigationController.navigationBar.frame.size.height + self.searchBar.frame.size.height + 20;
    
    NSArray *constraints = @[
                             [NSLayoutConstraint constraintWithItem:self.overlayButton attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view.superview attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0.0],
                             [NSLayoutConstraint constraintWithItem:self.overlayButton attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view.superview attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:0.0],
                             [NSLayoutConstraint constraintWithItem:self.overlayButton attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view.superview attribute:NSLayoutAttributeTop multiplier:1.0 constant:offset],
                             [NSLayoutConstraint constraintWithItem:self.overlayButton attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view.superview attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0.0]
                             ];
    [self.view.superview addConstraints:constraints];
    [self.view.superview setNeedsLayout];
}

- (void)hideKeyboard
{
    // hide the keyboard
    [self.searchBar resignFirstResponder];
    // remove the overlay button
    [self.overlayButton removeFromSuperview];
}


#pragma mark - Change predicates

- (void)changePredicatesWithSearch:(NSString*)search
{
    NSPredicate *predicateTags;
    NSPredicate *predicateAlph;
    if (![search isEqualToString:@""])
    {
        
        predicateTags = [NSPredicate predicateWithFormat:@"(tag CONTAINS[cd] %@) OR (books.authors CONTAINS[cd] %@) or (books.title CONTAINS[cd] %@)", search, search, search];
        
        predicateAlph = [NSPredicate predicateWithFormat:@"(authors CONTAINS[cd] %@) or (title CONTAINS[cd] %@) or (tags.tag CONTAINS[cd] %@)", search, search, search];
    }
    
    self.tagsFetchedResultsController.fetchRequest.predicate = predicateTags;
    self.alphabeticFetchedResultsController.fetchRequest.predicate = predicateAlph;
    [self performTagsFetch];
    [self performAlphabeticFetch];
    
    [self.tableView reloadData];
    [self.view endEditing:YES];
    
}


@end



