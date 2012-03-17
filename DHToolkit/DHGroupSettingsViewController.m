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
#import "GroupDetailTVC.h"
#import "Parse/PFPush.h"

@interface DHGroupSettingsViewController () <AddGroupTVCDelegate>
@property (nonatomic, strong) NSArray *groups;
@end

@implementation DHGroupSettingsViewController

@synthesize groups;

- (void)reloadGroups
{
    PFQuery *query = [PFQuery queryWithClassName:PFClass_DHGroup];
    [[NSNotificationCenter defaultCenter] postNotificationName:kDHIncrementNetworkActivityNotification object:nil];
    [query whereKey:kDHGroupMembers equalTo:[[PFUser currentUser] username]];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        groups = [NSArray arrayWithArray:objects];
        [self.tableView reloadData];
        [[NSNotificationCenter defaultCenter] postNotificationName:kDHDecrementNetworkActivityNotification object:nil];
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
    self.title = @"Groups";
    self.navigationItem.hidesBackButton = YES;
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem barButtonItemWithImage:[UIImage imageNamed:@"backarrow.png"] target:self action:@selector(backArrowPressed)];
    [self reloadGroups];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self reloadGroups];
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
                        PFObject *groupObject = [groups objectAtIndex:indexPath.row];
                        GroupDetailTVC *detailTVC = [[GroupDetailTVC alloc] initWithStyle:UITableViewStyleGrouped];
                        detailTVC.groupObject = groupObject;
                        [self.navigationController pushViewController:detailTVC animated:YES];
                    } else {
                        AddGroupTVC *addTVC = [[AddGroupTVC alloc] initWithStyle:UITableViewStyleGrouped];
                        addTVC.delegate = self;
                        [self presentViewController:[[UINavigationController alloc] initWithRootViewController:addTVC] animated:YES completion:nil];
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
           NSArray *members = [group objectForKey:kDHGroupMembers];
           for (NSString *member in members) {
               if ([member isEqualToString:((PFUser *)[PFUser currentUser]).username]) continue;
               NSString *channel = [NSString stringWithFormat:@"user-%@", member];
               NSString *message = [NSString stringWithFormat:@"%@ just added you to the group: %@!", ((PFUser *)[group objectForKey:kDHGroupCreator]).username, [group objectForKey:kDHGroupName]];
               NSDictionary *data = [NSDictionary dictionaryWithObjectsAndKeys:[group objectForKey:kDHGroupName], kDHGroupName, message, @"alert", kDHNotificationTypeGroupCreation, @"type", nil];
               [PFPush sendPushDataToChannelInBackground:channel withData:data block:^(BOOL succeeded, NSError *error) {
                   
               }];
           }
       }];
    }];
}

- (void)addGroupTVCdidCancel:(AddGroupTVC *)vc
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
