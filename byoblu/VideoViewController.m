//
//  VideoViewController.m
//  byoblu
//
//  Created by Andrea Barbon on 10/01/12.
//  Copyright (c) 2012 Università degli studi di Padova. All rights reserved.
//

#import "VideoViewController.h"
#import "AppDelegate.h"

#define CHANNEL @"byoblu"

#define RHO_iPad 7
#define RHO 3

#define TIME_OUT 6

#define VIDEOS_NUMBER 200

#define videoWidth_iPad     260
#define videoHeight_iPad    160

#define videoWidth          130
#define videoHeight         80


@implementation VideoClip

@synthesize title, thumb, date, rating, link;

@end



@implementation VideoViewController

@synthesize items;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    //iAd
    if ([(AppDelegate*)[[UIApplication sharedApplication] delegate] advertisements]) {
        [self createAdBannerView];
        [self.parentViewController.view addSubview:self.adBannerView];
        iadPresent = 1;
    }
    
    
    //AddThis settings
    [AddThisSDK setFacebookAuthenticationMode:ATFacebookAuthenticationTypeDefault];
    [AddThisSDK setFacebookAPIKey:@"314536821917796"];
    [AddThisSDK setTwitterAuthenticationMode:ATTwitterAuthenticationTypeDefault];
    [AddThisSDK setTwitterConsumerKey:@"yourconsumerkey"];
    [AddThisSDK setTwitterConsumerSecret:@"yourconsumersecret"];
    [AddThisSDK setTwitterCallBackURL:@"yourcallbackurl"];
    
    [AddThisSDK setAddThisPubId:@"ra-4f18a553515566c5"];
    [AddThisSDK setAddThisApplicationId:@"4f18a59c45fb68ca"];
    
    
    

    self.view.backgroundColor = [UIColor clearColor];
    self.navigationController.navigationBar.backgroundColor = [UIColor blueColor];

    [MBProgressHUD showHUDAddedTo:self.view animated:TRUE];
    
    picker = [[UIPickerView alloc] init];
    picker.delegate = self;
    picker.dataSource = self;
    picker.frame = CGRectMake(10, 10, 250, 200);
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        
        videoH = videoHeight_iPad;
        videoW = videoWidth_iPad;
        
    }else{  
        videoH = videoHeight;
        videoW = videoWidth;
    }
    
    loading = 1;
    startIndex = 1;
    videos	= [[NSMutableArray alloc] init];	
    data = [[NSMutableData alloc] init];
    players	= [[NSMutableArray alloc] init];	
    images = [[NSMutableArray alloc] init];
    items = [[NSMutableArray alloc] init];
    loadedPlayers = 0;
    loadedImages = 0;
    
    df = [[NSDateFormatter alloc] init];            [df setDateFormat:@"d MMMM"];
    NSLocale *loc = [[NSLocale alloc] initWithLocaleIdentifier:@"it"];
    [df setLocale: loc];

    dfParse = [[NSDateFormatter alloc] init];       [dfParse setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.'000Z'"];

      
    //Create the Reload button    
    UIBarButtonItem *reloadButton = [[UIBarButtonItem alloc] 
                                   initWithTitle:@"Aggiorna"                                            
                                   style:UIBarButtonItemStyleBordered 
                                   target:self 
                                   action:@selector(reload)];

    reloadButton.image = [UIImage imageNamed:@"refresh_icon.png"];

    self.navigationItem.rightBarButtonItem = reloadButton;
    

    //Create the "Showing 1-25 of 20'000" button
    //    NSString *s = [NSString stringWithFormat:@"Showing videos %d-%d of %d", startIndex, startIndex+24, VIDEOS_NUMBER];    
//    ShowingBtn = [[UIBarButtonItem alloc] 
//                                   initWithTitle:s                                            
//                                   style:UIBarButtonItemStyleBordered 
//                                   target:self 
//                                   action:@selector(showPicker)];
    //self.navigationItem.leftBarButtonItem = ShowingBtn;
    
    //Create the OK button
//    OKBtn = [[UIBarButtonItem alloc] 
//                            initWithTitle:@"OK"                                            
//                            style:UIBarButtonItemStyleBordered 
//                            target:self 
//                            action:@selector(changeStartIndex)];
    
    
    
    [self parseFeed];
    
}



