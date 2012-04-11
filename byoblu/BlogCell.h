//
//  BlogCell.h
//  byoblu
//
//  Created by Andrea Barbon on 11/01/12.
//  Copyright (c) 2012 Università degli studi di Padova. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface BlogCell : UITableViewCell {
    
    IBOutlet UIImageView *img;
    IBOutlet UITextView *title;
    IBOutlet UILabel *date;

}

@property(nonatomic,retain) IBOutlet UIImageView *img;
@property(nonatomic,retain) IBOutlet UITextView *title;
@property(nonatomic,retain) IBOutlet UILabel *date;



@end
