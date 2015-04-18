//
//  AnnotationsCollectionViewController.m
//  HackerBooks
//
//  Created by Joan on 18/04/15.
//  Copyright (c) 2015 Biscarri. All rights reserved.
//

#import "AnnotationsCollectionViewController.h"
#import "AnnotationsViewCell.h"
#import "Annotation.h"
#import "Photo.h"
#import "Book.h"
#import "AnnotationDetailViewController.h"

@interface AnnotationsCollectionViewController ()

@end

@implementation AnnotationsCollectionViewController

- (instancetype)initWithBook:(Book*)book
{
    if (self = [super initWithNibName:nil bundle:nil])
    {
        self.book = book;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    UINib *cellNib = [UINib nibWithNibName:@"AnnotationsViewCell" bundle:nil];
    [self.collectionView registerNib:cellNib forCellWithReuseIdentifier:@"collectionCell"];
    self.edgesForExtendedLayout = UIRectEdgeNone;    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self performFetch];
    [self.collectionView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark <UICollectionViewDataSource>


- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    int results =  (int)self.fetchedResultsController.fetchedObjects.count;
    return results;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    AnnotationsViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"collectionCell" forIndexPath:indexPath];
    Annotation *annotation = [self.fetchedResultsController objectAtIndexPath:indexPath];
    [annotation.photo loadImageCompletion:^(UIImage *image) {
        cell.colImage.image = image;
    }];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd/MM/yyyy HH:mm:ss"];
    
    cell.colText.text = [formatter stringFromDate:annotation.modificationDate];    
        
    cell.backgroundColor = [UIColor redColor];
    return cell;
     
    return cell;
}


#pragma mark <UICollectionViewDelegate>

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath;
{
    Annotation *annotation = [self.fetchedResultsController objectAtIndexPath:indexPath];
    AnnotationDetailViewController *annotationDetailVC = [[AnnotationDetailViewController alloc] initWithAnnotation:annotation];
    [self.navigationController pushViewController:annotationDetailVC animated:YES];
}


#pragma mark - NSFetchedResultsController

- (void)performFetch
{
    if (self.fetchedResultsController) {
        NSError *error;
        [self.fetchedResultsController performFetch:&error];
        if (error) NSLog(@"[%@ %@] %@ (%@)", NSStringFromClass([self class]), NSStringFromSelector(_cmd), [error localizedDescription], [error localizedFailureReason]);
    }
}

- (void)controller:(NSFetchedResultsController *)controller
   didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath
     forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath
{
        [self.collectionView reloadData];
}







@end
