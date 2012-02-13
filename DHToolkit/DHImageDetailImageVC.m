//
//  DHImageDetailImageVC.m
//  DHToolkit
//
//  Created by Tim Shi on 2/3/12.
//  Copyright (c) 2012 www.timshi.com. All rights reserved.
//

#import "DHImageDetailImageVC.h"


@interface DHImageDetailImageVC()
@property (nonatomic, strong) UIImageView *photoImageView;
@end

@implementation DHImageDetailImageVC

@synthesize photoObject;
@synthesize managedPhoto;
@synthesize photoImageView;

- (UIImageView *)photoImageView
{
    if (!photoImageView) {
        NSData *photoData = managedPhoto.photoData;
        photoImageView = [[UIImageView alloc] initWithImage:[UIImage imageWithData:photoData]];
        photoImageView.frame = CGRectMake(0, 0, 320, 320);
    }
    return photoImageView;
}

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
    [self.view addSubview:self.photoImageView];
    UIButton *flipButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    flipButton.titleLabel.text = @"Flip";
    [flipButton addTarget:self.parentViewController action:@selector(flipButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    flipButton.frame = CGRectMake(20, 300, 100, 40);
    [self.view addSubview:flipButton];
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
