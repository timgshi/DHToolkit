//
//  ParsePoster.h
//  DHToolkit
//
//  Created by Tim Shi on 12/24/11.
//  Copyright (c) 2011 www.timshi.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ParsePoster

+ (void)postPhotoWithMetaInfo:(NSDictionary *)metaDict andPhotoData:(NSData *)photoData;

@end
