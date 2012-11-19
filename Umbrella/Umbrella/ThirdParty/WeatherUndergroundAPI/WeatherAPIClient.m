//
//  LWAPIClient.m
//  Local Weather
//
//  Created by Jonathan Rexeisen on 7/23/12.
//  Copyright (c) 2012 The Nerdery. All rights reserved.
//

#import "WeatherAPIClient.h"

@interface WeatherAPIClient ()

- (void)getForcastForLocationString:(NSString *)locationString withCompletionBlock:(WeatherAPICompletionBlock)completionBlock;
- (NSError *)genericError;
- (NSError *)missingAPIKeyError;

@end

// Base URL
NSString * const kWeatherAPIBaseURLString = @"http://api.wunderground.com/";
NSString * const kWeatherAPIConditionsPath = @"/conditions/hourly";

// Custom error domain and codes
NSString * const kWeatherAPIClientErrorDomain = @"com.nerdery.weather";
NSInteger const kWeatherAPIClientErrorCodeGeneric = 1000;
NSInteger const kWeatherAPIClientErrorCodeNoAPIKey = 1001;

@implementation WeatherAPIClient

#pragma mark - Singleton creation

+ (WeatherAPIClient *)sharedClient
{
    static WeatherAPIClient *_sharedClient = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _sharedClient = [[self alloc] initWithBaseURL:[NSURL URLWithString:kWeatherAPIBaseURLString]];
    });
    
    return _sharedClient;
}

- (id)initWithBaseURL:(NSURL *)url
{
    self = [super initWithBaseURL:url];
    if (!self) {
        return nil;
    }
    
    // Set the default request class
    [self registerHTTPOperationClass:[AFJSONRequestOperation class]];
    
    // Set the default Accept HTTP Header; see http://www.w3.org/Protocols/rfc2616/rfc2616-sec14.html#sec14.1
    [self setDefaultHeader:@"Accept" value:@"application/json"];
    
    //    // Listen for the app coming back from the background
    //    [[NSNotificationCenter defaultCenter] addObserver:self
    //                                             selector:@selector(applicationWillEnterForegroundNotificationRecieved:)
    //                                                 name:UIApplicationWillEnterForegroundNotification
    //                                               object:[UIApplication sharedApplication]];
    
    return self;
}

#pragma mark - API calls

- (void)getForcastAndConditionsForZipCode:(NSString *)zipCode withCompletionBlock:(WeatherAPICompletionBlock)completionBlock
{
    [self getForcastForLocationString:zipCode withCompletionBlock:completionBlock];
}

- (void)getForcastAndConditionsForLocation:(CLLocation *)location withCompletionBlock:(WeatherAPICompletionBlock)completionBlock
{
    NSString *locationString = [NSString stringWithFormat:@"%f,%f", location.coordinate.latitude, location.coordinate.longitude];
    [self getForcastForLocationString:locationString withCompletionBlock:completionBlock];
}

- (void)getForcastForLocationString:(NSString *)locationString withCompletionBlock:(WeatherAPICompletionBlock)completionBlock
{
    if (!self.APIKey) {
        NSAssert(NO, @"API Key not set");
        completionBlock(NO, nil, [self missingAPIKeyError]);
        return;
    }
    
    if (![NSThread isMainThread]) {
        NSAssert(NO, @"API client method must be called on the main thread");
        completionBlock(NO, nil, [self genericError]);
        return;
    }
    
    // Create the path
    NSString *pathString = [NSString stringWithFormat:@"/api/%@%@/q/%@.json", self.APIKey, kWeatherAPIConditionsPath, locationString];
    
    // To avoid a retain cycle
    __weak WeatherAPIClient *weakSelf = self;
    
    // Start the request
    [self getPath:pathString
       parameters:nil
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              // Check the responseObject
              if (!responseObject || ![responseObject isKindOfClass:[NSDictionary class]] || [responseObject count] == 0) {
                  DLog(@"Invalid responseObject: %@", responseObject);
                  completionBlock(NO, nil, [self genericError]);
                  return;
              }
              
              completionBlock(YES, responseObject, nil);
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              NSLog(@"Error with getForcastForLocation response: %@", error);
              completionBlock(NO, nil, [weakSelf genericError]);
          }
     ];
    
    return;
}

#pragma mark - Errors

- (NSError *)genericError
{
    NSString *localizedParsingErrorDescription = NSLocalizedString(@"There was an error communicating with the Weather Underground server. Please check your internet connection and try again later.", @"Generic failure error message");
    return [NSError errorWithDomain:kWeatherAPIClientErrorDomain
                               code:kWeatherAPIClientErrorCodeGeneric
                           userInfo:[NSDictionary dictionaryWithObject:localizedParsingErrorDescription forKey:NSLocalizedDescriptionKey]];
}
                        
- (NSError *)missingAPIKeyError
{
    NSString *localizedParsingErrorDescription = NSLocalizedString(@"Please enter a Weather Underground API Key.", @"Please enter a Weather Underground API Key error message");
    return [NSError errorWithDomain:kWeatherAPIClientErrorDomain
                               code:kWeatherAPIClientErrorCodeNoAPIKey
                           userInfo:[NSDictionary dictionaryWithObject:localizedParsingErrorDescription forKey:NSLocalizedDescriptionKey]];
}

@end
