//
//  DHGroupSettingsViewController.m
//  DHToolkit
//
//  Created by Tim Shi on 3/14/12.
//  Copyright (c) 2012 www.timshi.com. All rights reserved.
//

#import "DHGroupSettingsViewController.h"
#import "Parse/PFUser.h"
#import "Parse/PFFacebookUtils.h"
#import "Parse/PFObject.h"
#import "Parse/PFQuery.h"
#import "UIBarButtonItem+CustomImage.h"
#import "AddGroupTVC.h"

@interface DHGroupSettingsViewController () <AddGroupTVCDelegate>
@property (nonatomic, strong) NSArray *groups;
@end

@implementation DHGroupSettingsViewController

@synthesize groups;

- (void)reloadGroups
{
    PFQuery *query = [PFQuery queryWithClassName:PFClass_DHGroup];
    [query whereKey:kDHGroupMembers equalTo:[PFUser currentUser]];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        groups = [NSArray arrayWithArray:objects];
        [self.tableView reloadData];
    }];
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Settings";
    self.navigationItem.hidesBackButton = YES;
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem barButtonItemWithImage:[UIImage imageNamed:@"backarrow.png"] target:self action:@selector(backArrowPressed)];
}

- (void)backArrowPressed
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if ([PFUser currentUser]) {
        return 1;
    } else {
        return 1;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel *label = (UILabel *)[super tableView:tableView viewForHeaderInSection:section];
    NSString *text;
    switch (section) {
        case 0:
            text = @"  MY GROUPS";
            break;
        default:
            break;
    }
    [label setText:text];
    return label;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    PFUser *curUser = [PFUser currentUser];
    if (curUser) {
        if (groups) {
            return [groups count] + 1;
        } else {
            return 1;
        }
    } else {
        return 1;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
    PFUser *currentUser = (PFUser *)[PFUser currentUser];
    switch ([indexPath section]) {
        case 0:
            if (currentUser) {
                if (groups) {
                    if (indexPath.row < [groups count]) {
                        PFObject *groupObject = [groups objectAtIndex:indexPath.row];
                        cell.textLabel.text = [groupObject objectForKey:kDHGroupName];
                        
                    } else {
                        cell.textLabel.text = @"Click to add a group";
                    }
                } else {
                    cell.textLabel.text = @"Click to add a group";
                }
            } else {
                cell.textLabel.text = @"Not logged in";
            }
            break;
        default:
            break;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    PFUser *currentUser = (PFUser *)[PFUser currentUser];
    switch ([indexPath section]) {
        case 0:
            if (currentUser) {
                if (groups) {
                    if (indexPath.row < [groups count]) {
//                        PFObject *groupObject = [groups objectAtIndex:indexPath.row];
                        
                    }
                } else {
                    AddGroupTVC *addTVC = [[AddGroupTVC alloc] initWithStyle:UITableViewStyleGrouped];
                    addTVC.delegate = self;
                    [self presentViewController:[[UINavigationController alloc] initWithRootViewController:addTVC] animated:YES completion:nil];
//                    [self.navigationController pushViewController:[[AddGroupTVC alloc] initWithStyle:UITableViewStyleGrouped] animated:YES];
                }
            } else {
                
            }
            break;
        default:
            break;
    }
}

#pragma mark - AddGroupTVC Delegate Methods

- (void)addGroupTVC:(AddGroupTVC *)vc didSaveGroup:(PFObject *)group
{
    [self dismissViewControllerAnimated:YES completion:^{
       [group saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
           [self reloadGroups];
       }];
    }];
}

- (void)addGroupTVCdidCancel:(AddGroupTVC *)vc
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
