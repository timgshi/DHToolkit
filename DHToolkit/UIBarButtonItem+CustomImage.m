//
//  UIBarButtonItem+CustomImage.m
//  DHToolkit
//
//  Created by Tim Shi on 1/23/12.
//  Copyright (c) 2012 www.timshi.com. All rights reserved.
//

#import "UIBarButtonItem+CustomImage.h"

@implementation UIBarButtonItem (CustomImage)

+ (UIBarButtonItem *)barButtonItemWithImage:(UIImage*)image target:(id)target action:(SEL)action
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundImage: image forState:UIControlStateNormal];
    button.frame= CGRectMake(0.0, 0.0, image.size.width, image.size.height);
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return [[UIBarButtonItem alloc] initWithCustomView:button];
}

@end
