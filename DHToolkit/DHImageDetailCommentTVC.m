//
//  DHImageDetailCommentTVC.m
//  DHToolkit
//
//  Created by Tim Shi on 2/13/12.
//  Copyright (c) 2012 www.timshi.com. All rights reserved.
//

#import "DHImageDetailCommentTVC.h"
#import "DHCommentCell.h"

@implementation DHImageDetailCommentTVC

@synthesize photoObject;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
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

- (id)initWithStyle:(UITableViewStyle)style photoObject:(PFObject *)aPhoto
{
    self = [super initWithStyle:style];
    if (self) {
        // This table displays items in the Todo class
        
        self.className = @"DHPhotoComment";
        self.photoObject = aPhoto;
        self.pullToRefreshEnabled = YES;
        self.paginationEnabled = NO;
        self.objectsPerPage = 25;
//        UIImage *backgroundImage = [[UIImage imageNamed:@"BackgroundGradient.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
//        self.tableView.backgroundColor = [UIColor colorWithPatternImage:backgroundImage];
        self.tableView.backgroundColor = [UIColor colorWithRed:45/255.0 green:45/255.0 blue:45/255.0 alpha:1.0];
    }
    return self;
}

- (PFQuery *)queryForTable {
    PFQuery *query = [PFQuery queryWithClassName:self.className];
    
    // If no objects are loaded in memory, we look to the cache first to fill the table
    // and then subsequently do a query against the network.
    if ([self.objects count] == 0) {
        query.cachePolicy = kPFCachePolicyCacheThenNetwork;
    }
    [query whereKey:@"DHPhotoID" equalTo:self.photoObject.objectId];
    [query orderByAscending:@"createdAt"];
    
    return query;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
                        object:(PFObject *)object
{
    static NSString *CellIdentifier = @"Comment Cell";
    
    DHCommentCell *cell = (DHCommentCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[DHCommentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }          
    cell.commentObject = object;            
    
    // Configure the cell to show todo item with a priority at the bottom
//    cell.textLabel.text = [object objectForKey:@"PFUsername"];
//    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@",
//                                 [object objectForKey:@"message"]];
//    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [DHCommentCell cellHeightForComment:[self objectAtIndex:indexPath]];
//    return 60;
}

#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
}
*/

- (void)viewDidUnload
{
    [super viewDidUnload];
    [self setPhotoObject:nil];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)scrollToBottom
{
    int bottomIndex = [[self objects] count] - 1;
    if (bottomIndex >= 0) {
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:bottomIndex inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }
}


@end
