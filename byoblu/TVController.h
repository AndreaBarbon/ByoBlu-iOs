//
//  TVController.h
//  byoblu
//
//  Created by Andrea Barbon on 29/03/12.
//  Copyright (c) 2012 Università degli studi di Padova. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TVController : UIViewController <UIWebViewDelegate> {
    
    UIWebView *webView;
    bool playing;
    bool android;
    UIButton *playpause;
    float centerWebView;
    UIView *playView;
    NSString *s;
}

@end
