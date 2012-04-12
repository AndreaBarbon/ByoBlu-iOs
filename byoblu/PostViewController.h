//
//  PostViewController.h
//  byoblu
//
//  Created by Andrea Barbon on 08/01/12.
//  Copyright (c) 2012 Università degli studi di Padova. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddThis.h"
#import <iAd/iAd.h>

@interface PostViewController : UIViewController <UIWebViewDelegate, ADBannerViewDelegate> {

    IBOutlet UIWebView *webView;
    NSURL *url;
    UIBarButtonItem *btn;
    
    BOOL up;

}

@property (nonatomic, retain) NSString *HTMLContent;
@property (nonatomic, retain) NSURL *url;
@property(nonatomic,retain) ADBannerView *adBannerView;


-(void)adjustSize;
-(void)resizeFrame;

@end
