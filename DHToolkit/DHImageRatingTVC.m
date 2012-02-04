//
//  DHImageRatingTVC.m
//  DHToolkit
//
//  Created by Tim Shi on 1/8/12.
//  Copyright (c) 2012 www.timshi.com. All rights reserved.
//

#import "DHImageRatingTVC.h"
#import <MapKit/MapKit.h>
#import "Parse/PFObject.h"
#import "Parse/PFFile.h"
#import "Parse/PFUser.h"
#import "Parse/PFACL.h"
#import "ParsePoster.h"
#import "GoogleWeatherFetcher.h"
#import "UIBarButtonItem+CustomImage.h"
#import <Twitter/Twitter.h>
#import <Accounts/Accounts.h>

@interface DHImageRatingTVC() <CLLocationManagerDelegate, GoogleWeatherFetcherDelegate, UITextFieldDelegate, UIAlertViewDelegate>
@property int imageRating;
@property BOOL isPrivate;
@property (nonatomic, strong) UISlider *ratingSlider;
@property (nonatomic, strong) UILabel *ratingLabel, *locationLabel;
@property (nonatomic, strong) UITextField *descriptionField;
@property (nonatomic, strong) UISwitch *privacySwitch, *anonymousSwitch, *twitterSwitch;
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) CLLocation *currentLocation;
@property (nonatomic, strong) CLGeocoder *geocoder;
@property (nonatomic, strong) NSString *locationString;
@property (nonatomic, strong) GoogleWeatherFetcher *weatherFetcher;
@property (nonatomic, strong) NSString *weatherCondition, *weatherTemperature;
@end

@implementation DHImageRatingTVC

@synthesize delegate;
@synthesize imageRating, isPrivate;
@synthesize ratingSlider;
@synthesize ratingLabel, locationLabel;
@synthesize descriptionField;
@synthesize privacySwitch, anonymousSwitch, twitterSwitch;
@synthesize locationManager, currentLocation;
@synthesize geocoder;
@synthesize locationString;
@synthesize selectedPhoto;
@synthesize weatherFetcher;
@synthesize weatherCondition, weatherTemperature;

#define kDHDataSixWordKey @"DHDataSixWord"
#define kDHDataHappinessLevelKey @"DHDataHappinessLevel"
#define kDHDataWhoTookKey @"DHDataWhoTook"
#define kDHDataGroupNameKey @"DHDataGroupName"
#define kDHDataTimestampKey @"DHDataTimestamp"
#define kDHDataGeoLatKey @"DHDataGeoLat"
#define kDHDataGeoLongKey @"DHDataGeoLong"
#define kDHDataWeatherConditionKey @"DHDataWeatherCondition"
#define kDHDataWeatherTemperatureKey @"DHDataWeatherTemperature"
#define kDHDataLocationStringKey @"DHDataLocationString"
#define kDHDataPrivacyKey @"isPrivate"


