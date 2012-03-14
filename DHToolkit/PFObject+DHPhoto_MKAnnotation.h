//
//  PFObject+DHPhoto_MKAnnotation.h
//  DHToolkit
//
//  Created by Tim Shi on 2/17/12.
//  Copyright (c) 2012 www.timshi.com. All rights reserved.
//

#import <Parse/Parse.h>
#import "Parse/PFObject.h"
#import <MapKit/MapKit.h>

@interface PFObject (DHPhoto_MKAnnotation) <MKAnnotation>

@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property (nonatomic, readonly, copy) NSString *title;

@end
