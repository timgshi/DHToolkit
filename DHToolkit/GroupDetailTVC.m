//
//  GroupDetailTVC.m
//  DHToolkit
//
//  Created by Tim Shi on 3/16/12.
//  Copyright (c) 2012 www.timshi.com. All rights reserved.
//

#import "GroupDetailTVC.h"
#import "Parse/PFObject.h"
#import "DHEditingSettingCell.h"
#import "Parse/PFUser.h"
#import "DHFindUserTVC.h"
#import "UIBarButtonItem+CustomImage.h"

@interface GroupDetailTVC () <UITextFieldDelegate, DHFindUserDelegate, UIActionSheetDelegate>
@property (nonatomic, strong) UITapGestureRecognizer *tapgr;
@property (nonatomic, strong) NSMutableArray *groupMembers;
@end

@implementation GroupDetailTVC

@synthesize groupObject;
@synthesize tapgr;
@synthesize groupMembers;


- (UITapGestureRecognizer *)tapgr
{
    if (!tapgr) {
        tapgr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(textFieldShouldReturn:)];
    }
    return tapgr;
}

- (BOOL)authorize
{
    PFUser *creator = [self.groupObject objectForKey:kDHGroupCreator];
    PFUser *curUser = [PFUser currentUser];
    if ([creator.username isEqualToString:curUser.username]) {
        return YES;
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"You must be the group's creator to modify the group" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [alert show];
        return NO;
    }
    return NO;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = [self.groupObject objectForKey:kDHGroupName];
    self.navigationItem.hidesBackButton = YES;
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem barButtonItemWithImage:[UIImage imageNamed:@"backarrow.png"] target:self action:@selector(backArrowPressed)];
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem barButtonItemWithImage:[UIImage imageNamed:@"trash.png"] target:self action:@selector(deleteButtonPressed)];
    self.groupMembers = [NSMutableArray arrayWithArray:[self.groupObject objectForKey:kDHGroupMembers]];
	// Do any additional setup after loading the view.
}

- (void)deleteButtonPressed
{
    if ([self authorize]) {
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Are you sure you want to delete?" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Delete" otherButtonTitles: nil];
        [actionSheet showFromBarButtonItem:self.navigationItem.rightBarButtonItem animated:YES];
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        [self.groupObject deleteInBackground];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.groupObject = nil;
    self.tapgr = nil;
    // Release any retained subviews of the main view.
}

- (void)backArrowPressed
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel *label = (UILabel *)[super tableView:tableView viewForHeaderInSection:section];
    NSString *text;
    switch (section) {
        case 0:
            text = @"  GROUP SETTINGS";
            break;
        case 1:
            text = @"  GROUP MEMBERS";
            break;
        default:
            break;
    }
    [label setText:text];
    return label;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    } else {
        return [self.groupMembers count] + 1;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"editing setting cell";
    DHEditingSettingCell *cell = [[DHEditingSettingCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            cell.textLabel.hidden = YES;
            cell.editingField.text = [self.groupObject objectForKey:kDHGroupName];
            cell.editingField.hidden = NO;
            cell.editingField.delegate = self;
            cell.editingField.returnKeyType = UIReturnKeyDone;
        }
    } else if (indexPath.section == 1) {
        if (indexPath.row < [self.groupMembers count]) {
            NSString *username = [self.groupMembers objectAtIndex:indexPath.row];
            cell.textLabel.text = username;
            cell.editingField.hidden = YES;
        } else {
            cell.textLabel.text = @"Add member";
            cell.editingField.hidden = YES;
        }
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1 && indexPath.row == [self.groupMembers count]) {
        DHFindUserTVC *findUserVC = [[DHFindUserTVC alloc] initWithStyle:UITableViewStylePlain];
        findUserVC.delegate = self;
        [self.navigationController pushViewController:findUserVC animated:YES];
    }
}

#pragma mark - DHFindUserDelegate Methods

- (void)addUser:(PFUser *)user
{
    if (![self.groupMembers containsObject:user.username]) {
        [self.groupMembers addObject:user.username];
        [self.tableView reloadData];
    }
}

- (void)removeUser:(PFUser *)user
{
    for (NSString *member in self.groupMembers) {
        if ([member isEqualToString:user.username]) {
            [self.groupMembers removeObject:member];
            [self.tableView reloadData];
        }
    }
}

#pragma mark - UITextFieldDelegate Methods

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    return [self authorize];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self.tableView addGestureRecognizer:self.tapgr];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.groupObject setObject:[textField text] forKey:kDHGroupName];
    [self.groupObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        [self.tableView reloadData];
    }];
    [self.tableView removeGestureRecognizer:self.tapgr];
    [textField resignFirstResponder];
    return YES;
}

@end
