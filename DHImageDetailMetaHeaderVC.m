//
//  DHImageDetailMetaHeaderVC.m
//  DHToolkit
//
//  Created by Tim Shi on 2/13/12.
//  Copyright (c) 2012 www.timshi.com. All rights reserved.
//

#import "DHImageDetailMetaHeaderVC.h"

@implementation DHImageDetailMetaHeaderVC
@synthesize usernameLabel;
@synthesize descriptionLabel;
@synthesize dateHeaderLabel;
@synthesize dateLabel;
@synthesize weatherHeaderLabel;
@synthesize weatherLabel;
@synthesize levelLabel;
@synthesize levelBarView;
@synthesize locationMapView;

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

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [self setUsernameLabel:nil];
    [self setDescriptionLabel:nil];
    [self setDateHeaderLabel:nil];
    [self setDateLabel:nil];
    [self setWeatherHeaderLabel:nil];
    [self setWeatherLabel:nil];
    [self setLevelLabel:nil];
    [self setLevelBarView:nil];
    [self setLocationMapView:nil];
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
