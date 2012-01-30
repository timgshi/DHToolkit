//
//  DHSortBoxView.h
//  DHToolkit
//
//  Created by Tim Shi on 1/29/12.
//  Copyright (c) 2012 www.timshi.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DHSortBoxViewDelegate
- (void)sortBoxChangedSortType;
@end

@interface DHSortBoxView : UIImageView

- (id)initWithOrigin:(CGPoint)origin;

@property (nonatomic, weak) id <DHSortBoxViewDelegate> sortBoxDelegate;

@end
