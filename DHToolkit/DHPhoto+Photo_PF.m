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

+ (DHPhoto *)photoWithPFObject:(PFObject *)photoObject 
        inManagedObjectContext:(NSManagedObjectContext *)context
{
    DHPhoto *photo = nil;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    fetchRequest.entity = [NSEntityDescription entityForName:NSStringFromClass([self class]) inManagedObjectContext:context];
    NSString *uniqueString = [photoObject objectId];
    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"pfObjectID == %@", uniqueString];
    NSError *error = nil;
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    if (!fetchedObjects || (fetchedObjects.count > 1)) {
        // handle error
    } else {
        photo = [fetchedObjects lastObject];
        if (!photo) {    
            photo = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([self class]) inManagedObjectContext:context];
        }
        NSDictionary *attributes = [[photo entity] attributesByName];
        NSMutableDictionary  *keyedValues = [NSMutableDictionary dictionary];
        for (NSString *attribute in attributes) {
            if ([attribute isEqualToString:@"pfObjectID"]) {
                [keyedValues setValue:[photoObject objectId] forKey:@"pfObjectID"];
            } else if ([attribute isEqualToString:@"photoData"]) {
                continue;
            } else if ([attribute isEqualToString:@"photographerUsername"]) {
                id possibleUser = [photoObject objectForKey:@"pfUser"];
                if ([possibleUser isKindOfClass:[PFUser class]]) {
                    PFUser *photographer = (PFUser *)possibleUser;
                    [keyedValues setObject:[photographer username] forKey:@"photographerUsername"];
                }
            } else {
                [keyedValues setValue:[photoObject objectForKey:attribute] forKey:attribute];
            }
        }
        [photo safeSetValuesForKeysWithDictionary:nil dateFormatter:nil];
        // if we recently scheduled an autosave, cancel it
        [self cancelPreviousPerformRequestsWithTarget:self selector:@selector(autosave:) object:context];
        // request a new autosave in a few tenths of a second
        [self performSelector:@selector(autosave:) withObject:context afterDelay:0.2];
    }
    return photo;
}

@end