- (id)init
{
    self = [super initWithStyle:UITableViewStylePlain];
    if (self) {
        self.tableView.allowsSelection = NO;
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

- (CLLocationManager *)locationManager
{
    if (!locationManager) {
        locationManager = [[CLLocationManager alloc] init];
        locationManager.delegate = self;
        locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    }
    return locationManager;
}

- (void)tweetMomentWithPhotoData:(NSData *)photoData
{
    ACAccountStore *accountStore = [[ACAccountStore alloc] init];
	
	// Create an account type that ensures Twitter accounts are retrieved.
    ACAccountType *accountType = [accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
	
	// Request access from the user to use their Twitter accounts.
    [accountStore requestAccessToAccountsWithType:accountType withCompletionHandler:^(BOOL granted, NSError *error) {
        if(granted) {
			// Get the list of Twitter accounts.
            NSArray *accountsArray = [accountStore accountsWithAccountType:accountType];
			
			// For the sake of brevity, we'll assume there is only one Twitter account present.
			// You would ideally ask the user which account they want to tweet from, if there is more than one Twitter account present.
			if ([accountsArray count] > 0) {
				// Grab the initial Twitter account to tweet from.
				ACAccount *twitterAccount = [accountsArray objectAtIndex:0];
				
				// Create a request, which in this example, posts a tweet to the user's timeline.
				// This example uses version 1 of the Twitter API.
				// This may need to be changed to whichever version is currently appropriate.
//				TWRequest *postRequest = [[TWRequest alloc] initWithURL:[NSURL URLWithString:@"http://api.twitter.com/1/statuses/update.json"] parameters:[NSDictionary dictionaryWithObject:@"Hello. This is a tweet." forKey:@"status"] requestMethod:TWRequestMethodPOST];
				TWRequest *postRequest = [[TWRequest alloc] initWithURL:[NSURL URLWithString:@"https://upload.twitter.com/1/statuses/update_with_media.json"] parameters:nil requestMethod:TWRequestMethodPOST];
                [postRequest addMultiPartData:photoData withName:@"media" type:@"image/jpg"];
                NSData *messageData = [[NSString stringWithFormat:@"I just shared a moment of happiness #DHToolkit"] dataUsingEncoding:NSUTF8StringEncoding];
                [postRequest addMultiPartData:messageData withName:@"status" type:@"text/plain"];
                NSData *latData = [[NSString stringWithFormat:@"%f", self.currentLocation.coordinate.latitude] dataUsingEncoding:NSUTF8StringEncoding];
                NSData *lonData = [[NSString stringWithFormat:@"%f", self.currentLocation.coordinate.longitude] dataUsingEncoding:NSUTF8StringEncoding];
                NSData *trueData = [[NSString stringWithFormat:@"true"] dataUsingEncoding:NSUTF8StringEncoding];
                [postRequest addMultiPartData:latData withName:@"lat" type:@"text/plain"];
                [postRequest addMultiPartData:lonData withName:@"long" type:@"text/plain"];
                [postRequest addMultiPartData:trueData withName:@"display_coordinates" type:@"text/plain"];
				// Set the account used to post the tweet.
				[postRequest setAccount:twitterAccount];
				
				// Perform the request created above and create a handler block to handle the response.
				[postRequest performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
					NSString *output = [NSString stringWithFormat:@"HTTP response status: %i", [urlResponse statusCode]];
                    NSLog(@"%@", output);
				}];
			}
        }
	}];

}

- (void)savePhotoObject
{
    if (self.weatherFetcher) {
        [self.weatherFetcher cancel];
        self.weatherFetcher = nil;
    }
    NSMutableDictionary *metaDict = [NSMutableDictionary dictionary];
    [metaDict setObject:[PFUser currentUser] forKey:@"PFUser"];
    if (self.descriptionField.text.length) {
        [metaDict setObject:self.descriptionField.text forKey:kDHDataSixWordKey];
    } else {
        [metaDict setObject:@"" forKey:kDHDataSixWordKey];
    }
    [metaDict setObject:[NSNumber numberWithInt:self.imageRating] forKey:kDHDataHappinessLevelKey];
    PFUser *curUser = [PFUser currentUser];
    [metaDict setObject:curUser.username forKey:kDHDataWhoTookKey];
    [metaDict setObject:[NSDate date] forKey:kDHDataTimestampKey];
    if (self.currentLocation) {
        [metaDict setObject:[NSNumber numberWithDouble:self.currentLocation.coordinate.latitude] forKey:kDHDataGeoLatKey];
        [metaDict setObject:[NSNumber numberWithDouble:self.currentLocation.coordinate.longitude] forKey:kDHDataGeoLongKey];
        if (self.locationString) {
            [metaDict setObject:self.locationString forKey:kDHDataLocationStringKey];
        }
    }
    if (self.weatherCondition) [metaDict setObject:self.weatherCondition forKey:kDHDataWeatherConditionKey];
    if (self.weatherTemperature) [metaDict setObject:self.weatherTemperature forKey:kDHDataWeatherTemperatureKey];
    if ([[NSUserDefaults standardUserDefaults] boolForKey:kPRIVACY_PREF_KEY] || self.privacySwitch.on) {
        [metaDict setObject:[NSNumber numberWithBool:YES] forKey:kDHDataPrivacyKey];
    } else {
        [metaDict setObject:[NSNumber numberWithBool:NO] forKey:kDHDataPrivacyKey];
    }
    [metaDict setObject:[NSNumber numberWithBool:self.anonymousSwitch.on] forKey:@"isAnonymous"];
    [ParsePoster postPhotoWithMetaInfo:metaDict andPhotoData:UIImageJPEGRepresentation(selectedPhoto, 0.8)];
    if (twitterSwitch.on) {
        [self tweetMomentWithPhotoData:UIImageJPEGRepresentation(selectedPhoto, 0.8)];
    }
}

#pragma mark - Nav Bar Buttons

- (void)saveButtonPressed
{
    [self savePhotoObject];
    [self.delegate imageRatingTVCDidFinish:self withSave:YES];
}

- (void)cancelButtonPressed
{
    [self.delegate imageRatingTVCDidFinish:self withSave:NO];
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
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(saveButtonPressed)];
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem barButtonItemWithImage:[UIImage imageNamed:@"plus.png"] target:self action:@selector(saveButtonPressed)];
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelButtonPressed)];
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem barButtonItemWithImage:[UIImage imageNamed:@"cancel.png"] target:self action:@selector(cancelButtonPressed)];
    self.title = @"Capture";
    self.imageRating = 5;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if ([CLLocationManager locationServicesEnabled]) {
        [self.locationManager startUpdatingLocation];
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    [self setRatingSlider:nil];
    [self setRatingLabel:nil];
    [self setLocationLabel:nil];
    [self setDescriptionField:nil];
    [self setPrivacySwitch:nil];
    [self setLocationManager:nil];
    [self setWeatherFetcher:nil];
    [self setCurrentLocation:nil];
    [self setLocationString:nil];
    [self setGeocoder:nil];
    [self setWeatherCondition:nil];
    [self setWeatherTemperature:nil];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table UI Elements

- (UISlider *)ratingSlider
{
    if (!ratingSlider) {
        ratingSlider = [[UISlider alloc] init];
        ratingSlider.transform = CGAffineTransformMakeScale(0.7, 0.7);
        ratingSlider.frame = CGRectMake(35, 10, 275, 20);
        [ratingSlider addTarget:self action:@selector(sliderChanged:) forControlEvents:UIControlEventValueChanged];
        [ratingSlider setMinimumTrackTintColor:[UIColor colorWithRed:253/255.0 green:193/255.0 blue:49/255.0 alpha:1]];
        [ratingSlider setMaximumValue:10];
        [ratingSlider setMinimumValue:1];
        [ratingSlider setMinimumValueImage:[UIImage imageNamed:@"sadface.png"]];
        [ratingSlider setMaximumValueImage:[UIImage imageNamed:@"happyface.png"]];
        [ratingSlider setValue:self.imageRating];
    }
    return ratingSlider;
}

- (void)sliderChanged:(id)sender
{
    [self.ratingLabel setText:[NSString stringWithFormat:@"%d", (int)self.ratingSlider.value]];
    self.imageRating = (int)self.ratingSlider.value;
}

- (UILabel *)ratingLabel
{
    if (!ratingLabel) {
        ratingLabel = [[UILabel alloc] initWithFrame:CGRectMake(11, 6, 25, 28)];
        [ratingLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:20]];
        [ratingLabel setTextColor:[UIColor whiteColor]];
        [ratingLabel setBackgroundColor:[UIColor clearColor]];
        [ratingLabel setText:@"5"];
    }
    return ratingLabel;
}

