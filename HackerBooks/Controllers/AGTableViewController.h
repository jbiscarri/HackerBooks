//
//  AGTableViewController.h
//  HackerBooks
//
//  Created by Joan on 28/03/15.
//  Copyright (c) 2015 Biscarri. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AGTLibrary;

@interface AGTableViewController : UITableViewController


@property (nonatomic, strong) AGTLibrary *library;

- (instancetype)initWithLibrary:(AGTLibrary*)library style:(UITableViewStyle)style;

@end
