//
//  AnnotationsCollectionViewController.h
//  HackerBooks
//
//  Created by Joan on 18/04/15.
//  Copyright (c) 2015 Biscarri. All rights reserved.
//

#import <UIKit/UIKit.h>
@import CoreData;
@class Book;


@interface AnnotationsCollectionViewController : UIViewController<NSFetchedResultsControllerDelegate, UICollectionViewDelegate, UICollectionViewDataSource>

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) Book *book;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

- (instancetype)initWithBook:(Book*)book;

@end