- (UILabel *)locationLabel
{
    if (!locationLabel) {
        locationLabel = [[UILabel alloc] initWithFrame:CGRectMake(34, 5, 250, 28)];
        [locationLabel setFont:[UIFont fontWithName:@"Helvetica" size:16]];
        [locationLabel setTextColor:[UIColor colorWithRed:200/255.0 green:200/255.0 blue:200/255.0 alpha:1.0]];
        [locationLabel setBackgroundColor:[UIColor clearColor]];
        [locationLabel setText:@"Searching for location..."];
        [locationLabel setUserInteractionEnabled:YES];
        UIGestureRecognizer *tapgr = [[UIGestureRecognizer alloc] initWithTarget:self action:@selector(locationTapped)];
        [locationLabel addGestureRecognizer:tapgr];
    }
    return locationLabel;
}

- (void)locationTapped
{
    if (self.locationString) {
        //[locationLabel setText:self.locationString];
    }
}

- (UITextField *)descriptionField
{
    if (!descriptionField) {
        descriptionField = [[UITextField alloc] initWithFrame:CGRectMake(9, 8, 280, 22)];
        [descriptionField setFont:[UIFont fontWithName:@"Helvetica" size:16]];
        [descriptionField setTextColor:[UIColor whiteColor]];
        [descriptionField setPlaceholder:@"Describe this moment..."];
        [descriptionField setAutocapitalizationType:UITextAutocapitalizationTypeNone];
        [descriptionField setAutocorrectionType:UITextAutocorrectionTypeNo];
        [descriptionField setReturnKeyType:UIReturnKeyDone];
        [descriptionField setDelegate:self];
    }
    return descriptionField;
}

