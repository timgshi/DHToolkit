//
//  ParseFetcher.m
//  DHToolkit
//
//  Created by Tim Shi on 12/23/11.
//  Copyright (c) 2011 www.timshi.com. All rights reserved.
//

#import "ParseFetcher.h"
#import "Parse/PFQuery.h"
#import "Parse/PFObject.h"
#import "Parse/PFFile.h"


#define kDH_STANDARD_PHOTO_LIMIT 20

@implementation ParseFetcher

+ (PFQuery *)newDHPhotosQuery
{
    PFQuery *query = [PFQuery queryWithClassName:@"DHPhoto"];
    [query includeKey:@"pfUser"];
    [query orderByDescending:@"DHDataTimestamp"];
    [query setLimit:[NSNumber numberWithInt:kDH_STANDARD_PHOTO_LIMIT]];
    return query;
}

+ (NSData *)photoDataForPhotoObject:(PFObject *)photoObject
{
    PFFile *photoFile = [photoObject objectForKey:@"photoData"];
    return [photoFile getData];
}

#pragma mark - Custom Methods

/*
 * Method: sizeOfFolder
 * -------------------------------
 * Returns the size of a folder by iterating through its contents. This method is adapted from an example
 * found on StackOverflow. http://stackoverflow.com/questions/2188469/calculate-the-size-of-a-folder
 */

- (unsigned long long int)sizeOfFolder:(NSString *)folderPath
{
    NSFileManager *manager = [[NSFileManager alloc] init];
    unsigned long long int folderSize = 0;
    NSDirectoryEnumerator *dirEnum = [manager enumeratorAtPath:folderPath];
    NSString *file;
    while ((file = [dirEnum nextObject])) 
    {
        NSDictionary *attributes = [manager attributesOfItemAtPath:[folderPath stringByAppendingPathComponent:file] error:nil];
        folderSize += [[attributes objectForKey:NSFileSize] unsignedLongLongValue];
    }
    return folderSize;
}

/*
 * Method: deleteOldestFileInDirectory
 * -------------------------------
 * This method iterates through the given directory to determine the file with
 * the oldest modification date. Once the oldest file has been determined, it is
 * deleted to free space.
 */

- (void)deleteOldestFileInDirectory:(NSString *)directoryPath
{
    NSFileManager *manager = [[NSFileManager alloc] init];
    NSDirectoryEnumerator *dirEnum = [manager enumeratorAtPath:directoryPath];
    NSString *file;
    NSString *deleteFile;
    NSDate *dateModified = [NSDate date];
    while ((file = [dirEnum nextObject])) 
    {
        NSDictionary *attributes = [manager attributesOfItemAtPath:[directoryPath stringByAppendingPathComponent:file] error:nil];
        NSDate *newModified = [attributes objectForKey:NSFileModificationDate];
        if (dateModified > newModified)
        {
            deleteFile = file;
            dateModified = [attributes objectForKey:NSFileModificationDate];
        }
    }
    if (deleteFile)
    {
        [manager removeItemAtPath:[directoryPath stringByAppendingPathComponent:deleteFile] error:nil];
    }
}

/*
 * Method: loadPhotoImageData
 * -------------------------------
 * Returns a UIImage of self.photo. Viewed photos are cached. If a photo doesn't
 * already exist it's saved into the cache. Each time a photo is stored in the cache,
 * the size of the cache is checked to see if it needs to have space freed. This method
 * can be used as a block and is thread safe.
 */


#define MAX_CACHE_SIZE 20971520


+ (NSData *)loadPhotoDataForPhotoObject:(PFObject *)photoObject
{
    NSData *photoData;
    NSFileManager *manager = [[NSFileManager alloc] init];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cachePath = [paths lastObject];
    cachePath = [cachePath stringByAppendingPathComponent:PHOTO_CACHE_NAME];
    cachePath = [cachePath stringByAppendingPathComponent:photoObject.objectId];
    if ([manager fileExistsAtPath:cachePath])
    {
        photoData = [manager contentsAtPath:cachePath];
    } else 
    {
        PFFile *photoFile = [photoObject objectForKey:@"photoData"];
        photoData = [photoFile getData];
        if ([self sizeOfFolder:[cachePath stringByDeletingLastPathComponent]] > MAX_CACHE_SIZE) {
            [self deleteOldestFileInDirectory:[cachePath stringByDeletingLastPathComponent]];
        }
        [manager createFileAtPath:cachePath contents:photoData attributes:nil];
    }
    return photoData;
}

@end
