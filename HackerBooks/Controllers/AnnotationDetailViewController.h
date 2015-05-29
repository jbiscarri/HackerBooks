//
//  AnnotationDetailViewController.h
//  HackerBooks
//
//  Created by Joan on 17/04/15.
//  Copyright (c) 2015 Biscarri. All rights reserved.
//

#import <UIKit/UIKit.h>
@import MapKit;

@class Annotation;

@interface AnnotationDetailViewController : UIViewController<UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIActionSheetDelegate, CLLocationManagerDelegate>
@property (strong, nonatomic) Annotation *annotation;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) CLLocation *currentLocation;
@property (strong, nonatomic) NSString *currentAddress;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *shareButton;

@property (weak, nonatomic) IBOutlet UITextView *comment;
@property (weak, nonatomic) IBOutlet UIImageView *picture;

- (IBAction)addPicture:(id)sender;
- (instancetype)initWithAnnotation:(Annotation*)annotation;

- (IBAction)deletePicture:(id)sender;
- (IBAction)share:(id)sender;

- (IBAction)removeAnnotation:(id)sender;

@end
