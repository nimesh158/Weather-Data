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
#import "UMBHourlyCell.h"
#import "UMBImageDownloader.h"

@interface UMBMainViewController () <UITableViewDataSource, UITableViewDelegate>

/*!
 @method cityName
 @abstract Display the name of the city user is viewing.
 */
@property (strong, nonatomic) IBOutlet UILabel* cityName;

/*!
 @method temperature
 @abstract Display the current temperature (in F or C).
 */
@property (strong, nonatomic) IBOutlet UILabel* temperature;

/*!
 @method weatherText
 @abstract Display the current weather text.
 */
@property (strong, nonatomic) IBOutlet UILabel* weatherText;

/*!
 @method precipitation
 @abstract Display the current precipitation (in).
 */
@property (strong, nonatomic) IBOutlet UILabel* precipitation;

/*!
 @method humidity
 @abstract Display the current humidity (in %).
 */
@property (strong, nonatomic) IBOutlet UILabel* humidity;

/*!
 @method windSpeed
 @abstract Display the current windSpeed (in MPH).
 */
@property (strong, nonatomic) IBOutlet UILabel* windSpeed;

/*!
 @method hourly
 @abstract TableView that displays the hourly information.
 */
@property (strong, nonatomic) IBOutlet UITableView* hourly;

/*!
 @method hourlyData
 @abstract Holds the hourly data.
 */
@property (strong, nonatomic) NSArray* hourlyData;

/*!
 @method icons
 @abstract Holds all the hourly icons.
 */
@property (strong, nonatomic) NSMutableDictionary* icons;

/*!
 @method isWeatherDataLoaded
 @abstract Flag to determine if the weather data is loaded.
 */
@property (assign, nonatomic) BOOL isWeatherDataLoaded;

/*!
 @method updateViewForWeatherData:
 @abstract Updates the current and hourly views with the downloaded weather data.
 @param weatherData the dictionary of the retrieved weather data
 */
- (void) updateViewForWeatherData:(NSDictionary *)weatherData;

/*!
 @method updateCurrentConditionsForData:
 @abstract Updates the current conditions with the downloaded weather data.
 @param current the dictionary of the current weather data
 */
- (void) updateCurrentConditionsForData:(NSDictionary *)current;

/*!
 @method retriveIcon:forIndexPath
 @abstract Retrives the UIImage for the icon at the indexpath and stores it in the icons dictionary.
 @param iconLink url link to the icon
 @param indexPath indexpath of the cell for which the icon is to be downloaded
 */
- (void) retriveIcon:(NSString *)iconLink forIndexPath:(NSIndexPath *) indexPath;
@end

@implementation UMBMainViewController
@synthesize cityName = _cityName, temperature = _temperature, weatherText = _weatherText, precipitation = _precipitation, humidity = _humidity, windSpeed = _windSpeed, hourly = _hourly, hourlyData = _hourlyData, icons = _icons, isWeatherDataLoaded = _isWeatherDataLoaded;

#pragma mark - View Management
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    //initially the weather data is not downloaded
    self.isWeatherDataLoaded = NO;
    
    //initialize
    self.icons = [[NSMutableDictionary alloc] init];
    
    //Set the font size between 17-41 and have it adjust automatically
    self.weatherText.minimumFontSize = 17.0f;
    self.weatherText.adjustsFontSizeToFitWidth = YES;
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    NSString* postalCode;
    
    if(![[NSUserDefaults standardUserDefaults] stringForKey:savedPostalCode]) {
        //If there is no saved postal code, set the default to 16803
        postalCode = [NSString stringWithFormat:@"16803"];
        [[NSUserDefaults standardUserDefaults] setObject:postalCode forKey:savedPostalCode];
        [[NSUserDefaults standardUserDefaults] synchronize];
    } else {
        postalCode = [[NSUserDefaults standardUserDefaults] stringForKey:savedPostalCode];
    }
    
    //If there is no deafult value for F or C, set it to F
    if([[NSUserDefaults standardUserDefaults] objectForKey:defaultTempUnitsIsF] == nil) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:defaultTempUnitsIsF];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    //Make weather data call
    [[WeatherAPIClient sharedClient] setAPIKey:[NSString stringWithFormat:@"944814a88ee4e7fa"]];
    [[WeatherAPIClient sharedClient] getForcastAndConditionsForZipCode:postalCode
                                                   withCompletionBlock:^(BOOL success, NSDictionary* result, NSError* error) {
                                                       if(success) {
                                                           self.isWeatherDataLoaded = YES;
                                                           [self updateViewForWeatherData:result];
                                                       } else {
                                                           self.isWeatherDataLoaded = NO;
                                                       }
                                                   }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    self.cityName = nil;
    self.weatherText = nil;
    self.precipitation = nil;
    self.humidity = nil;
    self.windSpeed = nil;
    self.hourly = nil;
    self.hourlyData = nil;
    self.icons = nil;
}

