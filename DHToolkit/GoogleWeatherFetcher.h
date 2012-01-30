//
//  GoogleWeatherFetcher.h
//  Designing Happiness
//
//  Created by Tim Shi on 8/5/11.
//  Copyright 2011 www.timshi.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@class GoogleWeatherFetcher;

/**
 * Delegate protocol to receive weather data results asynchronously. Must be implemented
 * to receive the data. Data is returned as a dictionary with defined keys. 
 */

@protocol GoogleWeatherFetcherDelegate
- (void)googleWeatherFetcher:(GoogleWeatherFetcher *)fetcher didFetchWeatherData:(NSDictionary *)weatherData;
- (void)googleWeatherFetcher:(GoogleWeatherFetcher *)fetcher didFailWithError:(NSError *)error;
@end

#define kConditionsKey @"Conditions" /** The current weather conditions. */
#define kTemperatureKey @"Temperature" /** The current temperature in degrees Farenheit. */
#define kLocationKey @"Location" /** String to describe the location of the weather data. */

/**
 * Class to receive weather data on a location using Google API.
 * This class is able to asychronously call the Google API to download weather
 * information about a particular location. Location must be passed in to be
 * properly initialized. Delegate methods must be implemented in order to receive
 * the downloaded data. 
 */

@interface GoogleWeatherFetcher : NSObject

/** Delegate to receive weather data, REQUIRED. */
@property (nonatomic, unsafe_unretained) id <GoogleWeatherFetcherDelegate> delegate; 
/** Designated initializer, initialCoordinate cannot be nil. */
- (id)initWithLocation:(CLLocation *)initialCoordinate; 
/** Called to start the search and download. */
- (void)start; 

- (void)cancel;

@end
