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

@property (weak, nonatomic) IBOutlet UIButton *AnnotationsButton;

- (instancetype)initWithBook:(Book*)book;
- (IBAction)goToAnnotations:(id)sender;

@end
