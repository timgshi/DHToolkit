//
//  DHImageDetailMetaHeaderVC.m
//  DHToolkit
//
//  Created by Tim Shi on 2/13/12.
//  Copyright (c) 2012 www.timshi.com. All rights reserved.
//

#import "DHImageDetailMetaHeaderVC.h"
#import <QuartzCore/QuartzCore.h>
#import "PFObject+DHPhoto_MKAnnotation.h"
#import "Parse/PFQuery.h"
#import "ParsePoster.h"

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
@synthesize smileLabel;
@synthesize commentLabel;
@synthesize smileImageView;
@synthesize commentImageView;

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

#pragma mark - View lifecycle

- (void)updateIcons
{
    PFQuery *commentQuery = [PFQuery queryWithClassName:@"DHPhotoComment"];
    [commentQuery whereKey:@"DHPhotoID" equalTo:self.photoObject.objectId];
    [commentQuery countObjectsInBackgroundWithBlock:^(int number, NSError *error) {
        self.commentLabel.text = [NSString stringWithFormat:@"%d", number];
        PFQuery *smileQuery = [PFQuery queryWithClassName:@"DHPhotoSmile"];
        [smileQuery whereKey:@"DHPhotoID" equalTo:self.photoObject.objectId];
        [smileQuery countObjectsInBackgroundWithBlock:^(int number2, NSError *error) {
            self.smileLabel.text = [NSString stringWithFormat:@"%d", number2];
            self.commentLabel.hidden = NO;
            self.smileLabel.hidden = NO;
            PFUser *curUser = [PFUser currentUser];
            PFQuery *personalSmileQuery = [PFQuery queryWithClassName:@"DHPhotoSmile"];
            [personalSmileQuery whereKey:@"DHPhotoID" equalTo:self.photoObject.objectId];
            [personalSmileQuery whereKey:@"PFUsername" equalTo:curUser.username];
            [personalSmileQuery countObjectsInBackgroundWithBlock:^(int number, NSError *error) {
                if (number > 0) {
                    [self.smileImageView setHighlighted:YES];
                }
            }];
        }];
    }];
}

