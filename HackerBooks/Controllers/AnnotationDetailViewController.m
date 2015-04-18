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


@interface AnnotationDetailViewController ()

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

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self syncModel];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.annotation.text = self.comment.text;
    if (self.annotation.localization == nil){
        Localization *localization = [Localization insertInManagedObjectContext:self.annotation.managedObjectContext];
        self.annotation.localization = localization;
    }
    self.annotation.localization.latitude = @(self.currentLocation.coordinate.latitude);
    self.annotation.localization.longitude = @(self.currentLocation.coordinate.longitude);
    self.annotation.localization.address = self.currentAddress;


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
    NSString *destructiveTitle = @"Delete image"; //Action Sheet Button Titles
    NSString *other1 = @"Camera roll";
    NSString *other2 = @"Photo Library";
    NSString *other3 = @"My Albums";
    NSString *cancelTitle = @"Close";
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:actionSheetTitle
                                  delegate:self
                                  cancelButtonTitle:cancelTitle
                                  destructiveButtonTitle:destructiveTitle
                                  otherButtonTitles:other1, other2, other3, nil];
    [actionSheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)popup clickedButtonAtIndex:(NSInteger)buttonIndex {
    
            switch (buttonIndex) {
                case 0:
                    [self deletePhoto:nil];
                    break;
                case 1:
                    [self showCamera:UIImagePickerControllerSourceTypeCamera];
                    break;
                case 2:
                    [self showCamera:UIImagePickerControllerSourceTypePhotoLibrary];
                    break;
                case 3:
                    [self showCamera:UIImagePickerControllerSourceTypeSavedPhotosAlbum];
                    break;
                case 4:
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
     
    [self presentViewController:picker
                       animated:YES
                     completion:^{ }];
}

- (IBAction)deletePhoto:(id)sender {
    if (self.annotation.photo == nil){

        self.annotation.photo.image = nil;
        CGRect oldRect = self.picture.bounds;
        [UIView animateWithDuration:.5
                         animations:^{
                             self.picture.alpha = 0;
                             self.picture.bounds = CGRectZero;
                             //self.picture.transform = CGAffineTransformMakeRotation(M_PI);
                         } completion:^(BOOL finished) {
                             self.picture.image = nil;
                             self.picture.alpha = 1;
                             self.picture.bounds = oldRect;
                             //self.picture.transform = CGAffineTransformIdentity;
                         }];
    }
    
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

@end
