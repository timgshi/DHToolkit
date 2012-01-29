//
//  DHGalleryPresenterVC.h
//  Designing-Happiness
//
//  Created by Tim Shi on 11/26/11.
//  Copyright (c) 2011 www.timshi.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DHGalleryPresenterDelegate
- (void)galleryXButtonPressed;
@end

@class Photo;

@interface DHGalleryPresenterVC : UIViewController

-initWithPhoto:(Photo *)photo;
- (void)prepareToAddToSuperviewInRect:(CGRect)initialRect;
- (void)expandAndConfigureForRect:(CGRect)newRect;
- (void)minimizeToInitialRect;

@property (nonatomic, weak) Photo *selectedPhoto;
@property (nonatomic, weak) id <DHGalleryPresenterDelegate> delegate;

@end
