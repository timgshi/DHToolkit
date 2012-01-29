//
//  ParseFetcher.h
//  DHToolkit
//
//  Created by Tim Shi on 12/23/11.
//  Copyright (c) 2011 www.timshi.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PFQuery;
@class PFObject;

@interface ParseFetcher

+ (PFQuery *)newDHPhotosQuery;

+ (NSData *)loadPhotoDataForPhotoObject:(PFObject *)photoObject;

+ (NSData *)photoDataForPhotoObject:(PFObject *)photoObject;

@end
