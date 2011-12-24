//
//  DHPhoto.h
//  DHToolkit
//
//  Created by Tim Shi on 12/22/11.
//  Copyright (c) 2011 www.timshi.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface DHPhoto : NSManagedObject

@property (nonatomic, retain) NSNumber * happinessLevel;
@property (nonatomic, retain) NSNumber * latitude;
@property (nonatomic, retain) NSNumber * longitude;
@property (nonatomic, retain) NSString * photoDescription;
@property (nonatomic, retain) NSString * pfObjectID;
@property (nonatomic, retain) NSString * photographerUsername;
@property (nonatomic, retain) NSNumber * isPrivate;
@property (nonatomic, retain) NSData * smallThumbData;
@property (nonatomic, retain) NSString * locationName;
@property (nonatomic, retain) NSDate * timestamp;
@property (nonatomic, retain) NSData * photoData;
@property (nonatomic, retain) NSString * weatherCondition;
@property (nonatomic, retain) NSString * weatherTemperature;

@end
