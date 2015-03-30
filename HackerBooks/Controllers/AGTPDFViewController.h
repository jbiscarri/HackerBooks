//
//  AGTPDFViewController.h
//  HackerBooks
//
//  Created by Joan on 30/03/15.
//  Copyright (c) 2015 Biscarri. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ReaderViewController.h"

@class AGTBook;


@interface AGTPDFViewController : UIViewController<ReaderViewControllerDelegate>
@property (strong, nonatomic) AGTBook *book;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;


- (instancetype)initWithBook:(AGTBook*)book;

@end
