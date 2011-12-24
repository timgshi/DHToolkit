//
//  DHStreamTVC.m
//  DHToolkit
//
//  Created by Tim Shi on 12/21/11.
//  Copyright (c) 2011 www.timshi.com. All rights reserved.
//

#import "DHStreamTVC.h"
#import "Parse/PFUser.h"
#import "Parse/PFQuery.h"
#import "EGORefreshTableHeaderView.h"
#import "ParseFetcher.h"
#import "DHPhoto+Photo_PF.h"

@interface DHStreamTVC() <EGORefreshTableHeaderDelegate>
@property (nonatomic, strong) EGORefreshTableHeaderView *refreshHeaderView;
@property BOOL isRefreshing;
@property (nonatomic, strong) NSDate *lastUpdateDate;
- (void) doneLoadingTableViewData;
@end

@implementation DHStreamTVC

@synthesize managedObjectContext = _managedObjectContext;
@synthesize refreshHeaderView = _refreshHeaderView;
@synthesize isRefreshing = _isRefreshing;
@synthesize lastUpdateDate = _lastUpdateDate;

- (EGORefreshTableHeaderView *)refreshHeaderView
{
    if (!_refreshHeaderView) {
        _refreshHeaderView = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - self.tableView.bounds.size.height, self.view.frame.size.width, self.tableView.bounds.size.height)];
        _refreshHeaderView.delegate = self;
    }
    return _refreshHeaderView;
}

- (NSDate *)lastUpdateDate
{
    return [NSDate date];
}

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

- (void)setManagedObjectContext:(NSManagedObjectContext *)aManagedObjectContext
{
    _managedObjectContext = aManagedObjectContext;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    fetchRequest.entity = [NSEntityDescription entityForName:@"DHPhoto"
                                      inManagedObjectContext:_managedObjectContext];
    fetchRequest.sortDescriptors = [NSArray arrayWithObject:
                                    [NSSortDescriptor sortDescriptorWithKey:@"timestamp"
                                                                  ascending:NO
                                                                   selector:@selector(compare:)]];
    PFUser *currentUser = [PFUser currentUser];
    if (currentUser) {
        fetchRequest.predicate = [NSCompoundPredicate orPredicateWithSubpredicates:
                                  [NSArray arrayWithObjects:
                                   [NSPredicate predicateWithFormat:@"isPrivate == %@", [NSNumber numberWithBool:NO]], 
                                   [NSPredicate predicateWithFormat:@"photographerUsername == %@", currentUser.username], 
                                   nil]];
    } else {
        fetchRequest.predicate = [NSPredicate predicateWithFormat:@"isPrivate == %@", [NSNumber numberWithBool:NO]];
    }
    NSFetchedResultsController *frc = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                                                          managedObjectContext:_managedObjectContext
                                                                            sectionNameKeyPath:nil
                                                                                     cacheName:nil];
    self.fetchedResultsController = frc;
}

#pragma mark - View lifecycle

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.tableView addSubview:self.refreshHeaderView];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Photo Loading

- (void)getPhotos
{
    PFQuery *photosQuery = [ParseFetcher newDHPhotosQuery];
    [photosQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (error != nil) {
            NSLog(@"%@", [error description]);
        } 
        NSLog(@"%@", objects);
        for (id obj in objects) {
            if ([obj isKindOfClass:[DHPhoto class]]) {
                PFObject *photoObject = (PFObject *)obj;
                [DHPhoto photoWithPFObject:photoObject inManagedObjectContext:self.managedObjectContext];
            }
        }
        [self doneLoadingTableViewData];
    }];
}

#pragma mark - Table view data source


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    
    return cell;
}



#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

#pragma mark - Refresh View
#pragma mark Data Source Loading / Reloading Methods



- (void)reloadTableViewDataSource {
	_isRefreshing = YES;
    [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:kDHIncrementNetworkActivityNotification object:nil]];
    [self getPhotos];	
}

- (void)doneLoadingTableViewData
{
	_isRefreshing = NO;
    [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:kDHDecrementNetworkActivityNotification object:nil]];
	[_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.tableView];	
}

#pragma mark UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{		
	[_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{	
	[_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
}

#pragma mark EGORefreshTableHeaderDelegate Methods

- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view{
	[self reloadTableViewDataSource];
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view{
	return _isRefreshing;
}

- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view{
	return self.lastUpdateDate;
}

@end