#pragma mark - UpdateView for Weather Data
- (void) updateViewForWeatherData:(NSDictionary *)weatherData {
//    DLog(@"Weather data = %@", weatherData);
    
    //if the response is an error that the user did not enter a valid postal code,
    //display it
    if([[weatherData objectForKey:@"response"] objectForKey:@"error"]) {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:nil
                                                        message:[[[weatherData objectForKey:@"response"] objectForKey:@"error"] objectForKey:@"description"]
                                                       delegate:self
                                              cancelButtonTitle:@"ok"
                                              otherButtonTitles:nil];
        [alert show];
    } else {
        //set current conditions data
        [self updateCurrentConditionsForData:[weatherData objectForKey:@"current_observation"]];
        DLog(@"Hourly Conditions = %@", [weatherData objectForKey:@"hourly_forecast"]);
        //set hourly data
        self.hourlyData = [weatherData objectForKey:@"hourly_forecast"];
        [self.hourly reloadData];
    }
}

- (void) updateCurrentConditionsForData:(NSDictionary *)current {
//    DLog(@"Current Conditions = %@", current);
    
    //city name
    NSDictionary* display_location = [current objectForKey:@"display_location"];
    [self.cityName setText:[NSString stringWithFormat:@"%@, %@", [display_location objectForKey:@"city"], [display_location objectForKey:@"state_name"]]];
    
    //temperature
    if([[NSUserDefaults standardUserDefaults] boolForKey:defaultTempUnitsIsF])
        [self.temperature setText:[NSString stringWithFormat:@"%.1f\u00B0", [[current objectForKey:@"temp_f"] floatValue]]];
    else
        [self.temperature setText:[NSString stringWithFormat:@"%.1f\u00B0", [[current objectForKey:@"temp_c"] floatValue]]];
    
    //weather text
    [self.weatherText setText:[[current objectForKey:@"weather"] uppercaseString]];
    
    //Precipitation
    if([[current objectForKey:@"precip_today_in"] isEqualToString:@"-999.00"])
        [self.precipitation setText:[NSString stringWithFormat:@"%@ in", [current objectForKey:@"precip_1hr_in"]]];
    else
        [self.precipitation setText:[NSString stringWithFormat:@"%@ in", [current objectForKey:@"precip_today_in"]]];
    //Humidity
    [self.humidity setText:[current objectForKey:@"relative_humidity"]];
    
    //Wind Speed
    [self.windSpeed setText:[NSString stringWithFormat:@"%@ MPH", [current objectForKey:@"wind_mph"]]];
}

#pragma mark - Table view delegate and data source

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    
    if(!self.isWeatherDataLoaded)
        return 1;
    
    NSDictionary* hour = [self.hourlyData objectAtIndex:0];
    if([[[hour objectForKey:@"FCTTIME"] objectForKey:@"hour"] intValue] == 0)
        return 2;
    
    return 3;
}

