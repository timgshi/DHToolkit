//
//  DHImageDetailMetaHeaderVC.h
//  DHToolkit
//
//  Created by Tim Shi on 2/13/12.
//  Copyright (c) 2012 www.timshi.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "Parse/PFObject.h"

@interface DHImageDetailMetaHeaderVC : UIViewController <MKMapViewDelegate>


@property (strong, nonatomic) IBOutlet UILabel *usernameLabel;
@property (strong, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (strong, nonatomic) IBOutlet UILabel *dateHeaderLabel;
@property (strong, nonatomic) IBOutlet UILabel *dateLabel;
@property (strong, nonatomic) IBOutlet UILabel *weatherHeaderLabel;
@property (strong, nonatomic) IBOutlet UILabel *weatherLabel;
@property (strong, nonatomic) IBOutlet UILabel *levelLabel;
@property (strong, nonatomic) IBOutlet UIView *levelBarView;
@property (strong, nonatomic) IBOutlet MKMapView *locationMapView;
@property (strong, nonatomic) IBOutlet UILabel *smileLabel;
@property (strong, nonatomic) IBOutlet UILabel *commentLabel;
@property (strong, nonatomic) IBOutlet UIImageView *smileImageView;
@property (strong, nonatomic) IBOutlet UIImageView *commentImageView;

@property (strong, nonatomic) PFObject *photoObject;

@end
