//
//  VideoCell.m
//  byoblu
//
//  Created by Andrea Barbon on 13/01/12.
//  Copyright (c) 2012 Università degli studi di Padova. All rights reserved.
//

#import "VideoCell.h"

@implementation VideoCell

@synthesize video, title, thumb, viewCount, date, duration;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (UIButton *)findButtonInView:(UIView *)view {
	UIButton *button = nil;
    
	if ([view isMemberOfClass:[UIButton class]]) {
		return (UIButton *)view;
	}
    
	if (view.subviews && [view.subviews count] > 0) {
		for (UIView *subview in view.subviews) {
			button = [self findButtonInView:subview];
			if (button) return button;
		}
	}
    
	return button;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
        [super setSelected:FALSE animated:animated];
    
    // Configure the view for the selected state
}

@end
