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

@end

@implementation AGTTableViewController

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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.currentOrder == TAGS){
        return self.tagsFetchedResultsController.fetchedObjects.count + 1;
    }else{
        return 1;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (self.currentOrder == TAGS){
        if (section == 0)
            return @"FAVORITES";
        else{
            Tag *tag = self.tagsFetchedResultsController.fetchedObjects[section-1];
            return [tag.tag uppercaseString];
        }
    }else{
        return @"All";
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.currentOrder == TAGS){
        if (section == 0)
        {
            int favoritesCounter = 0;
            for (Book *b in self.alphabeticFetchedResultsController.fetchedObjects)
            {
                if (b.isFavorite)
                    favoritesCounter ++;
            }
            return favoritesCounter;
        }else{
            Tag *tag = self.tagsFetchedResultsController.fetchedObjects[section-1];
            return tag.books.count;
        }
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
    
    [self.delegate tableViewController:self didSelectBook:b];
    
    NSDictionary *userInfo = @{NOT_BOOK_KEY:b};
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_SELECTED_BOOK_CHANGED object:self userInfo:userInfo];
    
}

#pragma mark - Books lists helper
- (NSArray*)getBooksWithTagsAtIndexPath:(NSIndexPath*)indexPath
{
    NSArray *books;
    if (indexPath.section == 0)
    {
        NSMutableArray *favBooks = [NSMutableArray array];
        for (Book *b in self.alphabeticFetchedResultsController.fetchedObjects)
        {
            if (b.isFavorite)
                [favBooks addObject:b];
        }
        books = favBooks;
    }else{
        Tag *tag = self.tagsFetchedResultsController.fetchedObjects[indexPath.section-1];
        NSArray *tempBooks = [tag.books allObjects];
        books = [tempBooks sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            Book *b1 = obj1; Book *b2 = obj2;
            return [b1.title localizedCaseInsensitiveCompare:b2.title];
        }];
    }
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

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    if (!self.suspendAutomaticTrackingOfChangesInManagedObjectContext) {
        [self.tableView beginUpdates];
        self.beganUpdates = YES;
    }
}

- (void)controller:(NSFetchedResultsController *)controller
  didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex
     forChangeType:(NSFetchedResultsChangeType)type
{
    if (!self.suspendAutomaticTrackingOfChangesInManagedObjectContext)
    {
        switch(type)
        {
            case NSFetchedResultsChangeInsert:
                [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
                break;
                
            case NSFetchedResultsChangeDelete:
                [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
                break;
            default:
                break;
        }
    }
}


- (void)controller:(NSFetchedResultsController *)controller
   didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath
     forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath
{
    if (!self.suspendAutomaticTrackingOfChangesInManagedObjectContext)
    {
        switch(type)
        {
            case NSFetchedResultsChangeInsert:
                [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
                break;
                
            case NSFetchedResultsChangeDelete:
                [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
                break;
                
            case NSFetchedResultsChangeUpdate:
                [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
                break;
                
            case NSFetchedResultsChangeMove:
                [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
                [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
                break;
        }
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    if (self.beganUpdates) [self.tableView endUpdates];
}

- (void)endSuspensionOfUpdatesDueToContextChanges
{
    _suspendAutomaticTrackingOfChangesInManagedObjectContext = NO;
}

- (void)setSuspendAutomaticTrackingOfChangesInManagedObjectContext:(BOOL)suspend
{
    if (suspend) {
        _suspendAutomaticTrackingOfChangesInManagedObjectContext = YES;
    } else {
        [self performSelector:@selector(endSuspensionOfUpdatesDueToContextChanges) withObject:0 afterDelay:0];
    }
}




@end