- (int) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(self.hourlyData) {
        NSDictionary* hour = [self.hourlyData objectAtIndex:0];
        int firstHour = [[[hour objectForKey:@"FCTTIME"] objectForKey:@"hour"] intValue];
        
        int todayHours, tomorrowHours, dayAfterTomorrowHours;
        todayHours = 24 - firstHour;
        
        if(todayHours > 12)
            tomorrowHours = 24 - (todayHours - 12);
        else
            tomorrowHours = 24;
        
        if((todayHours + tomorrowHours) < 36)
            dayAfterTomorrowHours = 36 - (todayHours + tomorrowHours);
        
        if(section == 0)
           return todayHours;
        
        if(section == 1)
            return tomorrowHours;
        
        if(section == 2)
            return dayAfterTomorrowHours;
    }
    
    return 1;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 22;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIImageView* imageV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"section_header_background"]];
    [imageV setFrame:CGRectMake(0, 0, 320, 22)];
 
    UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(14, 0, 320, 22)];
    [label setFont:[UIFont fontWithName:@"Futura-CondensedMedium" size:17.0f]];
    [label setTextColor:[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1.0]];
    [label setBackgroundColor:[UIColor clearColor]];
    NSDictionary* hour;
    if(section == 0) {
        hour = [self.hourlyData objectAtIndex:0];
        [label setText:[[[hour objectForKey:@"FCTTIME"] objectForKey:@"weekday_name"] uppercaseString]];
    }
    
    if(section == 1) {
        int row = [tableView numberOfRowsInSection:0];
        hour = [self.hourlyData objectAtIndex:row];
        [label setText:[[[hour objectForKey:@"FCTTIME"] objectForKey:@"weekday_name"] uppercaseString]];
    }
    
    if(section == 2) {
        int row = [tableView numberOfRowsInSection:0] + [tableView numberOfRowsInSection:1];
        hour = [self.hourlyData objectAtIndex:row];
        [label setText:[[[hour objectForKey:@"FCTTIME"] objectForKey:@"weekday_name"] uppercaseString]];
    }
    
    [imageV addSubview:label];
    
    [imageV setBackgroundColor:[UIColor clearColor]];
    
    return imageV;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString* hourlyCell = @"hourlyCell";
    NSString* loadingCell = @"loadingCell";
    
    if(self.isWeatherDataLoaded) {
        UMBHourlyCell *cell = [tableView dequeueReusableCellWithIdentifier:hourlyCell];
        
        if (cell == nil) {
            cell = [[UMBHourlyCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:hourlyCell];
        }
        
        NSDictionary* hour;
        if(indexPath.section == 0) {
            hour = [self.hourlyData objectAtIndex:indexPath.row];
        } else if(indexPath.section == 1) {
            int row = [tableView numberOfRowsInSection:0] + indexPath.row;
            hour = [self.hourlyData objectAtIndex:row];
        } else if(indexPath.section == 2) {
            int row = [tableView numberOfRowsInSection:0] + [tableView numberOfRowsInSection:1] + indexPath.row;
            hour = [self.hourlyData objectAtIndex:row];
        }
        
        [cell.weatherText setText:[[hour objectForKey:@"condition"] uppercaseString]];
        
        if([[NSUserDefaults standardUserDefaults] boolForKey:defaultTempUnitsIsF])
            [cell.temperature setText:[NSString stringWithFormat:@"%@\u00B0", [[hour objectForKey:@"temp"] objectForKey:@"english"]]];
        else
            [cell.temperature setText:[NSString stringWithFormat:@"%@\u00B0", [[hour objectForKey:@"temp"] objectForKey:@"metric"]]];
        
        NSString* civil = [[hour objectForKey:@"FCTTIME"] objectForKey:@"civil"];
        NSArray* parts = [civil componentsSeparatedByString:@" "];
        
        [cell.time setText:[parts objectAtIndex:0]];
        [cell.meridian setText:[parts objectAtIndex:1]];
        
        UIColor* color = [UIColor colorWithPatternImage:[UIImage imageNamed:@"dashed_line_pattern"]];
        [cell.seperator setBackgroundColor:color];
        
        // Set the icon
        if(![self.icons objectForKey:indexPath]) {
            [cell.icon setImage:nil];
            //Retrive the icon, save it and display it
            [self retriveIcon:[hour objectForKey:@"icon_url"] forIndexPath:indexPath];
        } else {
            [cell.icon setImage:[self.icons objectForKey:indexPath]];
        }
        
        return cell;
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - Retrive Icon for Index path
- (void) retriveIcon:(NSString *)iconLink forIndexPath:(NSIndexPath *)indexPath {
    UMBImageDownloader* downloader = [[UMBImageDownloader alloc] init];
    [downloader downloadIcon:iconLink withCompletionBlock:^(BOOL success, UIImage* result, NSError* error) {
        if(success) {
            [self.icons setObject:result forKey:indexPath];
            [self.hourly reloadData];
        }
    }];
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
