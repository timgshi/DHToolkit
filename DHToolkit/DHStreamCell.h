//
//  DHStreamCell.h
//  DHToolkit
//
//  Created by Tim Shi on 1/23/12.
//  Copyright (c) 2012 www.timshi.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Parse/PFObject.h"

#define DH_CELL_HEIGHT 320 + 2
#define DH_CELL_INFO_BAR_HEIGHT 65

@class DHPhoto;

@interface DHStreamCell : UITableViewCell

@property (nonatomic, weak) DHPhoto *cellPhoto;
@property (nonatomic, strong) PFObject *photoObject;
@property (nonatomic, strong) UIActivityIndicatorView *spinner;
@property (nonatomic, strong) NSString *PFObjectID;

@property (nonatomic, strong) UIImageView *cellImageView;

- (void)setImageForCellImageView:(UIImage *)anImage;

@end
