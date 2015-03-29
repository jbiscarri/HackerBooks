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
    //Dowload PDF
    if ([self.book.pdf_url isFileURL])
    {
        //Replace With current cachesDirectory
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSURL *fileUrl = [[fileManager URLsForDirectory:NSCachesDirectory
                                              inDomains:NSUserDomainMask] lastObject];
        self.book.pdf_url = [fileUrl URLByAppendingPathComponent:[self.book.pdf_url.absoluteString lastPathComponent]];
    }
    
    NSData *data = [NSData dataWithContentsOfURL:self.book.pdf_url];
    //Save image if it's necessary
    if (![self.book.pdf_url isFileURL] || (data==nil)){
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSURL *fileUrl = [[fileManager URLsForDirectory:NSCachesDirectory
                                              inDomains:NSUserDomainMask] lastObject];
        fileUrl = [fileUrl URLByAppendingPathComponent:[self.book.pdf_url.absoluteString lastPathComponent]];
        BOOL pdfSaved = [data writeToURL:fileUrl atomically:YES];
        if (pdfSaved){
            //Change Json File
            NSURL *jsonFileUrl = [[fileManager URLsForDirectory:NSDocumentDirectory
                                                      inDomains:NSUserDomainMask] lastObject];
            jsonFileUrl = [jsonFileUrl URLByAppendingPathComponent:JSON_FILE_NAME];
            NSError *error;
            NSString *stringData = [NSString stringWithContentsOfURL:jsonFileUrl encoding:NSUTF8StringEncoding error:&error];
            if (stringData){
                //Replace url
                stringData = [stringData stringByReplacingOccurrencesOfString:self.book.pdf_url.absoluteString withString:fileUrl.absoluteString];
                //save file
                BOOL result = [stringData writeToURL:jsonFileUrl atomically:YES encoding:NSUTF8StringEncoding error:&error];
                if (!result)
                {
                    NSLog(@"Error saving json file: %@", error.userInfo);
                }else{
                    self.book.pdf_url = fileUrl;
                }
                
            }
            
        }
    }
    [self.webView loadData:data MIMEType:@"application/pdf" textEncodingName:@"utf-8" baseURL:nil];
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