- (void)parseFeed {
    
    //NSString *path = [[NSString alloc] initWithFormat:@"http://gdata.youtube.com/feeds/base/users/%@/uploads?alt=rss&v=2&orderby=published&start-index=%d&client=ytapi-youtube-profile", CHANNEL, startIndex];
	
    
    NSString *path = [[NSString alloc] initWithFormat:@"https://gdata.youtube.com/feeds/api/users/%@/uploads?&start-index=%d", CHANNEL, startIndex];

    
	NSLog(@"Path: %@", path);
    NSURLRequest* request = [NSURLRequest requestWithURL:[NSURL URLWithString:path] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:TIME_OUT];
	connectionXML = [NSURLConnection connectionWithRequest:request delegate:self];
    
}

- (void)grabXML {
    
    noMoreVideos = 1;
	
    // Create a new rssParser object based on the TouchXML "CXMLDocument" class, this is the
    // object that actually grabs and processes the XML data
    CXMLDocument *doc = [[CXMLDocument alloc] initWithData:data options:0 error:nil];
    
    NSArray *entries = [doc.rootElement elementsForName:@"entry"];
    for (GDataXMLElement *e in entries) {
        
        NSMutableDictionary *video = [[NSMutableDictionary alloc] init];
        
        
        //[videos addObject:e];
        
        for (GDataXMLElement *tag in [e children]) {
                        
            //NSLog(@"%@ = %@", [tag name], [tag stringValue]);
            

            
            if ([[tag name] isEqualToString:@"yt:statistics"]) {
                
                if ([video objectForKey:@"viewCount"] == nil) {
                    [video setValue:[[tag attributeForName:@"viewCount"] stringValue] forKey:@"viewCount"];
                }
                
            } else if ([[tag name] isEqualToString:@"link"]){
                                   
                NSString *s = [[tag attributeForName:@"href"] stringValue];
                NSString *t = [[tag attributeForName:@"type"] stringValue];
                
                if ([video objectForKey:@"link"] == nil && [t isEqualToString:@"text/html"]) {
                    [video setValue:s forKey:@"link"];
                }
                
            } else if ([[tag name] isEqualToString:@"title"]) {
                
                [video setValue:[tag stringValue] forKey:[tag name]];
            
            } else if ([[tag name] isEqualToString:@"published"]) {
                
                NSString *s = [df stringFromDate:[dfParse dateFromString:[tag stringValue]]];
                [video setValue:s forKey:[tag name]];
                
            } else if ([[tag name] isEqualToString:@"gd:comments"]){   
                
            } else if ([[tag name] isEqualToString:@"media:group"]){
                                
                for (GDataXMLElement *subTag in [tag children]) {
                    if ([[subTag name] isEqualToString:@"yt:duration"]) {
                        if ([video objectForKey:@"duration"] == nil) {
                            [video setValue:[[subTag attributeForName:@"seconds"] stringValue] forKey:@"duration"];
                        }
                    } else 
                    if ([[subTag name] isEqualToString:@"media:thumbnail"]) {
                        if ([video objectForKey:@"thumb"] == nil) {
                            [video setValue:[[subTag attributeForName:@"url"] stringValue] forKey:@"thumb"];
                        }
                    }
                }
                                
            } else if ([[tag name] isEqualToString:@"gd:rating"]){
            }   
            
            //NSLog(@"TAG = %@", [tag name]);
        }

    
        //NSLog(@"Title = %@", [[[e elementsForName:@"title"] objectAtIndex:0] stringValue]);
        noMoreVideos = 0;
        [videos addObject:video];
    
    }
	
    
    /* 
    // Returns all 'level1_item' nodes in an array    
    NSArray *nodes = [[doc rootElement] nodesForXPath:@"//feed" error:nil];
    
	for (CXMLNode *itemNode in nodes)
	{				
        NSLog(@"entry");
        
        noMoreVideos = 0;
        [videos addObject:[itemNode copy]];
        
        if ([[itemNode name] isEqualToString:@"yt:statistics"]) {
            
            
            for (CXMLNode *eventNode in [itemNode children])
            {
                if ([[eventNode name] isEqualToString:@"entry"]) {
                    
                    noMoreVideos = 0;
                    [videos addObject:[eventNode copy]];
                    
                    if ([[eventNode name] isEqualToString:@"yt:statistics"]) {
                        NSLog(@"statistics");
                    }
                    
                    //NSString *title = [[[videos lastObject] nodeForXPath:@"title" error:nil] stringValue];
                    //NSLog(@"Title = %@", title);
                    //NSString *link = [[[videos lastObject] nodeForXPath:@"link" error:nil] stringValue];
                    //NSLog(@"Link = %@", link);
                    
                }
                
            }
        }
    }
    */
    
    if (noMoreVideos && retryXML < retryTimes) {
        NSLog(@"Retrying to read the XML");
        retryXML++;
        [self grabXML];
        return;
    }
    
    NSLog(@"Youtube XML grabbed");
    loading = 0;
    retryXML = 0;
    loadingMoreVideos = 0;
    if (!loadingImages) {
        [self performSelector:@selector(loadAnotherImage)];
    }
    //[self performSelector:@selector(loadAnother)];
    [self.tableView reloadData];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    NSLog(@"Will appear");
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    NSLog(@"Did appear");
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (loading) {
        
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;        
        return 0;
        
    } else {
        
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        [MBProgressHUD hideHUDForView:self.view animated:TRUE];
        if (!noMoreVideos) {
            return [videos count]+1;
        } else {
            return [videos count];
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int r = indexPath.row;
	static NSString *CellIdentifier = @"Video";
	VideoCell *cell = (VideoCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        
        NSString *nib;
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
            
            nib = @"VideoCell_iPad";
            
        }else{  
            nib = @"VideoCell";
        }
		NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:nib owner:self options:nil];
		cell = [topLevelObjects objectAtIndex:0];
        
        cell.title.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        cell.date.autoresizingMask = UIViewAutoresizingFlexibleWidth;

        if ([nib isEqualToString:@"VideoCell"])
            cell.thumb.layer.cornerRadius = RHO;
        else
            cell.thumb.layer.cornerRadius = RHO_iPad;
        cell.thumb.layer.masksToBounds = YES;

    }

    if (r==[videos count] && !loadingMoreVideos) {
        
        loadingCell *c = (loadingCell *)[tableView dequeueReusableCellWithIdentifier:@"loading"];
        
        if (c == nil) {
            NSString *nib;
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
                
                nib = @"loadingCell_iPad";
                
            }else{  
                nib = @"loadingCell";
            }
            NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:nib owner:self options:nil];
            c = [topLevelObjects objectAtIndex:0];
        }

        
        NSLog(@"Loading more videos");
        loadingMoreVideos = 1;
        [self loadOneMoreSet];
        return c;
    }
    
    cell.title.text = [self trova:@"title" numero:r];
    NSString *date = [self trova:@"published" numero:r];
    cell.date.text = date;
    cell.viewCount.text = [NSString stringWithFormat:@"Views: %d", [[self trova:@"viewCount" numero:r] intValue]];
    
    int sec = [[self trova:@"duration" numero:r] intValue];
    int min = ceil(sec/60);
    sec = sec%60;
    cell.duration.text = [NSString stringWithFormat:@"%d:%d min", min, sec];
    
    if ([images count] > r) {
        [cell.thumb setImage:[images objectAtIndex:r]];
    } else {
        [cell.thumb setImage:nil];
    }
        
    if ([players count] > r) {
        
        [cell.video removeFromSuperview];
        [cell addSubview:[players objectAtIndex:r]];
        cell.video = [players objectAtIndex:r];
        
    }
    
    return cell;
}

