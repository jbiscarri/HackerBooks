//
//  AGTSimplePDFViewController.m
//  HackerBooks
//
//  Created by Joan on 29/03/15.
//  Copyright (c) 2015 Biscarri. All rights reserved.
//

#import "AGTSimplePDFViewController.h"
#import "Book.h"
#import "Pdf.h"
#import "Settings.h"

@interface AGTSimplePDFViewController ()

@end

@implementation AGTSimplePDFViewController

- (instancetype)initWithBook:(Book*)book
{
    if (self = [super initWithNibName:nil bundle:nil])
    {
        _book = book;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self syncWithModel];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notifiedBookHasBeenChanged:) name:NOTIFICATION_SELECTED_BOOK_CHANGED object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIWebViewDelegate
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [self.activityIndicator stopAnimating];
    self.webView.hidden = NO;
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    [self.activityIndicator stopAnimating];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Util
- (void)syncWithModel
{
    [self.activityIndicator startAnimating];
    self.webView.hidden = YES;

    [self.book.pdf loadPdfCompletion:^(NSData *pdf) {
        if (!pdf){
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Pdf Error" message:@"BOOK file not found" delegate:nil cancelButtonTitle:@"Accept" otherButtonTitles:nil];
            [alert show];
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [self.webView loadData:pdf
                          MIMEType:@"application/pdf"
                  textEncodingName:@"UTF-8"
                           baseURL:nil];
        }
    }];
}


#pragma mark - NOTIFICATIONS

//NOTIFICATION_SELECTED_BOOK_CHANGED
- (void)notifiedBookHasBeenChanged:(NSNotification*)notification
{
    Book *book = notification.userInfo[NOT_BOOK_KEY];
    self.book = book;
    [self syncWithModel];
}

@end
