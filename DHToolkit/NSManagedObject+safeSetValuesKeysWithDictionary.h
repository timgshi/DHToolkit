//
//  NSManagedObject+safeSetValuesKeysWithDictionary.h
//  DHToolkit
//
//  Created by Tim Shi on 12/23/11.
//  Copyright (c) 2011 www.timshi.com. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface NSManagedObject (safeSetValuesKeysWithDictionary)

- (void)safeSetValuesForKeysWithDictionary:(NSDictionary *)keyedValues dateFormatter:(NSDateFormatter *)dateFormatter;

+ (void)autosave:(id)context;

@end