- (void)loadAnother {
    
    if (loadedPlayers < [videos count]) {
        
        //NSLog(@"Creating a new player");
        
        NSString *y = [self videoYouTube:[self find:@"link" Number:loadedPlayers]];
        UIWebView *w = [[UIWebView alloc] initWithFrame:CGRectMake(10, 10, videoW, videoH)];
        [w loadHTMLString:y baseURL:nil];
        w.scrollView.scrollEnabled = 0;        
        [players addObject:w];
        loadedPlayers += 1;

        [self loadAnother];
        
    } else {
        
        NSLog(@"Now showing the table");
        loading = 0;
        [self.tableView reloadData];

    }
    
}

- (void)loadAnotherImage {
    
    if (loadedImages < [videos count]) {
        
        NSString *s = [self trova:@"thumb" numero:loadedImages];//[self thumbYouTube:[self find:@"description" Number:loadedImages]];
        //NSLog(@"Loading image #%d, url = %@", loadedImages, s);
        NSURL *u = [NSURL URLWithString:s];
        NSURLRequest* request = [NSURLRequest requestWithURL:u cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:TIME_OUT];
        connectionImages = [NSURLConnection connectionWithRequest:request delegate:self];
        
    } else {
        loadingImages = 0;
    }
}

- (NSString *)find:(NSString *)s Number:(int)r {
    
    //NSLog(@"Finding %@ #%d", s, r);
    
    if ([videos count] > r) {
        return [[[videos objectAtIndex:r] nodeForXPath:s error:nil] stringValue];
    }
    
    return @"";
    
}

