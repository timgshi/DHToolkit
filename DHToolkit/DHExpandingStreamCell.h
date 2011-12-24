//
//  DHExpandingStreamCell.h
//  Designing-Happiness
//
//  Created by Tim Shi on 11/27/11.
//  Copyright (c) 2011 www.timshi.com. All rights reserved.
//

#import <UIKit/UIKit.h>

#define DH_EXPANDING_CELL_SMALL_HEIGHT 100
#define DH_EXPANDING_CELL_BIG_HEIGHT 320
#define DH_EXPANDING_CELL_INFO_BAR_HEIGHT 80

@class Photo;

@interface DHExpandingStreamCell : UITableViewCell

@property BOOL isExpanded;

- (void)setImageForCellImageView:(UIImage *)anImage;

@property (nonatomic, strong) UIView *contentContainerView;
@property (nonatomic, weak) Photo *cellPhoto;
@property (nonatomic, strong) UIActivityIndicatorView *spinner;
@property (nonatomic, strong) NSString *PFObjectID;

@end
