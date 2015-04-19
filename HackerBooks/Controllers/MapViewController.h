//
//  MapViewController.h
//  HackerBooks
//
//  Created by Joan on 18/04/15.
//  Copyright (c) 2015 Biscarri. All rights reserved.
//

#import <UIKit/UIKit.h>
@import MapKit;
@import CoreData;

@interface MapViewController : UIViewController<NSFetchedResultsControllerDelegate>
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;


@end
