//
//  DHPhoto+Photo_PF.h
//  DHToolkit
//
//  Created by Tim Shi on 12/22/11.
//  Copyright (c) 2011 www.timshi.com. All rights reserved.
//

#import "DHPhoto.h"

@class PFObject;

@interface DHPhoto (Photo_PF)

+ (NSArray *)batchUpdatePhotosWithPFObjects:(NSArray *)pfObjects 
                     inManagedObjectContext:(NSManagedObjectContext *)context;

+ (DHPhoto *)photoWithPFObject:(PFObject *)photoObject 
        inManagedObjectContext:(NSManagedObjectContext *)context;

@end
