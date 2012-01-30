//
//  DHTableViewController.h
//  DHToolkit
//
//  Created by Tim Shi on 1/2/12.
//  Copyright (c) 2012 www.timshi.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DHTableViewController : UITableViewController

- (void)viewDidLoad;

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section;

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;

@end
