//
//  AGTSimplePDFViewController.h
//  HackerBooks
//
//  Created by Joan on 29/03/15.
//  Copyright (c) 2015 Biscarri. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Book;

@interface AGTSimplePDFViewController : UIViewController<UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (strong, nonatomic) Book *book;

- (instancetype)initWithBook:(Book*)book;
- (IBAction)addAnnotation:(id)sender;

@end
