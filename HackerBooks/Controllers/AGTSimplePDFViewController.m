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
#import "Annotation.h"
#import "AnnotationsCollectionViewController.h"
#import "AnnotationDetailViewController.h"
#import "MapViewController.h"
@import CoreGraphics;

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
    [self syncWithModel];
    [self updateRightButton];
    self.webView.scrollView.delegate = self;
    self.currentPage = 0;
    self.numberOfPages = 0;
    self.pdfPageHeight = -1;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    self.edgesForExtendedLayout = UIRectEdgeNone;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notifiedBookHasBeenChanged:) name:NOTIFICATION_SELECTED_BOOK_CHANGED object:nil];
    self.book.pdf.cancelDownload = NO;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    self.book.pdf.cancelDownload = YES;
    if ((self.currentPage > 0) && (self.currentPage > self.book.lastReadPageValue))
    {
        self.book.lastReadPageValue = self.currentPage;
    }
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
            //[self.navigationController popViewControllerAnimated:YES];
        }else{
            [self.webView loadData:pdf
                          MIMEType:@"application/pdf"
                  textEncodingName:@"UTF-8"
                           baseURL:nil];
            self.numberOfPages = (int)[self getTotalPDFPages:pdf];
        }
    }];
}


#pragma mark - Right Button
- (void)updateRightButton
{
    //Add right button to navigator to change Book Order
    if (!self.navigationItem.rightBarButtonItem){
        UIBarButtonItem *button = [[UIBarButtonItem alloc] initWithTitle:@""
                                                                   style:UIBarButtonItemStylePlain
                                                                  target:self
                                                                  action:@selector(goToAnnotations:)];
        self.navigationItem.rightBarButtonItem = button;
    }
    [self.navigationItem.rightBarButtonItem setTitle:@"Annotations"];
    
}

#pragma mark - PDF Management

- (NSInteger)getTotalPDFPages:(NSData *)PDFData
{
    CGPDFDocumentRef document = CGPDFDocumentCreateWithProvider(CGDataProviderCreateWithCFData((CFDataRef)PDFData));
    size_t pageCount = CGPDFDocumentGetNumberOfPages(document);
    return pageCount;
}


#pragma mark - NOTIFICATIONS

//NOTIFICATION_SELECTED_BOOK_CHANGED
- (void)notifiedBookHasBeenChanged:(NSNotification*)notification
{
    Book *book = notification.userInfo[NOT_BOOK_KEY];
    self.book = book;
    [self syncWithModel];
}

- (IBAction)goToAnnotations:(id)sender {
    UITabBarController *tabBarController = [[UITabBarController alloc] initWithNibName:nil bundle:nil];
    
    UICollectionViewFlowLayout* flowLayout = [[UICollectionViewFlowLayout alloc]init];
    flowLayout.itemSize = CGSizeMake(160, 160);
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    
    AnnotationsCollectionViewController *annotationsCollectionViewController = [[AnnotationsCollectionViewController alloc] initWithBook:self.book];
    annotationsCollectionViewController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"List" image:[UIImage imageNamed:@"Folder.png"] selectedImage:nil];

    
    MapViewController *mapVC =[[MapViewController alloc] init];
    
    mapVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Map" image:[UIImage imageNamed:@"Scanner.png"] selectedImage:nil];
    
    
    NSFetchRequest *req = [NSFetchRequest fetchRequestWithEntityName:[Annotation entityName]];
    req.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:AnnotationAttributes.modificationDate
                                                          ascending:NO]];
    req.fetchBatchSize = 20;
    
    req.predicate = [NSPredicate predicateWithFormat:@"book = %@", self.book];
    
    NSFetchedResultsController *fc = [[NSFetchedResultsController alloc] initWithFetchRequest:req
                                                                         managedObjectContext:self.book.managedObjectContext
                                                                           sectionNameKeyPath:nil
                                                                                    cacheName:nil];
    annotationsCollectionViewController.fetchedResultsController = fc;
    mapVC.fetchedResultsController = fc;
    

    
    [tabBarController setViewControllers:@[annotationsCollectionViewController, mapVC]];
    
    //Add right button to tab bar
    UIBarButtonItem *button = [[UIBarButtonItem alloc] initWithTitle:@"Add New"
                                                               style:UIBarButtonItemStylePlain
                                                              target:self
                                                              action:@selector(addNewAnnotation:)];

    tabBarController.navigationItem.rightBarButtonItem = button;
    [self.navigationController pushViewController:tabBarController animated:YES];
    
}

- (void)addNewAnnotation:(id)sender
{
    Annotation *annotation = [Annotation insertInManagedObjectContext:self.book.managedObjectContext];
    annotation.creationDate = [NSDate date];
    annotation.book = self.book;
    AnnotationDetailViewController *annotationVC = [[AnnotationDetailViewController alloc] initWithAnnotation:annotation];
    [self.navigationController pushViewController:annotationVC animated:YES];
}

#pragma mark - UIScrollView
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    // if pdfPageHeight is -1 it needs to be calculated
    if(self.pdfPageHeight == -1)
    {
        // the page height is calculated by taking the overall size of the UIWebView scrollView content size
        // then dividing it by the number of pages Core Graphics reported for the PDF file being shown
        CGFloat contentHeight = self.webView.scrollView.contentSize.height;
        self.pdfPageHeight = contentHeight / self.numberOfPages;
        
        // also calculate what half the screen height is. no sense in doing this multiple times.
        self.halfScreenHeight = (self.webView.frame.size.height / 2);
    }
    
    // to calculate the page number, first get how far the user has scrolled
    float verticalContentOffset = self.webView.scrollView.contentOffset.y;
    
    // next add the halfScreenHeight then divide the result by the guesstimated pdfPageHeight
    self.currentPage = ceilf((verticalContentOffset + self.halfScreenHeight) / self.pdfPageHeight);
}

@end
