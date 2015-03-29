//
//  AGTBookViewController.m
//  HackerBooks
//
//  Created by Joan on 28/03/15.
//  Copyright (c) 2015 Biscarri. All rights reserved.
//

#import "AGTBookViewController.h"
#import "AGTBook.h"
#import "Settings.h"
#import "AGTSimplePDFViewController.h"
#import "AGTTableViewController.h"

@interface AGTBookViewController ()

@end

@implementation AGTBookViewController

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
    self.title = self.book.title;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [self syncWithModel];
    self.navigationItem.leftBarButtonItem = self.splitViewController.displayModeButtonItem;

}

- (void)syncWithModel
{
    self.bookImageView.image = nil;
    [self.activityIndicator startAnimating];
    self.bookTitle.text = self.book.title;
    self.bookAuthors.text = self.book.authors;
    self.bookTags.text = self.book.tags;
    self.switchFavorite.on = self.book.isFavorite;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        //Dowload Image
        if ([self.book.image_url isFileURL])
        {
            //Replace With current cachesDirectory
            NSFileManager *fileManager = [NSFileManager defaultManager];
            NSURL *fileUrl = [[fileManager URLsForDirectory:NSCachesDirectory
                                                  inDomains:NSUserDomainMask] lastObject];
            self.book.image_url = [fileUrl URLByAppendingPathComponent:[self.book.image_url.absoluteString lastPathComponent]];
        }
        
        NSData *data = [NSData dataWithContentsOfURL:self.book.image_url];
        //Save image if it's necessary
        if (![self.book.image_url isFileURL] || (data==nil)){
            NSFileManager *fileManager = [NSFileManager defaultManager];
            NSURL *fileUrl = [[fileManager URLsForDirectory:NSCachesDirectory
                                                  inDomains:NSUserDomainMask] lastObject];
            fileUrl = [fileUrl URLByAppendingPathComponent:[self.book.image_url.absoluteString lastPathComponent]];
            BOOL imageSaved = [data writeToURL:fileUrl atomically:YES];
            if (imageSaved){
                //Change Json File
                NSURL *jsonFileUrl = [[fileManager URLsForDirectory:NSDocumentDirectory
                                                          inDomains:NSUserDomainMask] lastObject];
                jsonFileUrl = [jsonFileUrl URLByAppendingPathComponent:JSON_FILE_NAME];
                NSError *error;
                NSString *stringData = [NSString stringWithContentsOfURL:jsonFileUrl encoding:NSUTF8StringEncoding error:&error];
                if (stringData){
                    //Replace url
                    stringData = [stringData stringByReplacingOccurrencesOfString:self.book.image_url.absoluteString withString:fileUrl.absoluteString];
                    //save file
                    BOOL result = [stringData writeToURL:jsonFileUrl atomically:YES encoding:NSUTF8StringEncoding error:&error];
                    if (!result)
                    {
                        NSLog(@"Error saving json file: %@", error.userInfo);
                    }else{
                        self.book.image_url = fileUrl;
                    }
                    
                }
                
            }
        }
        UIImage *image = [UIImage imageWithData:data];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.bookImageView.image = image;
            [self.activityIndicator stopAnimating];

        });
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Actions
- (IBAction)switchValueChanged:(id)sender {
    self.book.isFavorite = self.switchFavorite.on;
    NSDictionary *userInfo = @{NOT_BOOK_KEY:self.book};
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_FAVORITE_FOR_BOOK_CHANGED object:self userInfo:userInfo];
}

- (IBAction)showPDF:(id)sender {
    AGTSimplePDFViewController *simplePDFViewController = [[AGTSimplePDFViewController alloc] initWithBook:self.book];
    [self.navigationController pushViewController:simplePDFViewController animated:YES];
}

#pragma mark - AGTTableViewControllerDelegate

- (void)tableViewController:(AGTTableViewController*)tVC didSelectBook:(AGTBook*)book{
    self.book = book;
    [self syncWithModel];
}

#pragma mark - UISplitViewControllerDelegate
-(void) splitViewController:(UISplitViewController *)svc willChangeToDisplayMode:(UISplitViewControllerDisplayMode)displayMode{
    // Averiguar si la tabla se ve o no
    if (displayMode == UISplitViewControllerDisplayModePrimaryHidden) {
        
        // La tabla está oculta y cuelga del botón
        // Ponemos ese botón en mi barra de navegación
        self.navigationItem.leftBarButtonItem = svc.displayModeButtonItem;
    }else{
        // Se muestra la tabla: oculto el botón de la
        // barra de navegación
        self.navigationItem.leftBarButtonItem = nil;
    }
    
    
}

@end