- (float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {return 180;} else{return 80;};
        

}

- (NSString *)thumbYouTube:(NSString*)url {
    
    //NSLog(@"url = %@", url);

    
    // Create your expression
    NSRegularExpression *regex = 
    
    [NSRegularExpression regularExpressionWithPattern:@"http://i.ytimg.com/vi/(.*?)\""
                                              options:NSRegularExpressionCaseInsensitive
                                                error:nil];
    
    // Replace the matches
    NSTextCheckingResult *match = [regex firstMatchInString:url options:0 range:NSMakeRange(0, [url length])];
    if (match) {
        NSRange  hashRange = [match rangeAtIndex:1];
        url = [url substringWithRange:hashRange];
    }
    
    url = [NSString stringWithFormat:@"http://i.ytimg.com/vi/%@", url];
    
    return url;
}

- (NSString *)videoYouTube:(NSString*)url {  
    
    /*
    // HTML to embed YouTube video
    NSString *youTubeVideoHTML = [NSString stringWithFormat:@"<html><head>\
                                  <body style=\"margin:0\">\
                                  <embed id=\"player\" src=\"%@\" type=\"application/x-shockwave-flash\" \
                                  width=\"%d\" height=\"%d\"></embed>\
                                  </body></html>",url, videoW, videoH]; 
    */
    
    NSString *s = [self thumbYouTube:[self find:@"description" Number:loadedPlayers]];
    NSString *l = [self find:@"link" Number:loadedPlayers];
    //NSLog(@"Logo = %@", s);

    NSString *html = [NSString stringWithFormat:@"<a href=\"%@\"><img src=\"%@\"></img></a>", l, s];
    
    
    //NSLog(@"HTML = %@", html);
    return html;
    
} 

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
 
    int r = indexPath.row;
    
    VideoCell *v = (VideoCell*)[self.tableView cellForRowAtIndexPath:indexPath];
    if (!v.selected) {
                
        if (up==1) {
            CGSize bannerSize = [ADBannerView sizeFromBannerContentSizeIdentifier:self.adBannerView.currentContentSizeIdentifier];
            contentViewFrame.size.height = contentViewFrame.size.height + bannerSize.height;
            up = 0;
            self.view.frame= contentViewFrame;
        }
        
        YoutubeViewController *controller = [[YoutubeViewController alloc] init];
        controller.view.frame = self.tableView.frame;
        UIWebView *web = [[UIWebView alloc] initWithFrame:controller.view.frame];
        NSString *s = [self trova:@"link" numero:r];
        
        shareLink = s;
        s = [s stringByAppendingFormat:@"%f", arc4random()];
        
        
        //NSLog(@"Link = %@", s);
        [web loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:s]]];
        web.backgroundColor = [UIColor clearColor];

        [controller.view addSubview:web];
        controller.title = [self trova:@"title" numero:r];
        controller.view.backgroundColor = [UIColor clearColor];
        
        //Add the share button
        UIBarButtonItem *btn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction
                                                                             target:self
                                                                             action:@selector(share:event:)];
        controller.navigationItem.rightBarButtonItem = btn;
        
        [self.adBannerView removeFromSuperview];
        iadPresent = 0;
        
        [self.navigationController pushViewController:controller animated:YES];
        
    }
}

#pragma mark -
#pragma mark Tools

- (void)share:(UIBarButtonItem*)sender event:(UIEvent*)event
{
    
    NSString *s = shareLink;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){

        CGRect rect = [[[event.allTouches anyObject] view] frame];
        rect = [self.parentViewController.view convertRect:rect toView:nil];
        [AddThisSDK presentAddThisMenuInPopoverForURL:s fromRect:rect withTitle:self.title description:self.title];
        
    }else{
        
        [AddThisSDK presentAddThisMenuForURL:s withTitle:self.title description:self.title];            
    }
    
    NSLog(@"Shared URL: %@", s);
    
}