- (void)setupLabels
{
    CGSize descriptionSize = [self.descriptionLabel.text sizeWithFont:self.descriptionLabel.font constrainedToSize:CGSizeMake(147, 40) lineBreakMode:UILineBreakModeTailTruncation];
    self.descriptionLabel.numberOfLines = 2;
    CGFloat xForAll = self.usernameLabel.frame.origin.x;
    self.descriptionLabel.frame = CGRectMake(xForAll, self.usernameLabel.frame.origin.y + self.usernameLabel.frame.size.height - 4, descriptionSize.width, descriptionSize.height);
    self.dateHeaderLabel.frame = CGRectMake(xForAll, self.descriptionLabel.frame.origin.y + self.descriptionLabel.frame.size.height, self.dateHeaderLabel.frame.size.width, self.dateHeaderLabel.frame.size.height);
    self.dateLabel.frame = CGRectMake(xForAll, self.dateHeaderLabel.frame.origin.y + self.dateHeaderLabel.frame.size.height - 4, self.dateLabel.frame.size.width, self.dateLabel.frame.size.height);
    self.weatherHeaderLabel.frame = CGRectMake(xForAll, self.dateLabel.frame.origin.y + self.dateLabel.frame.size.height, self.weatherHeaderLabel.frame.size.width, self.weatherHeaderLabel.frame.size.height);
    self.weatherLabel.frame = CGRectMake(xForAll, self.weatherHeaderLabel.frame.origin.y + self.weatherHeaderLabel.frame.size.height - 4, self.weatherLabel.frame.size.width, self.weatherLabel.frame.size.height);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UITapGestureRecognizer *smiletapgr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(postSmile)];
    [self.smileImageView addGestureRecognizer:smiletapgr];
    self.smileLabel.hidden = YES;
    self.commentLabel.hidden = YES;
    [self updateIcons];
    UIImage *backgroundImage = [[UIImage imageNamed:@"BackgroundGradient.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    self.view.backgroundColor = [UIColor colorWithPatternImage:backgroundImage];
    if (self.photoObject) {
        self.usernameLabel.text = [photoObject objectForKey:@"DHDataWhoTook"];
        self.descriptionLabel.text = [photoObject objectForKey:@"DHDataSixWord"];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateStyle:kCFDateFormatterShortStyle];
        [dateFormatter setTimeStyle:kCFDateFormatterShortStyle];
        self.levelLabel.text = [[photoObject objectForKey:@"DHDataHappinessLevel"] stringValue];
        CGRect levelBarRect = self.levelBarView.frame;
        levelBarRect.size.width = (CGFloat) 320 * ([[photoObject objectForKey:@"DHDataHappinessLevel"] floatValue] / 10);
        self.levelBarView.frame = levelBarRect;
        self.dateLabel.text = [dateFormatter stringFromDate:self.photoObject.createdAt];
        NSString *weatherCondition = [photoObject objectForKey:@"DHDataWeatherCondition"];
        NSString *weatherTemperature = [photoObject objectForKey:@"DHDataWeatherTemperature"];
        if (weatherCondition && weatherTemperature) {
            NSString *weatherText = [NSString stringWithFormat:@"%@ %@°F", weatherCondition, weatherTemperature];
            self.weatherLabel.text = weatherText;
        } else {
            self.weatherLabel.hidden = YES;
        }
        self.locationMapView.layer.cornerRadius = 10.0;
        self.locationMapView.layer.shadowOffset = CGSizeMake(0, 3);
        self.locationMapView.layer.shadowColor = [UIColor blackColor].CGColor;
        self.locationMapView.layer.shadowOpacity = 0.75;
        self.locationMapView.layer.shadowRadius = 10.0f;
        self.locationMapView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapgr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(mapClicked)];
        [self.locationMapView addGestureRecognizer:tapgr];
        NSNumber *lat = [photoObject objectForKey:@"DHDataGeoLat"];
        NSNumber *lon = [photoObject objectForKey:@"DHDataGeoLong"];
        if (lat && lon) {
//            self.locationMapView.centerCoordinate = CLLocationCoordinate2DMake([lat doubleValue], [lon doubleValue]);
            self.locationMapView.region = MKCoordinateRegionMakeWithDistance(CLLocationCoordinate2DMake([lat doubleValue], [lon doubleValue]), 500, 500);
            [self.locationMapView addAnnotation:self.photoObject];
            
        } else {
            self.locationMapView.hidden = YES;
        }
        [self setupLabels];
    } else {
        
    }
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self updateIcons];
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
    [self setPhotoObject:nil];
    [self setSmileLabel:nil];
    [self setCommentLabel:nil];
    [self setSmileImageView:nil];
    [self setCommentImageView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - MKMapViewDelegate Methods

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    MKAnnotationView *pinView = [mapView dequeueReusableAnnotationViewWithIdentifier:@"MK"];
    if (!pinView) {
        pinView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"MK"];
        pinView.canShowCallout = NO;
    }
    return pinView;
}

#pragma mark - Smile Posting

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
    [self updateIcons];
}

- (void)mapClicked
{
    [[GANTracker sharedTracker] trackEvent:@"detail_interaction" action:@"map_pressed" label:self.photoObject.objectId value:0 withError:nil];
    NSNumber *lat = [photoObject objectForKey:@"DHDataGeoLat"];
    NSNumber *lon = [photoObject objectForKey:@"DHDataGeoLong"];
    NSString *urlString = [NSString stringWithFormat:@"http://maps.google.com/maps?z=1000&q=%f,%f", [lat doubleValue], [lon doubleValue]];
    urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *mapURL = [NSURL URLWithString:urlString];
    [[UIApplication sharedApplication] openURL:mapURL];
}

@end
