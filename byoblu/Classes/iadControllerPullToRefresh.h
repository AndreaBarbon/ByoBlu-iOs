//
//  iadControllerPullToRefresh.h
//  byoblu
//
//  Created by Andrea Barbon on 28/03/12.
//  Copyright (c) 2012 Università degli studi di Padova. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <iAd/iAd.h>
#import "PullRefreshTableViewController.h"

@interface iadControllerPullToRefresh : PullRefreshTableViewController <ADBannerViewDelegate> {
    
    
    BOOL iadPresent;
    BOOL up;
    CGRect contentViewFrame;
    
}

@property(nonatomic,retain) ADBannerView *adBannerView;

- (void)createAdBannerView;

@end
