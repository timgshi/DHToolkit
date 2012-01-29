//
//  DHGalleryVC.m
//  Designing-Happiness
//
//  Created by Tim Shi on 11/25/11.
//  Copyright (c) 2011 www.timshi.com. All rights reserved.
//

#import "DHGalleryVC.h"
#import "Photo+Photo_PF.h"
#import "UIImage+Resize.h"
#import "DHGalleryPresenterVC.h"

@interface DHGalleryVC() <DHGalleryPresenterDelegate>
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) DHGalleryPresenterVC *galleryPresenter;
@end

@implementation DHGalleryVC

@synthesize fetchedResultsController;
@synthesize scrollView, containerView;
@synthesize galleryPresenter;

- (UIScrollView *)scrollView
{
    if (!scrollView) {
        scrollView = [[UIScrollView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        scrollView.backgroundColor = [UIColor blackColor];
    }
    return scrollView;
}

- (UIView *)containerView
{
    if (!containerView)
    {
        containerView = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    }
    return containerView;
}


- (void)setFetchedResultsController:(NSFetchedResultsController *)controller
{
    fetchedResultsController.delegate = nil;
	fetchedResultsController = controller;
	controller.delegate = self;
}

- initInManagedObjectContext:(NSManagedObjectContext *)context
{
    if (context) {
        self = [super init];
        NSFetchRequest *fetchRequest = nil;
        fetchRequest = [[NSFetchRequest alloc] init];
        fetchRequest.entity = [NSEntityDescription entityForName:@"Photo"
                                          inManagedObjectContext:context];
        fetchRequest.sortDescriptors = [NSArray arrayWithObject:
                                        [NSSortDescriptor sortDescriptorWithKey:@"timestamp"
                                                                      ascending:NO
                                                                       selector:@selector(compare:)]];
        NSFetchedResultsController *frc = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                                                              managedObjectContext:context
                                                                                sectionNameKeyPath:nil
                                                                                         cacheName:nil];
        self.fetchedResultsController = frc;
        self.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Gallery" image:[UIImage imageNamed:@"42-photos.png"] tag:0];
        self.title = @"Gallery";
    } else {
        self = nil;
    }
    return self;
}


//- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
//{
//    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
//    if (self) {
//        // Custom initialization
//    }
//    return self;
//}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}



#pragma mark - Display Drawing

#define DEFAULT_THUMB_WIDTH 80
#define DEFAULT_THUMB_HEIGHT 80
#define DEFAULT_BIG_IMAGE_WIDTH 250
#define DEFAULT_BIG_IMAGE_HEIGHT 250

- (UIImage *)thumbForDHPhoto:(Photo *)photo
{
    UIImage *thumb = nil;
    if (photo.smallThumbData == nil) {
        if (photo.thumbnailData != nil) {
            UIImage *bigThumb = [UIImage imageWithData:photo.thumbnailData];
            thumb = [bigThumb thumbnailImage:DEFAULT_THUMB_WIDTH transparentBorder:0 cornerRadius:0 interpolationQuality:kCGInterpolationHigh];
            photo.smallThumbData = UIImageJPEGRepresentation(thumb, 1.0);
            [self.fetchedResultsController.managedObjectContext save:nil];
        }
    } else {
        thumb = [UIImage imageWithData:photo.smallThumbData];
    }
    return thumb;
}

- (void)updateDisplay
{
    for (UIView *subview in [scrollView subviews]) {
        if ([subview isKindOfClass:[UIButton class]]) {
            [subview removeFromSuperview];
        }
    }
    int row = 0;
	int column = 0;
	for(int i = 0; i < [self.fetchedResultsController.fetchedObjects count]; ++i) {
        NSIndexPath *indexPathForCurrentIndex = [NSIndexPath indexPathForRow:i inSection:0];
		UIImage *thumb = [self thumbForDHPhoto:[self.fetchedResultsController objectAtIndexPath:indexPathForCurrentIndex]];
		UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
		button.frame = CGRectMake(column * DEFAULT_THUMB_WIDTH, 
                                  row * DEFAULT_THUMB_HEIGHT, 
                                  DEFAULT_THUMB_WIDTH, 
                                  DEFAULT_THUMB_HEIGHT);
        button.autoresizingMask = UIViewAutoresizingNone;
		[button setImage:thumb forState:UIControlStateNormal];
        if (thumb == nil) {
            UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
            spinner.frame = CGRectMake((button.frame.size.width / 2) - (spinner.frame.size.width / 2), (button.frame.size.height / 2) - (spinner.frame.size.height / 2), spinner.frame.size.width, spinner.frame.size.height);
            [button addSubview:spinner];
            [spinner startAnimating];
        }
		[button addTarget:self 
				   action:@selector(buttonClicked:) 
		 forControlEvents:UIControlEventTouchUpInside];
		button.tag = i; 
		[self.scrollView addSubview:button];
		if (column == 3) {
			column = 0;
			row++;
		} else {
			column++;
		}
	}
    for (UIView *subview in [scrollView subviews]) {
        if (![subview isKindOfClass:[UIButton class]]) {
            NSLog(@"Bring to Front %@", NSStringFromClass([subview class]));
            [self.scrollView bringSubviewToFront:subview];
        }
    }
    [self.scrollView setContentSize:CGSizeMake(320, (row+3) * DEFAULT_THUMB_HEIGHT)];
}

- (void)performFetch
{
    NSError *error = nil;
    [self.fetchedResultsController performFetch:&error];
    if (error) {
        NSLog(@"[CoreDataTableViewController performFetchForTableView:] %@ (%@)", [error localizedDescription], [error localizedFailureReason]);
    }
    [self updateDisplay];
}

- (void)galleryXButtonPressed
{
    [self.galleryPresenter minimizeToInitialRect];
    self.galleryPresenter = nil;
    [self.scrollView setScrollEnabled:YES];
}

- (void)buttonClicked:(UIButton *)button
{
    if (!galleryPresenter) {
        NSInteger index = button.tag;
        NSIndexPath *indexPathForCurrentIndex = [NSIndexPath indexPathForRow:index inSection:0];
        Photo *photo = [self.fetchedResultsController objectAtIndexPath:indexPathForCurrentIndex];
        galleryPresenter = [[DHGalleryPresenterVC alloc] initWithPhoto:photo];
        galleryPresenter.delegate = self;
        [galleryPresenter prepareToAddToSuperviewInRect:button.frame];
        [self.scrollView addSubview:galleryPresenter.view];
        CGRect screenRect = self.scrollView.frame;
        CGRect newFrame = button.frame;
        CGPoint newOrigin = CGPointMake((screenRect.size.width / 2) - (DEFAULT_BIG_IMAGE_WIDTH / 2), self.scrollView.contentOffset.y + (screenRect.size.height / 2) - (DEFAULT_BIG_IMAGE_HEIGHT / 2) - 45);
        CGSize newSize = CGSizeMake(DEFAULT_BIG_IMAGE_WIDTH, DEFAULT_BIG_IMAGE_HEIGHT);
        newFrame.origin = newOrigin;
        newFrame.size = newSize;
        [galleryPresenter expandAndConfigureForRect:newFrame];
        [self.scrollView setScrollEnabled:NO];
    } else {
        [self galleryXButtonPressed];
    }
}



#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/


- (void)viewDidLoad
{
    [super viewDidLoad];
    UIScrollView *scroller = self.scrollView;
    [self.containerView addSubview:scroller];
    [self.containerView setBackgroundColor:[UIColor blackColor]];
    self.view = self.containerView;
    [self.view setBackgroundColor:[UIColor blackColor]];
    [self.navigationController.view setBackgroundColor:[UIColor blackColor]];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (!self.fetchedResultsController.fetchedObjects) {
        [self performFetch];
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.galleryPresenter = nil;
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - NSFetchedResultsControllerDelegate

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
//    [self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller
  didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
		   atIndex:(NSUInteger)sectionIndex
	 forChangeType:(NSFetchedResultsChangeType)type
{	
    switch(type)
	{
        case NSFetchedResultsChangeInsert:
//            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
			
        case NSFetchedResultsChangeDelete:
//            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}


- (void)controller:(NSFetchedResultsController *)controller
   didChangeObject:(id)anObject
	   atIndexPath:(NSIndexPath *)indexPath
	 forChangeType:(NSFetchedResultsChangeType)type
	  newIndexPath:(NSIndexPath *)newIndexPath
{	
//    UITableView *tableView = self.tableView;
	
    switch(type)
	{
        case NSFetchedResultsChangeInsert:
//            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
			
        case NSFetchedResultsChangeDelete:
//            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
			
        case NSFetchedResultsChangeUpdate:
//			[tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
			
        case NSFetchedResultsChangeMove:
//            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
//            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
//    [self.tableView endUpdates];
//    if ([[self sectionIndexTitlesForTableView:self.tableView] count] > 1) {
//        NSLog(@"CoreDataTableViewController: updating section indexes by reloading table (workaround)");
//        [self.tableView reloadData];  // iOS bug workaround (section indexes don't update)
//    }
    [self updateDisplay];
}


@end