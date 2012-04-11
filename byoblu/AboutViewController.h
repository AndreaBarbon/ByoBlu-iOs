//
//  AboutViewController.h
//  byoblu
//
//  Created by Andrea Barbon on 03/02/12.
//  Copyright (c) 2012 Università degli studi di Padova. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

#define RETRY_TIMES 3

@interface AboutViewController : UIViewController <UIWebViewDelegate> {
    
    UIDeviceOrientation prev;
    UIWebView *webView;
    NSString *HTMLContent;
    int retry;
    float w;
    bool loading;
}

- (void)adjustSize;

@end
