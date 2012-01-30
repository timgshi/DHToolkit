//
//  GoogleWeatherFetcher.m
//  Designing Happiness
//
//  Created by Tim Shi on 8/5/11.
//  Copyright 2011 www.timshi.com. All rights reserved.
//

#import "GoogleWeatherFetcher.h"

@interface GoogleWeatherFetcher() <NSURLConnectionDelegate, NSXMLParserDelegate>
@property (nonatomic, strong) CLLocation *location;
@property (nonatomic, strong) NSMutableDictionary *weatherDictionary;
@property (nonatomic, strong) CLGeocoder *geocoder;
@property (weak, readonly) MKPlacemark *currentPlacemark;
@property (nonatomic, strong) NSTimer *timeoutTimer;
@property BOOL canceled;
@end

@implementation GoogleWeatherFetcher

@synthesize delegate;
@synthesize location;
@synthesize weatherDictionary;
@synthesize geocoder;
@synthesize currentPlacemark;
@synthesize canceled;
@synthesize timeoutTimer;


- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (id)initWithLocation:(CLLocation *)initialCoordinate
{
    self = [self init];
    if (self) {
        self.location = initialCoordinate;
        weatherDictionary = nil;
    }
    return self;

}

- (void)finished
{
    [self.timeoutTimer invalidate];
    self.timeoutTimer = nil;
    NSString *locationString = [NSString stringWithFormat:@"%@, %@", currentPlacemark.locality, currentPlacemark.administrativeArea];
    [self.weatherDictionary setObject:locationString forKey:kLocationKey];
    for (NSString *key in [self.weatherDictionary allKeys]) {
        if ([self.weatherDictionary objectForKey:key] == nil) {
            NSError *error = [NSError errorWithDomain:@"Google" code:0 userInfo:[NSDictionary dictionaryWithObject:@"Could not process Google Weather info" forKey:NSLocalizedFailureReasonErrorKey]];
            if (!canceled) [self.delegate googleWeatherFetcher:self didFailWithError:error];
        }
    }
    if (!canceled) [self.delegate googleWeatherFetcher:self didFetchWeatherData:self.weatherDictionary];
}

- (void)getGoogleWeatherDataForPostalCode:(NSString *)postalCode
{
    NSURL *googleWeatherURL = [NSURL URLWithString:[NSString stringWithFormat:@"http://www.google.com/ig/api?weather=%@", postalCode]];
    NSXMLParser *parser = [[NSXMLParser alloc] initWithContentsOfURL:googleWeatherURL];
    [parser setDelegate:self];
    [parser parse];
}

- (void)start
{
    self.geocoder = [[CLGeocoder alloc] init];
    self.timeoutTimer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(timerFired) userInfo:nil repeats:NO];
    [self.geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
        if (!error) {
            currentPlacemark = [placemarks lastObject];
            NSString *postalCode = currentPlacemark.postalCode;
            dispatch_queue_t weatherQueue = dispatch_queue_create("com.timshi.WeatherFetcher", NULL);
            dispatch_async(weatherQueue, ^{
                if (!canceled) [self getGoogleWeatherDataForPostalCode:postalCode];
            });
            dispatch_release(weatherQueue);
        } else {
            if (!canceled) [self.delegate googleWeatherFetcher:self didFailWithError:error];
        }
    }];
}

- (void)cancel
{
    self.canceled = YES;
}

- (void)timerFired
{
    [self.delegate googleWeatherFetcher:self didFailWithError:[NSError errorWithDomain:@"WeatherFetcher" code:0 userInfo:[NSDictionary dictionaryWithObject:@"Timeout" forKey:NSLocalizedDescriptionKey]]];
    self.canceled = YES;
}

#pragma mark - MKReverseGeocoderDelegate Methods


#pragma mark - NSXMLParserDelegate Methods

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    if ([elementName isEqualToString:@"current_conditions"]) {
        self.weatherDictionary = [[NSMutableDictionary alloc] initWithObjectsAndKeys:nil, kConditionsKey, nil, kTemperatureKey, nil, kLocationKey, nil];
        return;
    }
    if ([elementName isEqualToString:@"condition"]) {
        if (self.weatherDictionary) {
            NSString *condition = [attributeDict objectForKey:@"data"];
            if (condition) {
                [self.weatherDictionary setObject:condition forKey:kConditionsKey];
            } else {
                [self.weatherDictionary setObject:[NSNull null] forKey:kConditionsKey];
            }
            
            return;
        }
    }
    if ([elementName isEqualToString:@"temp_f"]) {
        if (self.weatherDictionary) {
            NSString *temp = [attributeDict objectForKey:@"data"];
            [self.weatherDictionary setObject:temp forKey:kTemperatureKey];
            [parser abortParsing];
            [self finished];
            return;
        }
    }
}



@end
