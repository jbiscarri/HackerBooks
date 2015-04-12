//
//  AGTBookViewController.m
//  HackerBooks
//
//  Created by Joan on 28/03/15.
//  Copyright (c) 2015 Biscarri. All rights reserved.
//

#import "AGTBookViewController.h"
#import "Book.h"
#import "Settings.h"
#import "AGTSimplePDFViewController.h"
#import "AGTTableViewController.h"
#import "Photo.h"

@interface AGTBookViewController ()

@end

@implementation AGTBookViewController

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
    self.bookTitle.text = self.book.title;
    self.bookAuthors.text = self.book.authors;
    self.bookTags.text = [self.book tagsString];
    self.switchFavorite.on = self.book.isFavorite;
    
    [self.book.photo loadImageCompletion:^(UIImage *image) {
        self.bookImageView.image = image;
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Actions
- (IBAction)switchValueChanged:(id)sender {
    self.book.isFavorite = self.switchFavorite.on;
}

- (IBAction)showPDF:(id)sender {
    AGTSimplePDFViewController *simplePDFViewController = [[AGTSimplePDFViewController alloc] initWithBook:self.book];
    [self.navigationController pushViewController:simplePDFViewController animated:YES];
}

#pragma mark - AGTTableViewControllerDelegate

- (void)tableViewController:(AGTTableViewController*)tVC didSelectBook:(Book*)book{
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
