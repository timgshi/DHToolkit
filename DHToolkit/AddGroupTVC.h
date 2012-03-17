//
//  AddGroupTVC.h
//  DHToolkit
//
//  Created by Tim Shi on 3/14/12.
//  Copyright (c) 2012 www.timshi.com. All rights reserved.
//

#import "DHTableViewController.h"

@class AddGroupTVC;
@class PFObject;

@protocol AddGroupTVCDelegate
- (void)addGroupTVC:(AddGroupTVC *)vc didSaveGroup:(PFObject *)group;
- (void)addGroupTVCdidCancel:(AddGroupTVC *)vc;
@end

@interface AddGroupTVC : DHTableViewController

@property (nonatomic, weak) id <AddGroupTVCDelegate> delegate;

@end
