//
//  WeatherAPIClient.h
//  Local Weather
//
//  Created by Jonathan Rexeisen on 7/23/12.
//  Copyright (c) 2012 The Nerdery. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>
#import "AFNetworking.h"

/*!
 @typedef WeatherAPICompletionBlock
 @abstract A block that will be called when the API request is complete.
 @param success YES if the request was successful
 @param error An NSError that occurred, if there was one (will only be present if the request was not successful)
 */
typedef void (^WeatherAPICompletionBlock)(BOOL success, NSDictionary *result, NSError *error);

// Custom error domain & codes
extern NSString * const kWeatherAPIClientErrorDomain;
extern NSInteger const kWeatherAPIClientErrorCodeGeneric;
extern NSInteger const kWeatherAPIClientErrorCodeNoAPIKey;

@interface WeatherAPIClient : AFHTTPClient

@property (nonatomic, strong) NSString *APIKey;

#pragma mark - Singleton

/*!
 @method sharedClient
 @abstract Singleton for the WUnderground API.
 */
+ (WeatherAPIClient *)sharedClient;

#pragma mark - Fetchers

/*!
 @method getForcastAndConditionsForZipCode:withCompletionBlock:
 @abstract Gets the gets the forcast and conditions from the Weather Underground API and calls the completion block on success/failure. Must be called on main thread.
 @param zipCode the 5 digit zip code of the location to retrieve the weather
 @param completionBlock The completion block to be executed when the request has completed. The completion block will be called on the main thread.
 */
- (void)getForcastAndConditionsForZipCode:(NSString *)zipCode withCompletionBlock:(WeatherAPICompletionBlock)completionBlock;

/*!
 @method getForcastAndConditionsForZipCode:withCompletionBlock:
 @abstract Gets the forcast and conditions from the Weather Underground API and calls the completion block on success/failure. Must be called on main thread. Does nothing but return NO if there is already a request in progress. The completion block is not guaranteed to be called on the main thread.
 @param location The Core Location object of the location to retrieve the weather
 @param completionBlock The completion block to be executed when the request has completed. The completion block will be called on the main thread.
 */
- (void)getForcastAndConditionsForLocation:(CLLocation *)location withCompletionBlock:(WeatherAPICompletionBlock)completionBlock;

@end
