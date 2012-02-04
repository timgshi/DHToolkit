//
//  DHImageDetailImageVC.h
//  DHToolkit
//
//  Created by Tim Shi on 2/3/12.
//  Copyright (c) 2012 www.timshi.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Parse/PFObject.h"
#import "DHPhoto+Photo_PF.h"

@interface DHImageDetailImageVC : UIViewController

@property (nonatomic, strong) PFObject *photoObject;
@property (nonatomic, assign) DHPhoto *managedPhoto;

@end
