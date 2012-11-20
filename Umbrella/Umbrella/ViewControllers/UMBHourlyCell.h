//
//  UMBHourlyCell.h
//  Umbrella
//
//  Created by Nimesh Desai on 11/19/12.
//  Copyright (c) 2012 Nimesh Desai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UMBHourlyCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView* icon;
@property (strong, nonatomic) IBOutlet UILabel* weatherText;
@property (strong, nonatomic) IBOutlet UILabel* temperature;
@property (strong, nonatomic) IBOutlet UILabel* time;
@property (strong, nonatomic) IBOutlet UILabel* meridian;
@property (strong, nonatomic) IBOutlet UIImageView* seperator;

@end
