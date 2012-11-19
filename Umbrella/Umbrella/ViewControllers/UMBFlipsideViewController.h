//
//  UMBFlipsideViewController.h
//  Umbrella
//
//  Created by Ben Dolmar on 9/12/12.
//  Copyright (c) 2012 Ben Dolmar. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UMBFlipsideViewController;

@protocol UMBFlipsideViewControllerDelegate
- (void)flipsideViewControllerDidFinish:(UMBFlipsideViewController *)controller;
@end

@interface UMBFlipsideViewController : UIViewController

@property (weak, nonatomic) id <UMBFlipsideViewControllerDelegate> delegate;

- (IBAction)showWeather:(id)sender;

@end
