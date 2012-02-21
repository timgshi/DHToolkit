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
#import "Parse/PFGeopoint.h"
#import "Parse/PFQuery.h"
#import "Parse/PFPush.h"

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
    if ([metaDict objectForKey:@"DHDataGeoLat"]) {
        double lat = [[metaDict objectForKey:@"DHDataGeoLat"] doubleValue];
        double lon = [[metaDict objectForKey:@"DHDataGeoLong"] doubleValue];
        PFGeoPoint *geopoint = [PFGeoPoint geoPointWithLatitude:lat longitude:lon];
        [newPhoto setObject:geopoint forKey:@"geopoint"];
    }
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

+ (void)postCommentForPhoto:(PFObject *)photoObject withMessage:(NSString *)message
{
    PFObject *commentObject = [PFObject objectWithClassName:@"DHPhotoComment"];
//    [commentObject setObject:photoObject forKey:@"DHPhoto"];
    [commentObject setObject:photoObject.objectId forKey:@"DHPhotoID"];
    __block PFUser *curUser = [PFUser currentUser];
    [commentObject setObject:curUser forKey:@"PFUser"];
    [commentObject setObject:curUser.username forKey:@"PFUsername"];
    [commentObject setObject:message forKey:@"message"];
    [commentObject setObject:[NSDate date] forKey:@"timestamp"];
    [commentObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            [[NSNotificationCenter defaultCenter] postNotificationName:DH_COMMENT_UPLOAD_SUCCESS_NOTIFICATION object:nil];
            NSString *username = [photoObject objectForKey:@"DHDataWhoTook"];
//            [PFPush sendPushMessageToChannelInBackground:[NSString stringWithFormat:@"user-%@", username] withMessage:[NSString stringWithFormat:@"%@ just commented on your photo!", curUser.username]];
            NSMutableDictionary *pushData = [NSMutableDictionary dictionary];
            [pushData setObject:[NSString stringWithFormat:@"%@ just commented on your photo!", curUser.username] forKey:@"alert"];
            [pushData setObject:photoObject.objectId forKey:@"photo"];
            [PFPush sendPushDataToChannelInBackground:[NSString stringWithFormat:@"user-%@", username] withData:pushData];
        } else {
            [[NSNotificationCenter defaultCenter] postNotificationName:DH_COMMENT_UPLOAD_FAILURE_NOTIFICATION object:nil];
        }
    }];
}

+ (void)postSmileForPhoto:(PFObject *)photoObject
{
    PFQuery *smileQuery = [PFQuery queryWithClassName:@"DHPhotoSmile"];
    [smileQuery whereKey:@"DHPhotoID" equalTo:photoObject.objectId];
    [smileQuery whereKey:@"PFUser" equalTo:[PFUser currentUser]];
    [smileQuery countObjectsInBackgroundWithBlock:^(int number, NSError *error) {
        if (number == 0) {
            PFObject *smileObject = [PFObject objectWithClassName:@"DHPhotoSmile"];
            PFUser *curUser = [PFUser currentUser];
            [smileObject setObject:curUser forKey:@"PFUser"];
            [smileObject setObject:curUser.username forKey:@"PFUsername"];
            [smileObject setObject:photoObject.objectId forKey:@"DHPhotoID"];
            [smileObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (succeeded) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:DH_SMILE_UPLOAD_SUCCESS_NOTIFICATION object:nil];
                    [[NSNotificationCenter defaultCenter] postNotificationName:DH_COMMENT_UPLOAD_SUCCESS_NOTIFICATION object:nil];
                    NSString *username = [photoObject objectForKey:@"DHDataWhoTook"];
                    PFUser *curUser = [PFUser currentUser];
                    [PFPush sendPushMessageToChannelInBackground:[NSString stringWithFormat:@"user-%@", username] withMessage:[NSString stringWithFormat:@"%@ just smiled at your photo!", curUser.username]];
                }
                
            }];

        }
    }];
}

@end
