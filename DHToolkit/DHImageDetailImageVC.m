//
//  DHImageDetailImageVC.m
//  DHToolkit
//
//  Created by Tim Shi on 2/3/12.
//  Copyright (c) 2012 www.timshi.com. All rights reserved.
//

#import "DHImageDetailImageVC.h"
#import "Parse/PFQuery.h"
#import "ParsePoster.h"

@interface DHImageDetailImageVC()
@property (nonatomic, strong) UIImageView *photoImageView;
@property (nonatomic, strong) UILabel *smileLabel, *commentLabel;
@property (nonatomic, strong) UIImageView *smileImageView;
@end

@implementation DHImageDetailImageVC

@synthesize photoObject;
@synthesize managedPhoto;
@synthesize photoImageView;
@synthesize smileLabel, commentLabel;
@synthesize smileImageView;

- (UIImageView *)photoImageView
{
    if (!photoImageView) {
        NSData *photoData = managedPhoto.photoData;
        photoImageView = [[UIImageView alloc] initWithImage:[UIImage imageWithData:photoData]];
        photoImageView.frame = CGRectMake(0, -20, 320, 320);
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

- (void)updateIcons
{
    PFQuery *commentQuery = [PFQuery queryWithClassName:@"DHPhotoComment"];
    [commentQuery whereKey:@"DHPhotoID" equalTo:self.photoObject.objectId];
    [commentQuery countObjectsInBackgroundWithBlock:^(int number, NSError *error) {
        commentLabel.text = [NSString stringWithFormat:@"%d", number];
        PFQuery *smileQuery = [PFQuery queryWithClassName:@"DHPhotoSmile"];
        [smileQuery whereKey:@"DHPhotoID" equalTo:self.photoObject.objectId];
        [smileQuery countObjectsInBackgroundWithBlock:^(int number2, NSError *error) {
            smileLabel.text = [NSString stringWithFormat:@"%d", number2];
            commentLabel.hidden = NO;
            smileLabel.hidden = NO;
            PFUser *curUser = [PFUser currentUser];
            PFQuery *personalSmileQuery = [PFQuery queryWithClassName:@"DHPhotoSmile"];
            [personalSmileQuery whereKey:@"DHPhotoID" equalTo:self.photoObject.objectId];
            [personalSmileQuery whereKey:@"PFUsername" equalTo:curUser.username];
            [personalSmileQuery countObjectsInBackgroundWithBlock:^(int number, NSError *error) {
                if (number > 0) {
                    [smileImageView setImage:[UIImage imageNamed:@"smileyellow.png"]];
                }
            }];
        }];
    }];
}

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
    self.view.userInteractionEnabled = YES;
    [self.view addSubview:self.photoImageView];
//    UIButton *flipButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    UIImageView *commentImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"comment.png"]];
//    flipButton.titleLabel.text = @"Flip";
    commentImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapgr = [[UITapGestureRecognizer alloc] initWithTarget:self.parentViewController action:@selector(flipButtonPressed)];
    [commentImageView addGestureRecognizer:tapgr];
    commentImageView.frame = CGRectMake(280, 310, commentImageView.frame.size.width, commentImageView.frame.size.height);
    [self.view addSubview:commentImageView];
    UITapGestureRecognizer *smiletapgr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(postSmile)];
    smileImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"smile.png"]];
    smileImageView.userInteractionEnabled = YES;
    [smileImageView addGestureRecognizer:smiletapgr];
    smileImageView.frame = CGRectMake(220, 310, smileImageView.frame.size.width, smileImageView.frame.size.height);
    [self.view addSubview:smileImageView];
    smileLabel = [[UILabel alloc] init];
    smileLabel.font = [UIFont boldSystemFontOfSize:24];
    smileLabel.backgroundColor = [UIColor clearColor];
    smileLabel.textColor = [UIColor whiteColor];
    smileLabel.textAlignment = UITextAlignmentRight;
    smileLabel.hidden = YES;
    CGSize largestSize = [@"10" sizeWithFont:[UIFont boldSystemFontOfSize:24]];
    smileLabel.frame = CGRectMake(smileImageView.frame.origin.x - largestSize.width - 3, smileImageView.frame.origin.y, largestSize.width, largestSize.height);
    [self.view addSubview:smileLabel];
    commentLabel = [[UILabel alloc] init];
    commentLabel.font = [UIFont boldSystemFontOfSize:24];
    commentLabel.hidden = YES;
    commentLabel.backgroundColor = [UIColor clearColor];
    commentLabel.textColor = [UIColor whiteColor];
    commentLabel.textAlignment = UITextAlignmentRight;
    commentLabel.frame = CGRectMake(commentImageView.frame.origin.x - largestSize.width - 3, commentImageView.frame.origin.y, largestSize.width, largestSize.height);
    [self.view addSubview:commentLabel];
