//
//  DHCommentCell.h
//  DHToolkit
//
//  Created by Tim Shi on 2/13/12.
//  Copyright (c) 2012 www.timshi.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Parse/PFObject.h"

@interface DHCommentCell : UITableViewCell

@property (nonatomic, strong) PFObject *commentObject;

@end
