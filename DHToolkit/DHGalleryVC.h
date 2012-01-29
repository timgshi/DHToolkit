//
//  DHGalleryVC.h
//  Designing-Happiness
//
//  Created by Tim Shi on 11/25/11.
//  Copyright (c) 2011 www.timshi.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PFObject;

@protocol DHGalleryVCDelegate
- (NSArray *)objectsArray;
- (UIImage *)imageForPhoto:(PFObject *)photoObject;
@end

@interface DHGalleryVC : UIViewController <NSFetchedResultsControllerDelegate>

@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;

- initInManagedObjectContext:(NSManagedObjectContext *)context;

@property (nonatomic, weak) id <DHGalleryVCDelegate> galleryDelegate;

@end
