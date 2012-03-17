//
//  AddGroupTVC.m
//  DHToolkit
//
//  Created by Tim Shi on 3/14/12.
//  Copyright (c) 2012 www.timshi.com. All rights reserved.
//

#import "AddGroupTVC.h"
#import "UIBarButtonItem+CustomImage.h"
#import "Parse/PFUser.h"
#import "Parse/PFObject.h"
#import "DHEditingSettingCell.h"
#import "DHFindUserTVC.h"

@interface AddGroupTVC () <DHFindUserDelegate, UITextFieldDelegate>
@property (nonatomic, strong) NSMutableArray *groupMembers;
@property (nonatomic, strong) UITextField *nameField;
@property (nonatomic, strong) NSString *groupName;
@end

@implementation AddGroupTVC

@synthesize groupMembers;
@synthesize delegate;
@synthesize nameField;
@synthesize groupName;

- (NSMutableArray *)groupMembers
{
    if (!groupMembers) {
        groupMembers = [NSMutableArray array];
        [groupMembers addObject:[PFUser currentUser]];
    }
    return groupMembers;
}


- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        self.tableView.scrollEnabled = YES;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Create Group";
//    self.navigationItem.hidesBackButton = YES;
//    self.navigationItem.leftBarButtonItem = [UIBarButtonItem barButtonItemWithImage:[UIImage imageNamed:@"backarrow.png"] target:self action:@selector(backArrowPressed)];
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem barButtonItemWithImage:[UIImage imageNamed:@"cancel.png"] target:self action:@selector(cancelButtonPressed)];
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem barButtonItemWithImage:[UIImage imageNamed:@"plus.png"] target:self action:@selector(saveButtonPressed)];
}

- (void)viewDidUnload 
{
    [super viewDidUnload];
    [self setGroupMembers:nil];
    [self setNameField:nil];
    [self setGroupName:nil];
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
//    UITableViewCell *cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
    static NSString *cellID = @"editing setting cell";
    DHEditingSettingCell *cell = [[DHEditingSettingCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            cell.textLabel.hidden = YES;
            cell.editingField.placeholder = @"Enter a group name";
            if (self.groupName) cell.editingField.text = self.groupName;
            cell.editingField.hidden = NO;
            cell.editingField.delegate = self;
            cell.editingField.returnKeyType = UIReturnKeyDone;
            self.nameField = cell.editingField;
        }
    } else if (indexPath.section == 1) {
        if (indexPath.row < [self.groupMembers count]) {
            PFUser *member = [self.groupMembers objectAtIndex:indexPath.row];
            cell.textLabel.text = member.username;
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
    BOOL exists = NO;
    for (PFUser *member in self.groupMembers) {
        if ([member.username isEqualToString:user.username]) {
            exists = YES;
            break;
        }
    }
    if (!exists) {
        [self.groupMembers addObject:user];
        [self.tableView reloadData];
    }
}

- (void)removeUser:(PFUser *)user
{
    for (PFUser *member in self.groupMembers) {
        if ([member.username isEqualToString:user.username]) {
            [self.groupMembers removeObject:member];
            [self.tableView reloadData];
        }
    }
}

- (void)saveButtonPressed
{
    if (self.groupName && ![self.groupName isEqualToString:@""]) {
        PFObject *groupObject = [PFObject objectWithClassName:PFClass_DHGroup];
        [groupObject setObject:self.groupName forKey:kDHGroupName];
        [groupObject setObject:[PFUser currentUser] forKey:kDHGroupCreator];
        NSMutableArray *members = [NSMutableArray array];
        for (PFUser *member in self.groupMembers) {
            [members addObject:member.username];
        }
        [groupObject setObject:members forKey:kDHGroupMembers];
        if (delegate) [delegate addGroupTVC:self didSaveGroup:groupObject];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Please enter a name for your group!" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [alert show];
    }
}

- (void)cancelButtonPressed
{
    if (delegate) [delegate addGroupTVCdidCancel:self];
}

#pragma mark - UITextFieldDelegate Methods

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    self.groupName = textField.text;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}



@end

