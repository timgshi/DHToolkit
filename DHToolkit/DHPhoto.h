//
//  DHPhoto.h
//  SDWebImage
//
//  Created by Tim Shi on 2/28/12.
//  Copyright (c) 2012 Dailymotion. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface DHPhoto : NSManagedObject

@property (nonatomic, retain) NSNumber * happinessLevel;
@property (nonatomic, retain) NSNumber * isPrivate;
@property (nonatomic, retain) NSNumber * latitude;
@property (nonatomic, retain) NSString * locationName;
@property (nonatomic, retain) NSNumber * longitude;
@property (nonatomic, retain) NSString * pfObjectID;
@property (nonatomic, retain) NSData * photoData;
@property (nonatomic, retain) NSData * photoDataThumb;
@property (nonatomic, retain) NSString * photoDescription;
@property (nonatomic, retain) NSString * photographerUsername;
@property (nonatomic, retain) NSString * photoURL;
@property (nonatomic, retain) NSDate * timestamp;
@property (nonatomic, retain) NSString * weatherCondition;
@property (nonatomic, retain) NSString * weatherTemperature;

@end
