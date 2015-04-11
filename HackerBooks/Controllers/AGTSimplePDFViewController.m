//
//  AGTSimplePDFViewController.m
//  HackerBooks
//
//  Created by Joan on 29/03/15.
//  Copyright (c) 2015 Biscarri. All rights reserved.
//

#import "AGTSimplePDFViewController.h"
#import "AGTBook.h"
#import "Settings.h"

@interface AGTSimplePDFViewController ()

@end

@implementation AGTSimplePDFViewController

- (instancetype)initWithBook:(AGTBook*)book
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
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    [self.activityIndicator stopAnimating];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Util
- (void)syncWithModel
{
    //Replace With current cachesDirectory
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSURL *folderFileUrl = [[fileManager URLsForDirectory:NSCachesDirectory
                                          inDomains:NSUserDomainMask] lastObject];
    NSURL *pdfFileUrl = [folderFileUrl URLByAppendingPathComponent:[self.book.pdf_url.absoluteString lastPathComponent]];
    
    NSData *data;
    BOOL pdfLoaded = NO;
    if ([fileManager fileExistsAtPath:pdfFileUrl.path])
    {
        //Load file
        data = [NSData dataWithContentsOfURL:pdfFileUrl];
        pdfLoaded = YES;
    }
    
    //Save image if it's necessary
    if (data==nil){
        data = [NSData dataWithContentsOfURL:self.book.pdf_url];
        if ([data writeToURL:pdfFileUrl atomically:YES])
            pdfLoaded = YES;
        
    }
    if (pdfLoaded)
        [self.webView loadData:data MIMEType:@"application/pdf" textEncodingName:@"utf-8" baseURL:nil];
    else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Pdf Error" message:@"BOOK file not found" delegate:nil cancelButtonTitle:@"Accept" otherButtonTitles:nil];
        [alert show];
        [self.navigationController popViewControllerAnimated:YES];
    }
}


#pragma mark - NOTIFICATIONS

//NOTIFICATION_SELECTED_BOOK_CHANGED
- (void)notifiedBookHasBeenChanged:(NSNotification*)notification
{
    AGTBook *book = notification.userInfo[NOT_BOOK_KEY];
    self.book = book;
    [self syncWithModel];
}

@end
