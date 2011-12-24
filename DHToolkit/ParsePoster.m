//
//  ParsePoster.m
//  DHToolkit
//
//  Created by Tim Shi on 12/24/11.
//  Copyright (c) 2011 www.timshi.com. All rights reserved.
//

#import "ParsePoster.h"
#import "Parse/PFObject.h"
#import "Parse/PFFile.h"

@implementation ParsePoster

+ (void)postPhotoWithMetaInfo:(NSDictionary *)metaDict andPhotoData:(NSData *)photoData
{
    PFObject *newPhoto = [PFObject objectWithClassName:@"DHPhoto"];
    for (NSString *key in [metaDict allKeys]) {
        [newPhoto setObject:[metaDict objectForKey:key] forKey:key];
    }
    PFFile *photoFile = [PFFile fileWithData:photoData];
    [photoFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error1) {
        if (error1 != nil) {
            NSLog(@"%@", [error1 description]);
        }
        if (succeeded) {
            [newPhoto setObject:photoFile forKey:@"photoData"];
            [newPhoto saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error2) {
                if (error2 != nil) {
                    NSLog(@"%@", [error2 description]);
                }
                if (succeeded) {
                    
                }
            }];
        }
    }];
}

@end
