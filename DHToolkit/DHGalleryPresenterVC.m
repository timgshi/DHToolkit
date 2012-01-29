//
//  DHGalleryPresenterVC.m
//  Designing-Happiness
//
//  Created by Tim Shi on 11/26/11.
//  Copyright (c) 2011 www.timshi.com. All rights reserved.
//

#import "DHGalleryPresenterVC.h"
#import "Photo+Photo_PF.h"

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@interface DHGalleryPresenterVC()
@property (nonatomic, strong) UILabel *descriptionLabel;
@property (nonatomic, strong) UIImageView *pictureView;
@property (nonatomic, strong) UIButton *xButton;
@property (nonatomic, strong) UIView *opaqueBar;
@property CGRect originalButtonRect;
@end

@implementation DHGalleryPresenterVC

@synthesize selectedPhoto;
@synthesize descriptionLabel;
@synthesize pictureView;
@synthesize xButton;
@synthesize delegate;
@synthesize originalButtonRect;
@synthesize opaqueBar;

- (UILabel *)descriptionLabel
{
    if (!descriptionLabel) {
        descriptionLabel = [[UILabel alloc] init];
        [descriptionLabel setBackgroundColor:[UIColor clearColor]];
        descriptionLabel.textColor = [UIColor whiteColor];
        descriptionLabel.frame = CGRectMake(20, 20, 160, 100);
        if (selectedPhoto) {
            descriptionLabel.text = selectedPhoto.name;
        }
    }
    return descriptionLabel;
}

- (UIImageView *)pictureView
{
    if (!pictureView) {
        pictureView = [[UIImageView alloc] init];
        if (selectedPhoto) {
            pictureView.image = [UIImage imageWithData:selectedPhoto.thumbnailData];
        }
    }
    return pictureView;
}

- (UIButton *)xButton
{
    if (!xButton) {
        xButton = [UIButton buttonWithType:UIButtonTypeCustom];
        xButton.frame = CGRectMake(5, 5, 20, 20);
        [xButton setImage:[UIImage imageNamed:@"31-circle-x.png"] forState:UIControlStateNormal];
        [xButton addTarget:self action:@selector(xButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    }
    return xButton;
}

- (UIView *)opaqueBar
{
    if (!opaqueBar) {
        opaqueBar = [[UIView alloc] init];
        [opaqueBar setBackgroundColor:UIColorFromRGB(0xFFE98D)];
        [opaqueBar setAlpha:0.9];
    }
    return opaqueBar;
}

- initWithPhoto:(Photo *)photo
{
    if (photo) {
        selectedPhoto = photo;
        self = [super init];
    } else {
        self = nil;
    }
    return self;
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

- (void)setLabelsHidden:(BOOL)hidden
{
    opaqueBar.hidden = hidden;
    descriptionLabel.hidden = hidden;
}

- (void)prepareToAddToSuperviewInRect:(CGRect)initialRect
{
    [self setLabelsHidden:YES];
    self.view.frame = initialRect;
    pictureView.frame = CGRectMake(0, 0, initialRect.size.width, initialRect.size.height);
    originalButtonRect = initialRect;
}

- (void)expandAndConfigureForRect:(CGRect)newRect
{
    [UIView animateWithDuration:0.5 animations:^{
        self.view.frame = newRect;
        pictureView.frame = CGRectMake(0, 0, newRect.size.width, newRect.size.height);
    } completion:^(BOOL finished) {
        if (finished) {
            self.opaqueBar.frame = CGRectMake(0, newRect.size.height - 30, newRect.size.width, 30);
            self.descriptionLabel.frame = CGRectMake(10, newRect.size.height - 25, newRect.size.width - 20, 20);
            [self setLabelsHidden:NO];
            [self.view addSubview:self.xButton];
        } 
    }];
}

- (void)minimizeToInitialRect
{
    [self.xButton removeFromSuperview];
    self.xButton = nil;
    [self setLabelsHidden:YES];
    [UIView animateWithDuration:0.5 animations:^{
        self.view.frame = originalButtonRect;
        self.pictureView.frame = CGRectMake(0, 0, originalButtonRect.size.width, originalButtonRect.size.height);
    } completion:^(BOOL finished) {
        [self.view removeFromSuperview];
    }];
}

- (void)xButtonPressed
{
    if (delegate) {
        [delegate galleryXButtonPressed];
    }
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
    [self.view addSubview:self.pictureView];
    [self.view addSubview:self.opaqueBar];
    [self.view addSubview:self.descriptionLabel];
    [self setLabelsHidden:YES];
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    descriptionLabel = nil;
    pictureView = nil;
    xButton = nil;
    opaqueBar = nil;
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}



@end
