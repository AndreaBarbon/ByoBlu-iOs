//
//  VideoViewController.h
//  byoblu
//
//  Created by Andrea Barbon on 10/01/12.
//  Copyright (c) 2012 Università degli studi di Padova. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

#import "GData.h"
#import "GDataXMLNode.h"

#import "TouchXML.h"
#import "VideoCell.h"
#import "BlogCell.h"
#import "loadingCell.h"
#import "MBProgressHUD.h"
#import "MWFeedParser.h"
#import "YoutubeViewController.h"
#import "AddThis.h"


#import "CJSONDeserializer.h"

#import "iadControllerPullToRefresh.h"


#define retryTimes 3


@interface VideoViewController : iadControllerPullToRefresh <UIPickerViewDelegate, UIPickerViewDataSource, MWFeedParserDelegate> {

    NSMutableData   *data; //keep reference to the data so we can collect it as it downloads
    NSMutableArray  *videos;	
    NSMutableArray  *images;
    NSMutableArray  *players;	
    UIPickerView    *picker;
    UIBarButtonItem *ShowingBtn;
    UIBarButtonItem *OKBtn;
    
    NSURLConnection *connectionXML;
    NSURLConnection *connectionImages;
    
    NSDictionary    *dictionary;
    
    NSDateFormatter *df;
    NSDateFormatter *dfParse;
    
    NSString        *shareLink;
    
    int             loadedPlayers;
    int             loadedImages;
    int             retry;
    int             retryXML;
    CXMLNode        *infoNode;
    bool            loading;
    bool            loadingMoreVideos;
    bool            loadingImages;
    bool            noMoreVideos;
    int             videoW;
    int             videoH;
    int             startIndex;
}

@property (nonatomic, retain) NSMutableArray *items;

-(NSString*)trova:(NSString*)key numero:(int)n;


- (NSString *)find:(NSString *)s Number:(int)r;
- (NSString *)videoYouTube:(NSString *)url;
- (NSString *)thumbYouTube:(NSString*)url;
- (void)loadAnother;
- (void)loadAnotherImage;
- (void)parseFeed;
- (void)loadOneMoreSet;
- (void)skipImage;

@end



@interface VideoClip:NSDictionary {
    
    NSString *title;
    NSString *link;
    NSString *date;
    NSString *thumb;
    NSString *rating;
}

@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSString *link;
@property (nonatomic, retain) NSString *date;
@property (nonatomic, retain) NSString *thumb;
@property (nonatomic, retain) NSString *rating;


@end
