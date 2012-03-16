//
//  DHFindUserTVC.m
//  DHToolkit
//
//  Created by Tim Shi on 3/16/12.
//  Copyright (c) 2012 www.timshi.com. All rights reserved.
//

#import "DHFindUserTVC.h"

@interface DHFindUserTVC ()
@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) UISearchDisplayController *searchController;
@end

@implementation DHFindUserTVC

@synthesize searchBar;
@synthesize searchController;

- (UISearchDisplayController *)searchController
{
    if (!searchController) {
        searchController = [UISearchDisplayController alloc] initWithSearchBar:<#(UISearchBar *)#> contentsController:<#(UIViewController *)#>
    }
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
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.searchController = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
