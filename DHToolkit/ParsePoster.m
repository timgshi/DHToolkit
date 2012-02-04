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
#import "Parse/PFUser.h"
#import "Parse/PFACL.h"

@implementation ParsePoster

+ (void)postPhotoWithMetaInfo:(NSDictionary *)metaDict andPhotoData:(NSData *)photoData
{
    PFObject *newPhoto = [PFObject objectWithClassName:@"DHPhoto"];
    for (NSString *key in [metaDict allKeys]) {
        [newPhoto setObject:[metaDict objectForKey:key] forKey:key];
    }
    PFACL *acl = [PFACL ACLWithUser:[PFUser currentUser]];
    if ([[metaDict objectForKey:@"isPrivate"] boolValue]) {
        [acl setPublicReadAccess:NO];
    } else {
        [acl setPublicReadAccess:YES];
    }
    newPhoto.ACL = acl;
    PFFile *photoFile = [PFFile fileWithName:@"photo.jpg" data:photoData];
//    [[NSNotificationCenter defaultCenter] postNotificationName:DH_PHOTO_UPLOAD_BEGIN_NOTIFICATION object:nil];
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
                    BOOL isAnonymous = [[metaDict objectForKey:@"isAnonymous"] boolValue];
                    [[NSNotificationCenter defaultCenter] postNotificationName:DH_PHOTO_UPLOAD_SUCCESS_NOTIFICATION object:[NSDictionary dictionaryWithObject:[NSNumber numberWithBool:isAnonymous] forKey:@"isAnonymous"]];
                } else {
                    [[NSNotificationCenter defaultCenter] postNotificationName:DH_PHOTO_UPLOAD_FAILURE_NOTIFICATION object:nil];
                }
            }];
        }
    }];
}

@end
