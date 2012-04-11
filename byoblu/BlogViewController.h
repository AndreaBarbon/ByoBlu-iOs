//
//  BlogViewController.h
//  byoblu
//
//  Created by Andrea Barbon on 08/01/12.
//  Copyright (c) 2012 Università degli studi di Padova. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

#import "iadControllerPullToRefresh.h"
#import "MWFeedParser.h"
#import "PostViewController.h"
#import "BlogCell.h"
#import "MBProgressHUD.h"
#import "NSString+HTML.h"



#define retryTimes 3
#define TIME_OUT 6


@interface BlogViewController : iadControllerPullToRefresh <MWFeedParserDelegate> {
    
    bool            loading;
    NSMutableArray  *dataArray;
    NSMutableArray  *images;
    NSMutableData   *data;
    int             loadedImages;
    int             retry;
    NSDateFormatter *df;
    UIActivityIndicatorView *indicator;
    UIView *loadingWindow;
    
}




@property (nonatomic, retain) MWFeedParser *feedParser;
@property (nonatomic, retain) NSMutableArray *listaElementi;


- (NSURL *)imgFromSummary:(NSString *)s;
- (void)loadAnother;
- (void)parseFeed;
- (void)skipImage;

@end
