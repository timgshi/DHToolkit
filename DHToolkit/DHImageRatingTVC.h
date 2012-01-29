//
//  DHImageRatingTVC.h
//  DHToolkit
//
//  Created by Tim Shi on 1/8/12.
//  Copyright (c) 2012 www.timshi.com. All rights reserved.
//

#import "DHTableViewController.h"

@class DHImageRatingTVC;
@protocol DHImageRatingDelegate
- (void)imageRatingTVCDidFinish:(DHImageRatingTVC *)rater;
@end

@interface DHImageRatingTVC : DHTableViewController

- (id)init;

@property (nonatomic, weak) id <DHImageRatingDelegate> delegate;

@property (nonatomic, strong) UIImage *selectedPhoto;

@end
