//
//  AGTPDFViewController.m
//  HackerBooks
//
//  Created by Joan on 30/03/15.
//  Copyright (c) 2015 Biscarri. All rights reserved.
//

#import "AGTPDFViewController.h"
#import "ReaderDocument.h"
#import "AGTBook.h"
#import "Settings.h"
#import "NSLayoutConstraint+Lazy.h"

@interface AGTPDFViewController ()
    @property (nonatomic, strong) ReaderViewController *readerViewController;
@end

@implementation AGTPDFViewController

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
    [self syncWithModel];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
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

- (void)showPDF:(NSString*)filePath
{
    NSString *phrase = nil; // Document password (for unlocking most encrypted PDF files)
    filePath = [filePath stringByReplacingOccurrencesOfString:@"file://" withString:@""];
    ReaderDocument *document = [ReaderDocument withDocumentFilePath:filePath password:phrase];
    
    if (document != nil) // Must have a valid ReaderDocument object in order to proceed with things
    {
         self.readerViewController = [[ReaderViewController alloc] initWithReaderDocument:document];        
        self.readerViewController.delegate = self; // Set the ReaderViewController
        
        self.readerViewController.view.frame = self.view.frame;
        [self.view addSubview:self.readerViewController.view];
        
        [NSLayoutConstraint fitView:self.readerViewController.view inSuperview:self.view];
    }
    else // Log an error so that we know that something went wrong
    {
        NSLog(@"%s [ReaderDocument withDocumentFilePath:'%@' password:'%@'] failed.", __FUNCTION__, filePath, phrase);
    }
}

#pragma mark - manage data source
- (void)syncWithModel
{
    if (self.readerViewController )
        [self.readerViewController.view removeFromSuperview];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
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
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self showPDF:fileUrl.absoluteString];
                });
            }
        }else{
            [self showPDF:self.book.pdf_url.absoluteString];
        }
        
    });
}

#pragma mark - ReaderViewControllerDelegate

- (void)dismissReaderViewController:(ReaderViewController *)viewController{
    [self.navigationController popToRootViewControllerAnimated:YES];
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
