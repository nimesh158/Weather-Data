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

@property (strong, nonatomic) IBOutlet UITextField* postalCode;
@property (strong, nonatomic) IBOutlet UIButton* fahrenheitButton;
@property (strong, nonatomic) IBOutlet UIButton* fahrenheitCheckmark;
@property (strong, nonatomic) IBOutlet UIButton* centigradeButton;
@property (strong, nonatomic) IBOutlet UIButton* centigradeCheckmark;
@property (strong, nonatomic) IBOutlet UIButton* showMeWeatherButton;
@property (strong, nonatomic) IBOutlet UIImageView* pcAboveDashedImage;
@property (strong, nonatomic) IBOutlet UIImageView* pcBelowDashedImage;
@property (strong, nonatomic) IBOutlet UIImageView* tsAboveDashedImage;
@property (strong, nonatomic) IBOutlet UIImageView* tsMiddeDashedImage;
@property (strong, nonatomic) IBOutlet UIImageView* tsBelowDashedImage;
@property (assign, nonatomic) BOOL showingWeatherInF;
@property (copy, nonatomic) NSString* previousCode;

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
    
    //Retrive the saved preference, if not present, then set the default to F
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
        self.showingWeatherInF = YES;
        [self.fahrenheitCheckmark setBackgroundImage:[UIImage imageNamed:@"checkmark_on"] forState:UIControlStateNormal];
        [self.centigradeCheckmark setBackgroundImage:[UIImage imageNamed:@"checkmark_off"] forState:UIControlStateNormal];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:defaultTempUnitsIsF];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    //Set the background of the 'Show Me The Weather' button
    UIImage* image = [[UIImage imageNamed:@"button_background"] resizableImageWithCapInsets:UIEdgeInsetsMake(0.0, 10.0, 0.0, 10.0)];
    [self.showMeWeatherButton setBackgroundImage:image forState:UIControlStateNormal];
    
    //Initially set the previous code to 00000 if not in defaults, or get the value from defaults
    if([[NSUserDefaults standardUserDefaults] stringForKey:savedPostalCode]) {
        self.previousCode = [[NSUserDefaults standardUserDefaults] stringForKey:savedPostalCode];
    } else {
        self.previousCode = [NSString stringWithFormat:@"00000"];
    }
    
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if([[NSUserDefaults standardUserDefaults] stringForKey:savedPostalCode]) {
        [self.postalCode setText:[[NSUserDefaults standardUserDefaults] stringForKey:savedPostalCode]];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
