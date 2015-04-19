//
//  AnnotationMarker.m
//  HackerBooks
//
//  Created by Joan on 19/04/15.
//  Copyright (c) 2015 Biscarri. All rights reserved.
//

#import "AnnotationMarker.h"
#import "Annotation.h"
#import "Localization.h"

@implementation AnnotationMarker

- (id)initWithAnnotation:(Annotation*)annotation
{
    if (self = [super init])
    {
        self.annotation = annotation;
    }
    return self;
}

- (NSString *)title {
    return self.annotation.localization.address;
}

- (NSString *)subtitle {
    return self.annotation.text;
}

- (CLLocationCoordinate2D)coordinate {
    CLLocationCoordinate2D location = CLLocationCoordinate2DMake([self.annotation.localization.latitude doubleValue],  [self.annotation.localization.longitude doubleValue]);
    return location;
}

- (MKMapItem*)mapItem {
    MKPlacemark *placemark = [[MKPlacemark alloc] initWithCoordinate:self.coordinate addressDictionary:nil];
    MKMapItem *mapItem = [[MKMapItem alloc] initWithPlacemark:placemark];
    return mapItem;
}




@end
