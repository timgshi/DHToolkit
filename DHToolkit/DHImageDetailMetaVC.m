//
//  DHImageDetailMetaVC.m
//  DHToolkit
//
//  Created by Tim Shi on 2/3/12.
//  Copyright (c) 2012 www.timshi.com. All rights reserved.
//

#import "DHImageDetailMetaVC.h"
#import "DHImageDetailMetaHeaderVC.h"
#import "DHImageDetailCommentTVC.h"

@interface DHImageDetailMetaVC()
@property (nonatomic, strong) DHImageDetailMetaHeaderVC *headerVC;
@property (nonatomic, strong) DHImageDetailCommentTVC *commentTVC;
@end

@implementation DHImageDetailMetaVC

@synthesize photoObject;
@synthesize managedPhoto;
@synthesize headerVC;
@synthesize commentTVC;

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

#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    UIImage *backgroundImage = [[UIImage imageNamed:@"BackgroundGradient.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    self.view.backgroundColor = [UIColor colorWithPatternImage:backgroundImage];
    self.headerVC = [[DHImageDetailMetaHeaderVC alloc] init];
    self.headerVC.photoObject = self.photoObject;
    [self.view addSubview:self.headerVC.view];
    self.commentTVC = [[DHImageDetailCommentTVC alloc] initWithStyle:UITableViewStylePlain];
    self.commentTVC.tableView.frame = CGRectMake(0, self.headerVC.view.frame.size.height, 320, 160);
    [self.view addSubview:self.commentTVC.tableView];
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
