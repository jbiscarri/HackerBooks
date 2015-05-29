//
//  AnnotationDetailViewController.m
//  HackerBooks
//
//  Created by Joan on 17/04/15.
//  Copyright (c) 2015 Biscarri. All rights reserved.
//

#import "AnnotationDetailViewController.h"
#import "Annotation.h"
#import "Photo.h"
#import "Localization.h"
#import "Settings.h"


@interface AnnotationDetailViewController ()
@property (strong, nonatomic) UIView *activeField;
@end

@implementation AnnotationDetailViewController

- (instancetype)initWithAnnotation:(Annotation*)annotation
{
    if (self = [super initWithNibName:nil bundle:nil])
    {
        self.annotation = annotation;
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.delegate = self;
        self.locationManager.distanceFilter = kCLDistanceFilterNone;
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
            [self.locationManager requestWhenInUseAuthorization];

        [self.locationManager startUpdatingLocation];
    }
    return self;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyBoard:)];
    [self.scrollView addGestureRecognizer:gestureRecognizer];

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self syncModel];
    [self registerForKeyboardNotifications];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notifiedBookHasBeenChanged:) name:NOTIFICATION_SELECTED_BOOK_CHANGED object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
      [[NSNotificationCenter defaultCenter] removeObserver:self];
    self.annotation.text = self.comment.text;
    if (self.annotation.localization == nil){
        Localization *localization = [Localization insertInManagedObjectContext:self.annotation.managedObjectContext];
        self.annotation.localization = localization;
    }
    self.annotation.localization.latitude = @(self.currentLocation.coordinate.latitude);
    self.annotation.localization.longitude = @(self.currentLocation.coordinate.longitude);
    self.annotation.localization.address = self.currentAddress;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self.annotation.managedObjectContext save:nil];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
- (void)syncModel
{
    self.comment.text = self.annotation.text;
    self.picture.image = self.annotation.photo.image;
}

#pragma mark - Actions
- (IBAction)addPicture:(id)sender {
       [self showActionSheet];
}

#pragma mark -  UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage * img = [info objectForKey:UIImagePickerControllerOriginalImage];
    if (self.annotation.photo == nil){
        Photo *photo = [Photo insertInManagedObjectContext:self.annotation.managedObjectContext];
        self.annotation.photo = photo;
    }
    self.annotation.photo.image = img;
    [self dismissViewControllerAnimated:YES
                             completion:^{ }];
}


#pragma mark - ActionSheet
- (void)showActionSheet
{
    NSString *actionSheetTitle = @"Select image source"; //Action Sheet Title
    //NSString *destructiveTitle = @"Delete image"; //Action Sheet Button Titles
    NSString *other1 = @"Camera roll";
    NSString *other2 = @"Photo Library";
    NSString *other3 = @"My Albums";
    NSString *cancelTitle = @"Close";
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:actionSheetTitle
                                  delegate:self
                                  cancelButtonTitle:cancelTitle
//                                destructiveButtonTitle:destructiveTitle
                                  destructiveButtonTitle:nil
                                  otherButtonTitles:other1, other2, other3, nil];
    [actionSheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)popup clickedButtonAtIndex:(NSInteger)buttonIndex {
    
            switch (buttonIndex) {
                case 0:
                    [self showCamera:UIImagePickerControllerSourceTypeCamera];
                    break;
                case 1:
                    [self showCamera:UIImagePickerControllerSourceTypePhotoLibrary];
                    break;
                case 2:
                    [self showCamera:UIImagePickerControllerSourceTypeSavedPhotosAlbum];
                    break;
                case 3:
                    //[self rateAppYes];
                    break;
                default:
                    break;
            }
       }

- (void)showCamera:(UIImagePickerControllerSourceType)type{
     UIImagePickerController  *picker = [UIImagePickerController new];
     
     if ([UIImagePickerController isSourceTypeAvailable:type]){
         picker.sourceType = type;
     }else{
         picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
     }
     picker.delegate = self;
     
     picker.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self performSelector: @selector(presentVC:) withObject:picker afterDelay: .1];
}

- (void)presentVC:(UIImagePickerController*)picker
{
    [self presentViewController:picker
                    animated:YES
                  completion:^{ }];


}
- (IBAction)deletePhoto:(id)sender {
    if (self.annotation.photo != nil){

        self.annotation.photo.image = nil;
        CGRect oldRect = self.picture.bounds;
        [UIView animateWithDuration:.3
                         animations:^{
                             self.picture.alpha = 0;
                             self.picture.bounds = CGRectZero;
                         } completion:^(BOOL finished) {
                             self.picture.image = nil;
                             self.picture.alpha = 1;
                             self.picture.bounds = oldRect;
                         }];
    }
    
}

- (IBAction)deletePicture:(id)sender {
    [self deletePhoto:nil];
}

- (IBAction)share:(id)sender {
    if (self.annotation.text != nil){
        NSString * message = self.annotation.text;
        NSMutableArray *shareItems = [NSMutableArray arrayWithObject:message];
        /*
        UIImage * image = [self.annotation.photo.image copy];
        if (image)
            [shareItems addObject:image];
         */
            
        UIActivityViewController * avc = [[UIActivityViewController alloc] initWithActivityItems:shareItems applicationActivities:nil];
        avc.popoverPresentationController.barButtonItem = self.shareButton;
        [self performSelector: @selector(presentVC:) withObject:avc afterDelay: .1];
    }
}

- (IBAction)removeAnnotation:(id)sender {
    [self.annotation.managedObjectContext deleteObject:self.annotation];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - CLLocation
- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation
{
    self.currentLocation = newLocation;
    [self addressFromLocation:self.currentLocation];
}

- (void)addressFromLocation: (CLLocation *) aLocation{
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:aLocation
                   completionHandler:^(NSArray *placemarks, NSError *error) {
                       if (placemarks && placemarks.count > 0) {
                           CLPlacemark *placemark = [placemarks objectAtIndex:0];
                           self.currentAddress = [NSString stringWithFormat:@"%@ %@, %@ %@",
                                               [placemark subThoroughfare],
                                               [placemark thoroughfare],
                                               [placemark locality],
                                               [placemark administrativeArea]];
                       }else{
                           self.currentAddress = @"Not found";
                       }
                      
                   }];
}

#pragma mark - Keyboard management
- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
    
}

// Called when the UIKeyboardDidShowNotification is sent.
- (void)keyboardWasShown:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);
    self.scrollView.contentInset = contentInsets;
    self.scrollView.scrollIndicatorInsets = contentInsets;
    
    // If active text field is hidden by keyboard, scroll it so it's visible
    // Your app might not need or want this behavior.
    CGRect aRect = self.view.frame;
    aRect.size.height -= kbSize.height;
    if (!CGRectContainsPoint(aRect, self.activeField.frame.origin) ) {
        [self.scrollView scrollRectToVisible:self.activeField.frame animated:YES];
    }
}

// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    self.scrollView.contentInset = contentInsets;
    self.scrollView.scrollIndicatorInsets = contentInsets;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    self.activeField = textField;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    self.activeField = nil;
}

#pragma mark - Dismiss keyboard
- (void)hideKeyBoard:(UITapGestureRecognizer*)recognizer
{
    [self.view endEditing:YES];
}

#pragma mark - NOTIFICATIONS

//NOTIFICATION_SELECTED_BOOK_CHANGED
- (void)notifiedBookHasBeenChanged:(NSNotification*)notification
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

@end
