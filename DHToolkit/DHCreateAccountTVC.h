//
//  CreateAccountTVC.h
//  Designing Happiness
//
//  Created by Tim Shi on 8/3/11.
//  Copyright 2011 Stanford University. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Parse/PF_Facebook.h"
#import "EditingTableViewCell.h"
#import "DHTableViewController.h"


@protocol DHCreateAccountTVCDelegate
- (void)createAccountDidCancel;
- (void)createAccountDidSave;
@end

@interface DHCreateAccountTVC : UITableViewController <PF_FBRequestDelegate, PF_FBSessionDelegate, UITextFieldDelegate> {
    EditingTableViewCell *editingTableViewCell;
    PF_Facebook *facebook;
}


@property (nonatomic, strong) PF_Facebook *facebook;

@property (strong, nonatomic) IBOutlet EditingTableViewCell *editingTableViewCell;

@property (nonatomic, unsafe_unretained) id <DHCreateAccountTVCDelegate> delegate;


@end

