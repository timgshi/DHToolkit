//
//  PFObject+DHPhoto_MKAnnotation.m
//  DHToolkit
//
//  Created by Tim Shi on 2/17/12.
//  Copyright (c) 2012 www.timshi.com. All rights reserved.
//

#import "PFObject+DHPhoto_MKAnnotation.h"

@implementation PFObject (DHPhoto_MKAnnotation)

- (NSString *)title
{
    return [self objectForKey:@"DHDataSixWord"];
}

- (CLLocationCoordinate2D) coordinate
{
    double lat = [[self objectForKey:@"DHDataGeoLat"] doubleValue];
    double lon = [[self objectForKey:@"DHDataGeoLong"] doubleValue];
    return CLLocationCoordinate2DMake(lat, lon);
}


@end
