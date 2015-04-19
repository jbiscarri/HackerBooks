//
//  AnnotationMarker.h
//  HackerBooks
//
//  Created by Joan on 19/04/15.
//  Copyright (c) 2015 Biscarri. All rights reserved.
//

#import <UIKit/UIKit.h>
@import MapKit;
@class Annotation;

@interface AnnotationMarker : NSObject <MKAnnotation>

@property (nonatomic, strong) Annotation *annotation;
- (id)initWithAnnotation:(Annotation*)annotation;
- (MKMapItem*)mapItem;

@end
