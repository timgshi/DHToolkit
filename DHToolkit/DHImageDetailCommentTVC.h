//
//  DHImageDetailCommentTVC.h
//  DHToolkit
//
//  Created by Tim Shi on 2/13/12.
//  Copyright (c) 2012 www.timshi.com. All rights reserved.
//

#import <Parse/Parse.h>

@interface DHImageDetailCommentTVC : PFQueryTableViewController

@property (nonatomic, strong) PFObject *photoObject;

- (void)scrollToBottom;

- (id)initWithStyle:(UITableViewStyle)style photoObject:(PFObject *)aPhoto;

@end
