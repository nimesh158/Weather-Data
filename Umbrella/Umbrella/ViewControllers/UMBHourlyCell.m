//
//  UMBHourlyCell.m
//  Umbrella
//
//  Created by Nimesh Desai on 11/19/12.
//  Copyright (c) 2012 Nimesh Desai. All rights reserved.
//

#import "UMBHourlyCell.h"

@implementation UMBHourlyCell
@synthesize icon = _icon, weatherText = _weatherText, temperature = _temperature, time = _time, meridian = _meridian, seperator = _seperator;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
