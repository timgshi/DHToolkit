//
//  DHExpandingStreamCell.h
//  Designing-Happiness
//
//  Created by Tim Shi on 11/27/11.
//  Copyright (c) 2011 www.timshi.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Parse/PFObject.h"

#define DH_EXPANDING_CELL_SMALL_HEIGHT 100
#define DH_EXPANDING_CELL_BIG_HEIGHT 320
#define DH_EXPANDING_CELL_INFO_BAR_HEIGHT 80

@class DHExpandingStreamCell;
@protocol DHExpandingStreamCellDelegate
@optional
- (UIImage *)cell:(DHExpandingStreamCell *)cell wantsImageForObjectID:(NSString *)objectID;
@optional
- (void)cell:(DHExpandingStreamCell *)cell loadedImage:(UIImage *)image forObjectID:(NSString *)objectID;
@end

@class DHPhoto;

@interface DHExpandingStreamCell : UITableViewCell

@property BOOL isExpanded;

- (void)setImageForCellImageView:(UIImage *)anImage;

@property (nonatomic, strong) UIView *contentContainerView;
@property (nonatomic, weak) DHPhoto *cellPhoto;
@property (nonatomic, strong) PFObject *photoObject;
@property (nonatomic, strong) UIActivityIndicatorView *spinner;
@property (nonatomic, strong) NSString *PFObjectID;
@property (nonatomic, weak) id <DHExpandingStreamCellDelegate> cellDelegate;

@end
