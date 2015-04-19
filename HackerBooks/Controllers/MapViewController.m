//
//  MapViewController.m
//  HackerBooks
//
//  Created by Joan on 18/04/15.
//  Copyright (c) 2015 Biscarri. All rights reserved.
//

#import "MapViewController.h"
#import "AnnotationMarker.h"

@interface MapViewController ()

@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self performFetch];
    [self populateMap];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Populate MAP
- (void)populateMap
{
    for (Annotation *annotation in self.fetchedResultsController.fetchedObjects)
    {
        AnnotationMarker *annotationMarker = [[AnnotationMarker alloc] initWithAnnotation:annotation];
        [self.mapView addAnnotation:annotationMarker];
    }
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
    [self populateMap];
}

@end