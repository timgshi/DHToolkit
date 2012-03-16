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

@interface AddGroupTVC ()
@property (nonatomic, strong) NSMutableArray *groupMembers;

@end

@implementation AddGroupTVC

@synthesize groupMembers;

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
    self.title = @"Settings";
    self.navigationItem.hidesBackButton = YES;
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem barButtonItemWithImage:[UIImage imageNamed:@"backarrow.png"] target:self action:@selector(backArrowPressed)];
}

- (void)viewDidUnload 
{
    [super viewDidUnload];
    [self setGroupMembers:nil];
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
            cell.textLabel.text = @"Name";
            cell.editingField.hidden = NO;
        }
    } else if (indexPath.section == 1) {
        if (indexPath.row < [self.groupMembers count]) {
            PFUser *member = [self.groupMembers objectAtIndex:indexPath.row];
            cell.textLabel.text = member.username;
            cell.editingField.hidden = YES;
        } else {
            cell.textLabel.text = @"Add member";
        }
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1 && indexPath.row == [self.groupMembers count]) {
        
    }
}


@end


