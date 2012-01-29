//
//  SignInAccountTVC.h
//  Designing Happiness
//
//  Created by Tim Shi on 9/7/11.
//  Copyright (c) 2011 www.timshi.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EditingTableViewCell.h"

@protocol SignInAccountTVCDelegate
- (void)signinAccountDidCancel;
- (void)signinAccountDidSucceed;
@end

@interface SignInAccountTVC : UITableViewController <UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet EditingTableViewCell *editingTableViewCell;

@property (nonatomic, unsafe_unretained) id <SignInAccountTVCDelegate> delegate;

@end