- (UISwitch *)privacySwitch
{
    if (!privacySwitch) {
        privacySwitch = [[UISwitch alloc] init];
        privacySwitch.frame = CGRectMake(231, 6, 10, 10);
        privacySwitch.transform = CGAffineTransformMakeScale(0.70, 0.70);
        privacySwitch.onTintColor = [UIColor colorWithRed:253/255.0 green:193/255.0 blue:49/255.0 alpha:1];
    }
    return privacySwitch;
}

- (UISwitch *)anonymousSwitch
{
    if (!anonymousSwitch) {
        anonymousSwitch = [[UISwitch alloc] init];
        anonymousSwitch.frame = CGRectMake(231, 6, 10, 10);
        anonymousSwitch.transform = CGAffineTransformMakeScale(0.70, 0.70);
        anonymousSwitch.onTintColor = [UIColor colorWithRed:253/255.0 green:193/255.0 blue:49/255.0 alpha:1];
    }
    return anonymousSwitch;
}
 
- (UISwitch *)twitterSwitch
{
    if (!twitterSwitch) {
        twitterSwitch = [[UISwitch alloc] init];
        twitterSwitch.frame = CGRectMake(231, 6, 10, 10);
        twitterSwitch.transform = CGAffineTransformMakeScale(0.70, 0.70);
        twitterSwitch.onTintColor = [UIColor colorWithRed:253/255.0 green:193/255.0 blue:49/255.0 alpha:1];
        [twitterSwitch addTarget:self action:@selector(twitterSwitchMoved) forControlEvents:UIControlEventValueChanged];
    }
    return twitterSwitch;
}

