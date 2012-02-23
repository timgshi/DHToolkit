//
//  DHImageSmileTagVC.h
//  DHToolkit
//
//  Created by Tim Shi on 2/16/12.
//  Copyright (c) 2012 www.timshi.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PFObject;

@interface DHImageSmileTagVC : UIViewController

@property (nonatomic, strong) PFObject *photoObject;

@property CGPoint imageViewOrigin;

- (void)updateIcon;

- (id)initWithOrigin:(CGPoint)anOrigin;

@end