-(NSString*)trova:(NSString*)key numero:(int)n {
	    
	if ([videos count]>n) {
		
        NSString *s = [[videos objectAtIndex:n] objectForKey:key];
        
        if (s != nil) {
            //NSLog(@"Returning: %@", s);
            return s;
        }
		
	}
    
    return @"?";
	
}

#pragma mark -
#pragma mark NSURLConnection delegate

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{  
	[data setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data_{ 
	[data appendData:data_];
	
}

- (void)connection:(NSURLConnection *)connection_ didFailWithError:(NSError *)error{
	
    //NSLog(@"Connection error: %@", [error debugDescription]);
    
    if (connection_ == connectionImages) {
        retry++;
        if ( retry < retryTimes ) {
            [self loadAnotherImage];
        } else {
            NSLog(@"Skipping image #%d, because of connnection error", loadedImages);
            [self skipImage];
            loadedImages++;
            retry = 0;
            [self loadAnotherImage];
        }
    } else if (connection_ == connectionXML) {

        //NSLog(@"Connection problems, trying again in 1 second");
        //[NSThread sleepForTimeInterval:1];
        [self parseFeed];
        
    }
}

- (void)skipImage {
    
    //NSLog(@"Skipping image #%d", loadedImages);
    UIImage *img = [[UIImage alloc] init];//[UIImage imageNamed:@"second"];
    [images addObject:img];
    
}

- (void)connectionDidFinishLoading:(NSURLConnection*)theConnection {
	
	//[NSThread detachNewThreadSelector:@selector(grabXML) toTarget:self withObject:nil];
    if (theConnection == connectionXML) {
        
        //NSLog(@"XML Connection finished");
        [self performSelector:@selector(grabXML)];
        
        //Stop the PullToRefresh
        [self stopLoading];
        
        loading = 0;
        retryXML = 0;
        loadingMoreVideos = 0;
        if (!loadingImages) {
            [self performSelector:@selector(loadAnotherImage)];
        }
        //[self performSelector:@selector(loadAnother)];
        [self.tableView reloadData];

        
    } else if(theConnection == connectionImages){
        
        UIImage *img = [UIImage imageWithData:data];
        if (img == nil) {
            NSLog(@"Skipping image #%d, because it's nil", loadedImages);
            [self skipImage];
        } else {
            //NSLog(@"Adding image #%d", loadedImages);
            [images addObject:img];
        }
        loadedImages += 1;
        [self loadAnotherImage];
        //NSLog(@"Loaded #%d", loadedImages);
        [self.tableView reloadData];

    }

}


- (IBAction)reload {
    
    if (!loading && !loadingMoreVideos) {
        videos = nil;
        players = nil;
        videos = [[NSMutableArray alloc] init];
        players = [[NSMutableArray alloc] init];
        loadedPlayers = 0;
        startIndex = 1;
        
        loading = 1;
        [MBProgressHUD showHUDAddedTo:self.view animated:TRUE];

        [self.tableView reloadData];
        [self parseFeed];
    }
    
}

- (IBAction)showPicker{
    
    [self.view addSubview:picker];    
    self.navigationItem.leftBarButtonItem = OKBtn;
    
}

- (void)loadOneMoreSet {
    
    NSLog(@"Loading another set");
    startIndex += 25;
    [self parseFeed];
    
    /*
    NSString *s = [NSString stringWithFormat:@"Loading videos %d-%d of %d", startIndex, startIndex+24, VIDEOS_NUMBER];
    ShowingBtn.title = s;
    self.navigationItem.leftBarButtonItem = ShowingBtn;
    */
}

- (void)changeStartIndex {
    
    videos = nil;
    players = nil;
    videos = [[NSMutableArray alloc] init];
    players = [[NSMutableArray alloc] init];
    loadedPlayers = 0;
    startIndex = [picker selectedRowInComponent:0]*25+1;
    loading = 1;
    [self.tableView reloadData];
    [self parseFeed];

    NSString *s = [NSString stringWithFormat:@"Showing videos %d-%d of %d", startIndex, startIndex+24, VIDEOS_NUMBER];
    ShowingBtn.title = s;
    self.navigationItem.leftBarButtonItem = ShowingBtn;
    
    [picker removeFromSuperview];
}

#pragma mark PickerView delegate

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    
    return [NSString stringWithFormat:@"Video %d - %d", row*25+1, 25+row*25];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    
    return ceil(VIDEOS_NUMBER/25) + 1;
}


@end


/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
 }   
 else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }   
 }
 
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

