//
//  BlogCell.m
//  byoblu
//
//  Created by Andrea Barbon on 11/01/12.
//  Copyright (c) 2012 Università degli studi di Padova. All rights reserved.
//

#import "BlogCell.h"

@implementation BlogCell

@synthesize title, date, img;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
