//
//  DonationsController.h
//  byoblu
//
//  Created by Andrea Barbon on 10/03/12.
//  Copyright (c) 2012 Università degli studi di Padova. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DonationsController : UIViewController <UIWebViewDelegate> {
    
    IBOutlet UIWebView *webView;
    IBOutlet UIButton *button;
    IBOutlet UIView *ButtonBG;
}


-(IBAction)payWithPayPal:(id)sender;
-(IBAction)payWithAppStore:(id)sender;


@end
