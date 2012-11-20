//
//  UMBFlipsideViewController.m
//  Umbrella
//
//  Created by Ben Dolmar on 9/12/12.
//  Copyright (c) 2012 Ben Dolmar. All rights reserved.
//

#import "UMBFlipsideViewController.h"
#import "UMBAppDelegate.h"

@interface UMBFlipsideViewController () <UITextFieldDelegate>

/*!
 @method postalCode
 @abstract Holds the postal code of the location the user is trying to view the weather data of
 */
@property (strong, nonatomic) IBOutlet UITextField* postalCode;

/*!
 @method fahrenheitButton
 @abstract Display the data in fahrenheit.
 */
@property (strong, nonatomic) IBOutlet UIButton* fahrenheitButton;

/*!
 @method fahrenheitCheckmark
 @abstract Display the data in fahrenheit.
 */
@property (strong, nonatomic) IBOutlet UIButton* fahrenheitCheckmark;

/*!
 @method centigradeButton
 @abstract Display the data in centigrade.
 */
@property (strong, nonatomic) IBOutlet UIButton* centigradeButton;

/*!
 @method centigradeCheckmark
 @abstract Display the data in centigrade.
 */
@property (strong, nonatomic) IBOutlet UIButton* centigradeCheckmark;

/*!
 @method showMeWeatherButton
 @abstract Switches back to the current conditions and hourly view.
 */
@property (strong, nonatomic) IBOutlet UIButton* showMeWeatherButton;

/*!
 @method pcAboveDashedImage
 @abstract Display the dashed lines above the 'Postal Code' text.
 */
@property (strong, nonatomic) IBOutlet UIImageView* pcAboveDashedImage;

/*!
 @method pcBelowDashedImage
 @abstract Display the dashed lines below the 'Postal Code' text.
 */
@property (strong, nonatomic) IBOutlet UIImageView* pcBelowDashedImage;

/*!
 @method tsAboveDashedImage
 @abstract Display the above dashed lines near the 'Temperature Scale' text.
 */
@property (strong, nonatomic) IBOutlet UIImageView* tsAboveDashedImage;

/*!
 @method tsMiddleDashedImage
 @abstract Display the middle dashed lines near the 'Temperature Scale' text.
 */
@property (strong, nonatomic) IBOutlet UIImageView* tsMiddeDashedImage;

/*!
 @method tsBelowDashedImage
 @abstract Display the below lines near the 'Temperature Scale' text.
 */
@property (strong, nonatomic) IBOutlet UIImageView* tsBelowDashedImage;

/*!
 @method showingWeatherInF
 @abstract Local variable to store if the weather is being shown in F or C.
 */
@property (assign, nonatomic) BOOL showingWeatherInF;

/*!
 @method previousCode
 @abstract Store the postal code previously seen by the user.
 */
@property (copy, nonatomic) NSString* previousCode;

/*!
 @method setUnits:
 @abstract Saves the Perference for the units.
 @param sender any of the buttons responsible for setting the units
 */

- (IBAction) setUnits:(id)sender;

@end

@implementation UMBFlipsideViewController
@synthesize delegate = _delegate, postalCode = _postalCode, fahrenheitButton = _fahrenheitButton, fahrenheitCheckmark = _fahrenheitCheckmark, centigradeButton = _centigradeButton, centigradeCheckmark = _centigradeCheckmark, showMeWeatherButton = _showMeWeatherButton;
@synthesize pcAboveDashedImage = _pcAboveDashedImage, pcBelowDashedImage = _pcBelowDashedImage, tsAboveDashedImage = _tsAboveDashedImage, tsMiddeDashedImage = _tsMiddeDashedImage, tsBelowDashedImage = _tsBelowDashedImage, showingWeatherInF = _showingWeatherInF;

