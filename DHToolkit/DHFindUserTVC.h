//
//  DHFindUserTVC.h
//  DHToolkit
//
//  Created by Tim Shi on 3/16/12.
//  Copyright (c) 2012 www.timshi.com. All rights reserved.
//

#import "DHTableViewController.h"

@class PFUser;

@protocol DHFindUserDelegate
- (void)addUser:(PFUser *)user;
- (void)removeUser:(PFUser *)user;
@end

@interface DHFindUserTVC : DHTableViewController

@property (nonatomic, weak) id <DHFindUserDelegate> delegate;

@end
