//
//  UMBMainViewController.m
//  Umbrella
//
//  Created by Ben Dolmar on 9/12/12.
//  Copyright (c) 2012 Ben Dolmar. All rights reserved.
//

#import "UMBMainViewController.h"
#import "WeatherAPIClient.h"
#import "UMBAppDelegate.h"

@interface UMBMainViewController () <UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UILabel* cityName;
@property (strong, nonatomic) IBOutlet UILabel* temperature;
@property (strong, nonatomic) IBOutlet UILabel* weatherText;
@property (strong, nonatomic) IBOutlet UILabel* precipitation;
@property (strong, nonatomic) IBOutlet UILabel* humidity;
@property (strong, nonatomic) IBOutlet UILabel* windSpeed;
@property (strong, nonatomic) IBOutlet UITableView* hourlyData;
@property (assign, nonatomic) BOOL isWeatherDataLoaded;

- (void) updateViewForWeatherData:(NSDictionary *)weatherData;
- (void) updateCurrentConditionsForData:(NSDictionary *)current;
@end

@implementation UMBMainViewController
@synthesize cityName, temperature, weatherText, precipitation, humidity, windSpeed, hourlyData, isWeatherDataLoaded;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.isWeatherDataLoaded = NO;
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    //Make weather data call
    if([[NSUserDefaults standardUserDefaults] stringForKey:savedPostalCode]) {
        [[WeatherAPIClient sharedClient] setAPIKey:[NSString stringWithFormat:@"944814a88ee4e7fa"]];
        [[WeatherAPIClient sharedClient] getForcastAndConditionsForZipCode:[[NSUserDefaults standardUserDefaults] stringForKey:savedPostalCode] withCompletionBlock:^(BOOL success, NSDictionary* result, NSError* error) {
            if(success) {
                self.isWeatherDataLoaded = YES;
                [self updateViewForWeatherData:result];
            } else {
                self.isWeatherDataLoaded = NO;
            }
        }];
    } else {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:nil
                                                        message:@"Please enter a postal code in settings"
                                                       delegate:self
                                              cancelButtonTitle:@"ok"
                                              otherButtonTitles:nil];
        [alert show];
        self.isWeatherDataLoaded = NO;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UpdateView for Weather Data
- (void) updateViewForWeatherData:(NSDictionary *)weatherData {
//    DLog(@"Weather data = %@", weatherData);
    
    if([[weatherData objectForKey:@"response"] objectForKey:@"error"]) {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:nil
                                                        message:[[[weatherData objectForKey:@"response"] objectForKey:@"error"] objectForKey:@"description"]
                                                       delegate:self
                                              cancelButtonTitle:@"ok"
                                              otherButtonTitles:nil];
        [alert show];
    } else {
        [self updateCurrentConditionsForData:[weatherData objectForKey:@"current_observation"]];
    }
}

- (void) updateCurrentConditionsForData:(NSDictionary *)current {
    DLog(@"Current Conditions = %@", current);
    
    //city name
    NSDictionary* display_location = [current objectForKey:@"display_location"];
    [self.cityName setText:[NSString stringWithFormat:@"%@, %@", [display_location objectForKey:@"city"], [display_location objectForKey:@"state_name"]]];
    
    //temperature
    if([[NSUserDefaults standardUserDefaults] boolForKey:defaultTempUnitsIsF])
        [self.temperature setText:[NSString stringWithFormat:@"%@\u00B0", [current objectForKey:@"temp_f"]]];
    else
        [self.temperature setText:[NSString stringWithFormat:@"%@\u00B0", [current objectForKey:@"temp_c"]]];
    
    //weather text
    [self.weatherText setText:[current objectForKey:@"weather"]];
    
    //Precipitation
    [self.precipitation setText:[NSString stringWithFormat:@"%@ in", [current objectForKey:@"precip_1hr_in"]]];
    
    //Humidity
    [self.humidity setText:[current objectForKey:@"relative_humidity"]];
    
    //Wind Speed
    [self.windSpeed setText:[NSString stringWithFormat:@"%@ MPH", [current objectForKey:@"wind_mph"]]];
}

#pragma mark - Table view delegate and data source

- (int) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString* hourlyCell = @"hourlyCell";
    NSString* loadingCell = @"loadingCell";
    
    if(self.isWeatherDataLoaded) {
        
    } else {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:loadingCell];
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:loadingCell];
            
            UIImageView *background = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"table_cell_bg"]];
            cell.backgroundView = background;
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
            [spinner setFrame:CGRectMake(105, 24, spinner.frame.size.width, spinner.frame.size.height)];
            [spinner startAnimating];
            
            UILabel *loading = [[UILabel alloc] initWithFrame:CGRectMake(135, 10, 100, 50)];
            loading.backgroundColor = [UIColor clearColor];
            loading.font = [UIFont boldSystemFontOfSize:18.0];
            loading.shadowColor = [UIColor blackColor];
            loading.shadowOffset = CGSizeMake(1, 1);
            loading.textColor = [UIColor whiteColor];
            loading.text = NSLocalizedString(@"Loading...", @"Prompt: Loading with elipses");
            
            [cell.contentView addSubview:spinner];
            [cell.contentView addSubview:loading];
        }
        
        return cell;
    }
    
    return nil;
}

#pragma mark - Flipside View

- (void)flipsideViewControllerDidFinish:(UMBFlipsideViewController *)controller
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showAlternate"]) {
        [[segue destinationViewController] setDelegate:self];
    }
}

@end
