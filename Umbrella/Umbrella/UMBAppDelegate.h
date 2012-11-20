//
//  UMBAppDelegate.h
//  Umbrella
//
//  Created by Ben Dolmar on 9/12/12.
//  Copyright (c) 2012 Ben Dolmar. All rights reserved.
//

#import <UIKit/UIKit.h>

//Strings to save in user preferences
static NSString* const defaultTempUnitsIsF = @"defaultTemperatureUnitsIsF";
static NSString* const savedPostalCode = @"savedPostalCode";

@interface UMBAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@end
