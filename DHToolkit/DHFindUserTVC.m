//
//  DHFindUserTVC.m
//  DHToolkit
//
//  Created by Tim Shi on 3/16/12.
//  Copyright (c) 2012 www.timshi.com. All rights reserved.
//

#import "DHFindUserTVC.h"
#import "UIBarButtonItem+CustomImage.h"
#import "Parse/PFQuery.h"
#import "Parse/PFUser.h"

@interface DHFindUserTVC () <UISearchDisplayDelegate, UISearchBarDelegate>
@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) UISearchDisplayController *searchController;
@property (nonatomic, strong) NSMutableArray *userResults, *selectedUsers;  
@end

@implementation DHFindUserTVC

@synthesize searchBar;
@synthesize searchController;
@synthesize userResults, selectedUsers;
@synthesize delegate;

- (UISearchBar *)searchBar
{
    if (!searchBar) {
        searchBar = [[UISearchBar alloc] init];
    }
    return searchBar;
}

- (UISearchDisplayController *)searchController
{
    if (!searchController) {
        searchController = [[UISearchDisplayController alloc] initWithSearchBar:self.searchBar contentsController:self];
        searchController.delegate = self;
        searchController.searchResultsDataSource = self;
        searchController.searchResultsDelegate = self;
    }
    return searchController;
}

- (NSArray *)userResults
{
    if (!userResults) {
        userResults = [NSMutableArray array];
    }
    return userResults;
}

- (NSArray *)selectedUsers
{
    if (!selectedUsers) {
        selectedUsers = [NSMutableArray array];
    }
    return selectedUsers;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.hidesBackButton = YES;
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem barButtonItemWithImage:[UIImage imageNamed:@"backarrow.png"] target:self action:@selector(backArrowPressed)];
    self.tableView.tableHeaderView = self.searchBar;
    self.searchController.active = YES;
}

- (void)backArrowPressed
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.searchController = nil;
    self.searchBar = nil;
    self.userResults = nil;
    self.selectedUsers = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
//    if (tableView == self.tableView) {
//        UILabel *label = (UILabel *)[super tableView:tableView viewForHeaderInSection:section];
//        [label setText:@"  Selected users"];
//        return label;
//    }
    return nil;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.tableView) {
        return [self.selectedUsers count];
    } else if (tableView == self.searchController.searchResultsTableView) {
        return [self.userResults count];
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.tableView) {
        UITableViewCell *cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
        PFUser *user = [self.selectedUsers objectAtIndex:indexPath.row];
        cell.textLabel.text = user.username;
        return cell;
    } else if (tableView == self.searchController.searchResultsTableView) {
        static NSString *resultsID = @"results cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:resultsID];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:resultsID];
        }
        PFUser *user = [self.userResults objectAtIndex:indexPath.row];
        cell.textLabel.text = user.username;
        cell.detailTextLabel.text = user.email;
        return cell;
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.tableView) {
        PFUser *toRemove = [self.selectedUsers objectAtIndex:indexPath.row];
        [self.selectedUsers removeObjectAtIndex:indexPath.row];
        if (delegate) [delegate removeUser:toRemove];
        [self.tableView reloadData];
    } else if (tableView == self.searchController.searchResultsTableView) {
        [self.selectedUsers addObject:[self.userResults objectAtIndex:indexPath.row]];
        if (delegate) [delegate addUser:[self.userResults objectAtIndex:indexPath.row]];
        [self.tableView reloadData];
        [self.searchController setActive:NO animated:YES];
    }
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    PFQuery *query = [PFQuery queryForUser];
    [query whereKey:@"username" hasPrefix:searchString];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        self.userResults = nil;
        [self.userResults addObjectsFromArray:objects];
        [self.searchController.searchResultsTableView reloadData];
        PFQuery *emailQuery = [PFQuery queryForUser];
        [emailQuery whereKey:@"email" hasPrefix:searchString];
        [emailQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            NSMutableDictionary *results = [NSMutableDictionary dictionary];
            for (PFUser *user in objects) {
                [results setObject:user forKey:user.username];
            }
            for (PFUser *user in self.userResults) {
                if ([[results allKeys] containsObject:user.username]) {
                    [results removeObjectForKey:user.username];
                }
            } 
            [self.userResults addObjectsFromArray:[results allValues]];
            [self.searchController.searchResultsTableView reloadData];
        }];
    }];
    
    return NO;
}

@end
