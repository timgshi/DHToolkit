//
//  DHImageSmileTagVC.m
//  DHToolkit
//
//  Created by Tim Shi on 2/16/12.
//  Copyright (c) 2012 www.timshi.com. All rights reserved.
//

#import "DHImageSmileTagVC.h"
#import "Parse/PFObject.h"
#import "Parse/PFQuery.h"
#import "ParsePoster.h"

@interface DHImageSmileTagVC()
@property (nonatomic, strong) UIImageView *smileImageView;
@property (nonatomic, strong) UILabel *smileLabel;

@end

@implementation DHImageSmileTagVC

@synthesize photoObject;
@synthesize smileImageView;
@synthesize smileLabel;
@synthesize imageViewOrigin;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (id)initWithOrigin:(CGPoint)anOrigin
{
    self = [super init];
    if (self) {
        imageViewOrigin = anOrigin;
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


- (void)updateIcon
{
    if (self.photoObject) {
        PFQuery *smileQuery = [PFQuery queryWithClassName:@"DHPhotoSmile"];
        [smileQuery whereKey:@"DHPhotoID" equalTo:self.photoObject.objectId];
        [smileQuery countObjectsInBackgroundWithBlock:^(int number2, NSError *error) {
            smileLabel.text = [NSString stringWithFormat:@"%d", number2];
            smileLabel.hidden = NO;
            PFUser *curUser = [PFUser currentUser];
            if (curUser) {
                PFQuery *personalSmileQuery = [PFQuery queryWithClassName:@"DHPhotoSmile"];
                [personalSmileQuery whereKey:@"DHPhotoID" equalTo:self.photoObject.objectId];
                [personalSmileQuery whereKey:@"PFUsername" equalTo:curUser.username];
                [personalSmileQuery countObjectsInBackgroundWithBlock:^(int number, NSError *error) {
                    if (number > 0) {
                        [smileImageView setHighlighted:YES];
                    } else {
                        [smileImageView setHighlighted:NO];
                    }
                }];
            }
        }];
    }
}

// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
    smileImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"smiletaggray.png"] highlightedImage:[UIImage imageNamed:@"smiletagyellow.png"]];
    smileImageView.frame = CGRectMake(imageViewOrigin.x, imageViewOrigin.y, smileImageView.frame.size.width, smileImageView.frame.size.height);
    smileImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapgr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(smilePressed)];
    [smileImageView addGestureRecognizer:tapgr];
    smileLabel = [[UILabel alloc] init];
    smileLabel.textColor = [UIColor whiteColor];
    smileLabel.backgroundColor = [UIColor clearColor];
    CGSize labelSize = [@"10" sizeWithFont:[UIFont boldSystemFontOfSize:16.0f]];
    smileLabel.textAlignment = UITextAlignmentRight;
    smileLabel.font = [UIFont boldSystemFontOfSize:16.0f];
    smileLabel.frame = CGRectMake(3, 11, labelSize.width, labelSize.height);
    smileLabel.hidden = YES;
    [smileImageView addSubview:smileLabel];
    self.view = smileImageView;
}



// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self updateIcon];
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    [self setPhotoObject:nil];
    [self setSmileLabel:nil];
    [self setSmileImageView:nil];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)setPhotoObject:(PFObject *)aPhotoObject
{
    photoObject = aPhotoObject;
    [self updateIcon];
}

- (void)smilePressed
{   
    if (self.photoObject) {
        if ([PFUser currentUser]) {
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(smileSuccess) name:DH_SMILE_UPLOAD_SUCCESS_NOTIFICATION object:nil];
            [ParsePoster postSmileForPhoto:self.photoObject];
        } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" 
                                                            message:@"You must be logged in to smile!" 
                                                           delegate:nil 
                                                  cancelButtonTitle:@"OK" 
                                                  otherButtonTitles: nil];
            [alert show];
        }
    }
}

- (void)smileSuccess
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:DH_SMILE_UPLOAD_SUCCESS_NOTIFICATION object:nil];
    [self updateIcon];
}

@end
