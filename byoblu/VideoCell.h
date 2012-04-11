//
//  VideoCell.h
//  byoblu
//
//  Created by Andrea Barbon on 13/01/12.
//  Copyright (c) 2012 Università degli studi di Padova. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VideoCell : UITableViewCell {
    
    IBOutlet UIImageView *thumb;
    IBOutlet UITextView *title;
    IBOutlet UILabel *viewCount;
    IBOutlet UILabel *date;
    IBOutlet UILabel *duration;
}


@property(nonatomic,retain) IBOutlet UIWebView *video;
@property(nonatomic,retain) IBOutlet IBOutlet UIImageView *thumb;
@property(nonatomic,retain) IBOutlet UITextView *title;
@property(nonatomic,retain) IBOutlet UILabel *viewCount;
@property(nonatomic,retain) IBOutlet UILabel *date;
@property(nonatomic,retain) IBOutlet UILabel *duration;


- (UIButton *)findButtonInView:(UIView *)view;

@end