//    PFQuery *commentQuery = [PFQuery queryWithClassName:@"DHPhotoComment"];
//    [commentQuery whereKey:@"DHPhotoID" equalTo:self.photoObject.objectId];
//    [commentQuery countObjectsInBackgroundWithBlock:^(int number, NSError *error) {
//        commentLabel.text = [NSString stringWithFormat:@"%d", number];
//        PFQuery *smileQuery = [PFQuery queryWithClassName:@"DHPhotoSmile"];
//        [smileQuery whereKey:@"DHPhotoID" equalTo:self.photoObject.objectId];
//        [smileQuery countObjectsInBackgroundWithBlock:^(int number2, NSError *error) {
//            smileLabel.text = [NSString stringWithFormat:@"%d", number2];
//            commentLabel.hidden = NO;
//            smileLabel.hidden = NO;
//            PFUser *curUser = [PFUser currentUser];
//            PFQuery *personalSmileQuery = [PFQuery queryWithClassName:@"DHPhotoSmile"];
//            [personalSmileQuery whereKey:@"DHPhotoID" equalTo:self.photoObject.objectId];
//            [personalSmileQuery whereKey:@"PFUsername" equalTo:curUser.username];
//            [personalSmileQuery countObjectsInBackgroundWithBlock:^(int number, NSError *error) {
//                if (number > 0) {
//                    [smileImageView setImage:[UIImage imageNamed:@"smileyellow.png"]];
//                }
//            }];
//        }];
//    }];
    [self updateIcons];
//    [ addTarget:self.parentViewController action:@selector(flipButtonPressed) forControlEvents:UIControlEventTouchUpInside];
//    flipButton.frame = CGRectMake(20, 300, 100, 40);
//    [self.view addSubview:flipButton];
}




- (void)viewDidUnload
{
    [super viewDidUnload];
    [self setSmileImageView:nil];
    [self setSmileLabel:nil];
    [self setCommentLabel:nil];
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

- (void)postSmile
{
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

- (void)smileSuccess
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:DH_SMILE_UPLOAD_SUCCESS_NOTIFICATION object:nil];
//    PFQuery *commentQuery = [PFQuery queryWithClassName:@"DHPhotoComment"];
//    [commentQuery whereKey:@"DHPhotoID" equalTo:self.photoObject.objectId];
//    [commentQuery countObjectsInBackgroundWithBlock:^(int number, NSError *error) {
//        commentLabel.text = [NSString stringWithFormat:@"%d", number];
//        PFQuery *smileQuery = [PFQuery queryWithClassName:@"DHPhotoSmile"];
//        [smileQuery whereKey:@"DHPhotoID" equalTo:self.photoObject.objectId];
//        [smileQuery countObjectsInBackgroundWithBlock:^(int number2, NSError *error) {
//            smileLabel.text = [NSString stringWithFormat:@"%d", number2];
//            commentLabel.hidden = NO;
//            smileLabel.hidden = NO;
//        }];
//    }];
    [self updateIcons];
}

@end
