//
//  DHTableViewController.m
//  DHToolkit
//
//  Created by Tim Shi on 1/2/12.
//  Copyright (c) 2012 www.timshi.com. All rights reserved.
//

#import "DHTableViewController.h"
#import "UIBarButtonItem+CustomImage.h"


@implementation DHTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.navigationItem setBackBarButtonItem:[UIBarButtonItem barButtonItemWithImage:[UIImage imageNamed:@"backarrow.png"] target:nil action:nil]];
    self.tableView.scrollEnabled = NO;
    UIImage *backgroundImage = [[UIImage imageNamed:@"BackgroundGradient.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    self.tableView.backgroundColor = [UIColor colorWithPatternImage:backgroundImage];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableView.separatorColor = [UIColor clearColor];
}


#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    //    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(7, 7, 20, 30)];
    UILabel *label = [[UILabel alloc] init];
    [label setTextColor:[UIColor whiteColor]];
    [label setBackgroundColor:[UIColor clearColor]];
    [label setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:16]];
    NSString *text;
    switch (section) {
        case 0:
            text = @"  Account Details";
            break;
        case 1:
            text = @"  Sharing Settings";
        default:
            break;
    }
    [label setText:text];
    return label;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 32;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"DHSettingsCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    cell.contentView.backgroundColor = [UIColor colorWithRed:45/255.0 green:45/255.0 blue:45/255.0 alpha:1.0];
    cell.textLabel.backgroundColor = [UIColor clearColor];
    cell.detailTextLabel.backgroundColor = [UIColor clearColor];
    [cell.textLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:16]];
    [cell.detailTextLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:16]];
    [cell.textLabel setTextColor:[UIColor whiteColor]];
    [cell.detailTextLabel setTextColor:[UIColor whiteColor]];   
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}



@end
