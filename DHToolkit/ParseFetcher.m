//
//  ParseFetcher.m
//  DHToolkit
//
//  Created by Tim Shi on 12/23/11.
//  Copyright (c) 2011 www.timshi.com. All rights reserved.
//

#import "ParseFetcher.h"
#import "Parse/PFQuery.h"

#define kDH_STANDARD_PHOTO_LIMIT 20

@implementation ParseFetcher

+ (PFQuery *)newDHPhotosQuery
{
    PFQuery *query = [PFQuery queryWithClassName:@"DHPhoto"];
    [query includeKey:@"pfUser"];
    [query orderByDescending:@"DHDataTimestamp"];
    [query setLimit:[NSNumber numberWithInt:kDH_STANDARD_PHOTO_LIMIT]];
    return query;
}

@end