- (void)viewDidLoad
{    
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    //Set the delegate of the textfield to self
    self.postalCode.delegate = self;
    
    //set the text color of the text field
    [self.postalCode setTextColor:[UIColor colorWithRed:52/255.0 green:52/255.0 blue:52/255.0 alpha:1.0]];
    
    //Set the image for the 5 dashed images
    UIColor* color = [UIColor colorWithPatternImage:[UIImage imageNamed:@"dashed_line_pattern"]];
    [self.pcAboveDashedImage setBackgroundColor:color];
    [self.pcBelowDashedImage setBackgroundColor:color];
    [self.tsAboveDashedImage setBackgroundColor:color];
    [self.tsMiddeDashedImage setBackgroundColor:color];
    [self.tsBelowDashedImage setBackgroundColor:color];
    
    //Set the text color of the F/C buttons
    [self.fahrenheitButton setTitleColor:[UIColor colorWithRed:52/255.0 green:52/255.0 blue:52/255.0 alpha:1.0] forState:UIControlStateNormal];
    [self.centigradeButton setTitleColor:[UIColor colorWithRed:52/255.0 green:52/255.0 blue:52/255.0 alpha:1.0] forState:UIControlStateNormal];
    
    //Retrive the saved preference
    if([[NSUserDefaults standardUserDefaults] objectForKey:defaultTempUnitsIsF] != nil) {
        self.showingWeatherInF = [[NSUserDefaults standardUserDefaults] boolForKey:defaultTempUnitsIsF];
        
        if(self.showingWeatherInF) {
            [self.centigradeCheckmark setBackgroundImage:[UIImage imageNamed:@"checkmark_off"] forState:UIControlStateNormal];
            [self.fahrenheitCheckmark setBackgroundImage:[UIImage imageNamed:@"checkmark_on"] forState:UIControlStateNormal];
        } else {
            [self.centigradeCheckmark setBackgroundImage:[UIImage imageNamed:@"checkmark_on"] forState:UIControlStateNormal];
            [self.fahrenheitCheckmark setBackgroundImage:[UIImage imageNamed:@"checkmark_off"] forState:UIControlStateNormal];
        }
    } else {
        //if not present, then set the default to F
        self.showingWeatherInF = YES;
        [self.fahrenheitCheckmark setBackgroundImage:[UIImage imageNamed:@"checkmark_on"] forState:UIControlStateNormal];
        [self.centigradeCheckmark setBackgroundImage:[UIImage imageNamed:@"checkmark_off"] forState:UIControlStateNormal];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:defaultTempUnitsIsF];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    //Set the background of the 'Show Me The Weather' button
    UIImage* image = [[UIImage imageNamed:@"button_background"] resizableImageWithCapInsets:UIEdgeInsetsMake(0.0, 10.0, 0.0, 10.0)];
    [self.showMeWeatherButton setBackgroundImage:image forState:UIControlStateNormal];    
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    //Set the text of the postal Code textfield
    if([[NSUserDefaults standardUserDefaults] stringForKey:savedPostalCode]) {
        [self.postalCode setText:[[NSUserDefaults standardUserDefaults] stringForKey:savedPostalCode]];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
    self.delegate = nil;
    self.postalCode = nil;
    self.fahrenheitButton = nil;
    self.fahrenheitCheckmark = nil;
    self.centigradeButton = nil;
    self.centigradeCheckmark = nil;
    self.showMeWeatherButton = nil;
    self.pcAboveDashedImage = nil;
    self.pcBelowDashedImage = nil;
    self.tsAboveDashedImage = nil;
    self.tsMiddeDashedImage = nil;
    self.tsBelowDashedImage = nil;
}

#pragma mark - UITextField delegate
- (BOOL) textFieldShouldReturn:(UITextField *)textField {
    [self.postalCode resignFirstResponder];
    return YES;
}

#pragma mark - Actions
- (IBAction)showWeather:(id)sender
{
    if(![self.previousCode isEqualToString:[self.postalCode text]]) {
        self.previousCode = [self.postalCode text];
        [[NSUserDefaults standardUserDefaults] setObject:self.previousCode forKey:savedPostalCode];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    [self.delegate flipsideViewControllerDidFinish:self];
}

- (IBAction) setUnits:(id)sender {
    UIButton* button = (UIButton *)sender;
    if(button == self.fahrenheitButton ||
       button == self.fahrenheitCheckmark) {
        self.showingWeatherInF = YES;
        [self.centigradeCheckmark setBackgroundImage:[UIImage imageNamed:@"checkmark_off"] forState:UIControlStateNormal];
        [self.fahrenheitCheckmark setBackgroundImage:[UIImage imageNamed:@"checkmark_on"] forState:UIControlStateNormal];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:defaultTempUnitsIsF];
        [[NSUserDefaults standardUserDefaults] synchronize];
    } else {
        self.showingWeatherInF = NO;
        [self.centigradeCheckmark setBackgroundImage:[UIImage imageNamed:@"checkmark_on"] forState:UIControlStateNormal];
        [self.fahrenheitCheckmark setBackgroundImage:[UIImage imageNamed:@"checkmark_off"] forState:UIControlStateNormal];
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:defaultTempUnitsIsF];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

@end