- (void)twitterSwitchMoved
{
    if (self.twitterSwitch.on) {
        ACAccountStore *accountStore = [[ACAccountStore alloc] init];
        
        // Create an account type that ensures Twitter accounts are retrieved.
        ACAccountType *accountType = [accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
        
        // Request access from the user to use their Twitter accounts.
        [accountStore requestAccessToAccountsWithType:accountType withCompletionHandler:^(BOOL granted, NSError *error) {
            if (granted) {
                NSArray *accounts = [accountStore accountsWithAccountType:accountType];
                if ([accounts count] == 0) {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Twitter" message:@"Please sign into twitter in the settings app to tweet your messages" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Settings", nil];
                    [alert show];
                    [self.twitterSwitch setOn:NO animated:YES];
                }
            }
        }];

    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ([alertView.title isEqualToString:@"Twitter"]) {
        if (buttonIndex == 1) {
            NSURL *locationServicesURL = [NSURL URLWithString:@"prefs:root=TWITTER"];
            [[UIApplication sharedApplication] openURL:locationServicesURL];
        }
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return 3;
            break;
        case 1:
            return 3;
            break;
        default:
            return 1;
            break;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel *label = (UILabel *)[super tableView:tableView viewForHeaderInSection:section];
    switch (section) {
        case 0:
            [label setText:@"  RATE THIS MOMENT"];
            break;
        case 1:
            [label setText:@"  SHARING SETTINGS"];
            break;
        default:
            break;
    }
    return label;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
    switch ([indexPath section]) {
        case 0:
            if ([indexPath row] == 0) {
                [cell.contentView addSubview:self.ratingLabel];
                [cell.contentView addSubview:self.ratingSlider];
            } else if ([indexPath row] == 1) {
                [cell.contentView addSubview:self.descriptionField];
            } else {
                UIImageView *locationView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"location.png"]];
                CGRect frame = locationView.frame;
                frame.origin.x = 12;
                frame.origin.y = 5;
                locationView.frame = frame;
                UITapGestureRecognizer *tapgr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(locationTapped)];
                [locationView addGestureRecognizer:tapgr];
                [cell.contentView addSubview:locationView];
                [cell.contentView addSubview:self.locationLabel];
            }
            break;
        case 1:
            if ([indexPath row] == 0) {
                cell.textLabel.text = @"Make this photo private:";
                [cell.contentView addSubview:self.privacySwitch];
            } else if ([indexPath row] == 1) {
                cell.textLabel.text = @"Make this photo anonymous:";
                [cell.contentView addSubview:self.anonymousSwitch];
            } else if ([indexPath row] == 2) {
                cell.textLabel.text = @"Share this moment to twitter";
                [cell.contentView addSubview:self.twitterSwitch];
            }
            break;
        default:
            break;
    }
    return cell;}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (indexPath.section == 0 && indexPath.row == 2) {
        [self locationTapped];
    }
}

#pragma mark - CLLocationManagerDelegate Methods

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    if ([newLocation.timestamp timeIntervalSinceNow] < 5) {
        self.currentLocation = newLocation;
        [self.locationManager stopUpdatingLocation];
        self.geocoder = [[CLGeocoder alloc] init];
        [self.geocoder reverseGeocodeLocation:self.currentLocation completionHandler:^(NSArray *placemarks, NSError *error) {
            CLPlacemark *placemark = [placemarks lastObject];
            NSString *city = placemark.locality;
            NSString *state = placemark.administrativeArea;
            NSString *combined = @"";
            if (city) {
                combined = [combined stringByAppendingString:city];
                if (state) {
                    combined = [combined stringByAppendingFormat:@", %@", state];
                }
            } else if (state) {
                combined = state;
            }
            if (combined.length > 0) {
                self.locationString = combined;
                self.locationLabel.text = self.locationString;
            }
            self.weatherFetcher = [[GoogleWeatherFetcher alloc] initWithLocation:self.currentLocation];
            [self.weatherFetcher setDelegate:self];
            [self.weatherFetcher start];
        }];
    }
}

#pragma mark - GoogleWeatherFetcher Delegate Methods

- (void)googleWeatherFetcher:(GoogleWeatherFetcher *)fetcher didFetchWeatherData:(NSDictionary *)weatherData
{
    self.weatherTemperature = [weatherData objectForKey:kTemperatureKey];
    self.weatherCondition = [weatherData objectForKey:kConditionsKey];
}

- (void)googleWeatherFetcher:(GoogleWeatherFetcher *)fetcher didFailWithError:(NSError *)error
{
    
}

#pragma mark - UITextFieldDelegate Methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

@end
