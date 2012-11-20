//
//  UMBHourlyCell.h
//  Umbrella
//
//  Created by Nimesh Desai on 11/19/12.
//  Copyright (c) 2012 Nimesh Desai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UMBHourlyCell : UITableViewCell

/*!
 @method icon
 @abstract Dispalys the icon corresponding to the weather text
 */
@property (strong, nonatomic) IBOutlet UIImageView* icon;

/*!
 @method weatherText
 @abstract Displays the weather text
 */
@property (strong, nonatomic) IBOutlet UILabel* weatherText;

/*!
 @method temperature
 @abstract Displays the temperature
 */
@property (strong, nonatomic) IBOutlet UILabel* temperature;

/*!
 @method time
 @abstract Displays the hour (10:00, 11:00)
 */
@property (strong, nonatomic) IBOutlet UILabel* time;

/*!
 @method meridian
 @abstract Displays the meridian (AM or PM)
 */
@property (strong, nonatomic) IBOutlet UILabel* meridian;

/*!
 @method seperator
 @abstract Displays the dotted line seperator between two rows
 */
@property (strong, nonatomic) IBOutlet UIImageView* seperator;

@end
