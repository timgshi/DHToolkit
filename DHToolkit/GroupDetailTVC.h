//
//  GroupDetailTVC.h
//  DHToolkit
//
//  Created by Tim Shi on 3/16/12.
//  Copyright (c) 2012 www.timshi.com. All rights reserved.
//

#import "DHTableViewController.h"

@class PFObject;

@interface GroupDetailTVC : DHTableViewController

@property (nonatomic, retain) PFObject *groupObject;

@end