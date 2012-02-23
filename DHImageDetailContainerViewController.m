//
//  DHImageDetailContainerViewController.m
//  DHToolkit
//
//  Created by Tim Shi on 2/3/12.
//  Copyright (c) 2012 www.timshi.com. All rights reserved.
//

#import "DHImageDetailContainerViewController.h"
#import "DHImageDetailImageVC.h"
#import "DHImageDetailMetaVC.h"
#import "UIBarButtonItem+CustomImage.h"
#import "Parse/PFUser.h"

@interface DHImageDetailContainerViewController() <UIActionSheetDelegate>
@property (nonatomic, strong) DHImageDetailImageVC *imageVC;
@property (nonatomic, strong) DHImageDetailMetaVC *metaVC;
@property (nonatomic, strong) UIView *containerView;
@property BOOL photoVisible;
@end


@implementation DHImageDetailContainerViewController

@synthesize photoObject;
@synthesize managedPhoto;
@synthesize imageVC;
@synthesize metaVC;
@synthesize photoVisible;
@synthesize containerView;

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
    self.containerView = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.view = self.containerView;
    self.imageVC = [[DHImageDetailImageVC alloc] init];
    self.imageVC.photoObject = self.photoObject;
    self.imageVC.managedPhoto = self.managedPhoto;
    [self addChildViewController:self.imageVC];
    self.metaVC = [[DHImageDetailMetaVC alloc] init];
    self.metaVC.photoObject = self.photoObject;
    self.metaVC.managedPhoto = self.managedPhoto;
    [self addChildViewController:self.metaVC];
    [self.containerView addSubview:self.imageVC.view];
    photoVisible = YES;
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem barButtonItemWithImage:[UIImage imageNamed:@"backarrow.png"] target:self action:@selector(backArrowPressed)];
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem barButtonItemWithImage:[UIImage imageNamed:@"trash.png"] target:self action:@selector(deleteButtonPressed)];
    PFUser *curUser = [PFUser currentUser];
    if (!curUser) {
        self.navigationItem.rightBarButtonItem = nil;
    } else {
        NSString *user1 = curUser.username;
        PFUser *photoUser = [photoObject objectForKey:@"PFUser"];
        NSString *user2 = photoUser.username;
        if (![user1 isEqualToString:user2]) self.navigationItem.rightBarButtonItem = nil;
    }
}

- (void)backArrowPressed
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    [self setContainerView:nil];
    [self setMetaVC:nil];
    [self setImageVC:nil];
    [self setManagedPhoto:nil];
    [self setPhotoObject:nil];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)deleteButtonPressed
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Are you sure you want to delete?" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Delete" otherButtonTitles: nil];
    [actionSheet showFromBarButtonItem:self.navigationItem.rightBarButtonItem animated:YES];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        [photoObject deleteInBackground];
        [[NSNotificationCenter defaultCenter] postNotificationName:DH_PHOTO_DELETE_NOTIFICATION object:nil];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)flipButtonPressed
{
    if (photoVisible) {
        
        [self transitionFromViewController:self.imageVC toViewController:self.metaVC duration:0.5 options:UIViewAnimationOptionTransitionFlipFromRight animations:^{
            
        } completion:^(BOOL finished) {
            photoVisible = NO;
        }];
    } else {
        [self transitionFromViewController:self.metaVC toViewController:self.imageVC duration:0.5 options:UIViewAnimationOptionTransitionFlipFromLeft animations:^{
            
        } completion:^(BOOL finished) {
            photoVisible = YES;
        }];
    }
}

@end
