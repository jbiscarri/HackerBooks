//
//  AGTSimplePDFViewController.h
//  HackerBooks
//
//  Created by Joan on 29/03/15.
//  Copyright (c) 2015 Biscarri. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AGTBook;

@interface AGTSimplePDFViewController : UIViewController<UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (strong, nonatomic) AGTBook *book;

- (instancetype)initWithBook:(AGTBook*)book;

@end
