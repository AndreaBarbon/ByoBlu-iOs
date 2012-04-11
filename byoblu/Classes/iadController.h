//
//  iadController.h
//  byoblu
//
//  Created by Andrea Barbon on 28/03/12.
//  Copyright (c) 2012 Università degli studi di Padova. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <iAd/iAd.h>

@interface iadController : UIViewController <ADBannerViewDelegate> {
    
    BOOL first;
    BOOL iadPresent;

}

@property(nonatomic,retain) ADBannerView *adBannerView;

- (void)createAdBannerView;
- (void)adjustBannerView;

@end
