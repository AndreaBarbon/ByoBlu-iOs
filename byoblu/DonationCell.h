//
//  DonationCell.h
//  byoblu
//
//  Created by Andrea Barbon on 03/02/12.
//  Copyright (c) 2012 Università degli studi di Padova. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DonationCell : UITableViewCell {
    
    IBOutlet UIActivityIndicatorView *indicator;
    
}
@property (nonatomic, retain) IBOutlet UILabel *label;

@end
