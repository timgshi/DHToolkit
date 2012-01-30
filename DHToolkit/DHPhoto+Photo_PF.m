//
//  DHPhoto+Photo_PF.m
//  DHToolkit
//
//  Created by Tim Shi on 12/22/11.
//  Copyright (c) 2011 www.timshi.com. All rights reserved.
//

#import "DHPhoto+Photo_PF.h"
#import "Parse/PFObject.h"
#import "Parse/PFUser.h"
#import "NSManagedObject+safeSetValuesKeysWithDictionary.h"

@implementation DHPhoto (Photo_PF)

//+ (DHPhoto *)photoWithPFObject:(PFObject *)photoObject 
//        inManagedObjectContext:(NSManagedObjectContext *)context
//{
//    DHPhoto *photo = nil;
//    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
//    fetchRequest.entity = [NSEntityDescription entityForName:NSStringFromClass([self class]) inManagedObjectContext:context];
//    NSString *uniqueString = [photoObject objectId];
//    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"pfObjectID == %@", uniqueString];
//    NSError *error = nil;
//    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
//    if (!fetchedObjects || (fetchedObjects.count > 1)) {
//        // handle error
//    } else {
//        photo = [fetchedObjects lastObject];
//        if (!photo) {    
//            photo = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([self class]) inManagedObjectContext:context];
//        }
//        NSDictionary *attributes = [[photo entity] attributesByName];
//        NSMutableDictionary  *keyedValues = [NSMutableDictionary dictionary];
//        for (NSString *attribute in attributes) {
//            if ([attribute isEqualToString:@"pfObjectID"]) {
//                [keyedValues setValue:[photoObject objectId] forKey:@"pfObjectID"];
//            } else if ([attribute isEqualToString:@"photoData"]) {
//                continue;
//            } else if ([attribute isEqualToString:@"photographerUsername"]) {
//                id possibleUser = [photoObject objectForKey:@"pfUser"];
//                if ([possibleUser isKindOfClass:[PFUser class]]) {
//                    PFUser *photographer = (PFUser *)possibleUser;
//                    [keyedValues setObject:[photographer username] forKey:@"photographerUsername"];
//                }
//            } else {
//                [keyedValues setValue:[photoObject objectForKey:attribute] forKey:attribute];
//            }
//        }
//        [photo safeSetValuesForKeysWithDictionary:nil dateFormatter:nil];
//        // if we recently scheduled an autosave, cancel it
//        [self cancelPreviousPerformRequestsWithTarget:self selector:@selector(autosave:) object:context];
//        // request a new autosave in a few tenths of a second
//        [self performSelector:@selector(autosave:) withObject:context afterDelay:0.2];
//    }
//    return photo;
//}

#define kDHDataSixWordKey @"DHDataSixWord"
#define kDHDataHappinessLevelKey @"DHDataHappinessLevel"
#define kDHDataWhoTookKey @"DHDataWhoTook"
#define kDHDataGroupNameKey @"DHDataGroupName"
#define kDHDataTimestampKey @"DHDataTimestamp"
#define kDHDataGeoLatKey @"DHDataGeoLat"
#define kDHDataGeoLongKey @"DHDataGeoLong"
#define kDHDataWeatherConditionKey @"DHDataWeatherCondition"
#define kDHDataWeatherTemperatureKey @"DHDataWeatherTemperature"
#define kDHDataLocationStringKey @"DHDataLocationString"
#define kDHDataPrivacyKey @"isPrivate"

+ (DHPhoto *)photoWithPFObject:(PFObject *)photoObject inManagedObjectContext:(NSManagedObjectContext *)context
{
    DHPhoto *photo = nil;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    fetchRequest.entity = [NSEntityDescription entityForName:NSStringFromClass([self class]) inManagedObjectContext:context];
    NSString *uniqueString = [photoObject objectId];
    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"pfObjectID = %@", uniqueString];
    NSError *error = nil;
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    //    [fetchRequest release];
    if (!fetchedObjects || (fetchedObjects.count > 1)) {
        // handle error
    } else {
        photo = [fetchedObjects lastObject];
        if (!photo) {
            photo = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([self class]) inManagedObjectContext:context];
            photo.pfObjectID = uniqueString;
            if ([photoObject objectForKey:kDHDataSixWordKey] == [NSNull null]) {
                photo.photoDescription = @"";
            } else {
                photo.photoDescription = [photoObject objectForKey:kDHDataSixWordKey];
            }
            
            NSNumber *privacy = [photoObject objectForKey:kDHDataPrivacyKey];
            if (privacy) {
                photo.isPrivate = privacy;
            } else {
                photo.isPrivate = [NSNumber numberWithBool:NO];
            }
            //photo.happinessLevel = [NSNumber numberWithInt:[[photoObject objectForKey:kDHDataHappinessLevelKey] integerValue]];
            photo.happinessLevel = [photoObject objectForKey:kDHDataHappinessLevelKey];
            photo.photographerUsername = [photoObject objectForKey:kDHDataWhoTookKey];
            //photo.dateupload = [photoObject objectForKey:kDHDataTimestampKey];
            photo.timestamp = [photoObject objectForKey:kDHDataTimestampKey];
            //photo.latitude = [NSNumber numberWithDouble:[[photoObject objectForKey:kDHDataGeoLatKey] doubleValue]];
            if ([photoObject objectForKey:kDHDataGeoLatKey] != [NSNull null]) {
                photo.latitude = [photoObject objectForKey:kDHDataGeoLatKey];
            } else {
                photo.latitude = nil;
            }
            
            //photo.longitude = [NSNumber numberWithDouble:[[photoObject objectForKey:kDHDataGeoLongKey] doubleValue]];
            if ([photoObject objectForKey:kDHDataGeoLongKey] != [NSNull null]) {
                photo.longitude = [photoObject objectForKey:kDHDataGeoLongKey];
            } else {
                photo.longitude = nil;
            }
            if ([photoObject objectForKey:kDHDataWeatherConditionKey] != [NSNull null]) {
                photo.weatherCondition = [photoObject objectForKey:kDHDataWeatherConditionKey];
            } else {
                photo.weatherCondition = nil;
            }
            if ([photoObject objectForKey:kDHDataWeatherTemperatureKey] != [NSNull null]) {
                photo.weatherTemperature = [photoObject objectForKey:kDHDataWeatherTemperatureKey];
            } else {
                photo.weatherTemperature = nil;
            }
            if ([photoObject objectForKey:kDHDataLocationStringKey] != [NSNull null]) {
                photo.locationName = [photoObject objectForKey:kDHDataLocationStringKey];
            } else {
                photo.locationName = nil;
            }
            
            // if we recently scheduled an autosave, cancel it
            [self cancelPreviousPerformRequestsWithTarget:self selector:@selector(autosave:) object:context];
            // request a new autosave in a few tenths of a second
            [self performSelector:@selector(autosave:) withObject:context afterDelay:0.2];
        }
        else {
            if (!photo.isPrivate) {
                photo.isPrivate = [NSNumber numberWithBool:NO];
            }
        }
    }
    return photo;
    
}

+ (void)autosave:(id)context
{
    NSError *error = nil;
    if ([context hasChanges] && ![context save:&error]) {
        NSLog(@"Error in autosave from Photo_PF: %@ %@", [error localizedDescription], [error userInfo]);
    }
}

@end
