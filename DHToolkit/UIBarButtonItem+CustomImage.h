//
//  UIBarButtonItem+CustomImage.h
//  DHToolkit
//
//  Created by Tim Shi on 1/23/12.
//  Copyright (c) 2012 www.timshi.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (CustomImage)

+ (UIBarButtonItem *)barButtonItemWithImage:(UIImage*)image target:(id)target action:(SEL)action;

@end
