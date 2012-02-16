//
//  DHImageDetailMetaHeaderVC.m
//  DHToolkit
//
//  Created by Tim Shi on 2/13/12.
//  Copyright (c) 2012 www.timshi.com. All rights reserved.
//

#import "DHImageDetailMetaHeaderVC.h"
#import <QuartzCore/QuartzCore.h>

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

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIImage *backgroundImage = [[UIImage imageNamed:@"BackgroundGradient.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    self.view.backgroundColor = [UIColor colorWithPatternImage:backgroundImage];
    if (self.photoObject) {
        self.usernameLabel.text = [photoObject objectForKey:@"DHDataWhoTook"];
        self.descriptionLabel.text = [photoObject objectForKey:@"DHDataSixWord"];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateStyle:kCFDateFormatterMediumStyle];
        [dateFormatter setTimeStyle:kCFDateFormatterMediumStyle];
        self.levelLabel.text = [[photoObject objectForKey:@"DHDataHappinessLevel"] stringValue];
        CGRect levelBarRect = self.levelBarView.frame;
        levelBarRect.size.width = (CGFloat) 250 * ([[photoObject objectForKey:@"DHDataHappinessLevel"] floatValue] / 10);
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
        NSNumber *lat = [photoObject objectForKey:@"DHDataGeoLat"];
        NSNumber *lon = [photoObject objectForKey:@"DHDataGeoLong"];
        if (lat && lon) {
//            self.locationMapView.centerCoordinate = CLLocationCoordinate2DMake([lat doubleValue], [lon doubleValue]);
            self.locationMapView.region = MKCoordinateRegionMakeWithDistance(CLLocationCoordinate2DMake([lat doubleValue], [lon doubleValue]), 5000, 5000);
            
        } else {
            self.locationMapView.hidden = YES;
        }
        
    } else {
        
    }
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
    [self setPhotoObject:nil];
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
