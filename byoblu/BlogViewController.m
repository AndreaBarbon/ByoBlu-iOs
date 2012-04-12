//
//  BlogViewController.m
//  byoblu
//
//  Created by Andrea Barbon on 08/01/12.
//  Copyright (c) 2012 Università degli studi di Padova. All rights reserved.
//

#import "BlogViewController.h"


@implementation BlogViewController

@synthesize feedParser, listaElementi;



#pragma mark - Init and Memory warning


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
    
    self.view.backgroundColor = [UIColor clearColor];
    self.navigationController.navigationBar.backgroundColor = [UIColor blueColor];

    [MBProgressHUD showHUDAddedTo:self.view animated:TRUE];

    //iAd
    if ([(AppDelegate*)[[UIApplication sharedApplication] delegate] advertisements]) {
        [self createAdBannerView];
        [self.parentViewController.view addSubview:self.adBannerView];
        iadPresent = 1;
    }

    
    //Inizilize variables
    listaElementi = [[NSMutableArray alloc] init];
    dataArray = [[NSMutableArray alloc] init];
    images = [[NSMutableArray alloc] init];
    loadedImages = 0;
	df = [[NSDateFormatter alloc] init];            [df setDateFormat:@"dd/MM/yyyy - HH:mm"];
    
    loading = 1;
    
    //Create the Reload button    
    UIBarButtonItem *flipButton = [[UIBarButtonItem alloc] 
                                   initWithTitle:@"Aggiorna"                                            
                                   style:UIBarButtonItemStyleBordered 
                                   target:self 
                                   action:@selector(reload)];
    
    flipButton.image = [UIImage imageNamed:@"refresh_icon.png"];
    
    self.navigationItem.rightBarButtonItem = flipButton;
        
    
    [self parseFeed];
    

    
}

- (IBAction)reload {

    if (!loading) {
        listaElementi = nil;
        dataArray = nil;
        images = nil;
        listaElementi = [[NSMutableArray alloc] init];
        dataArray = [[NSMutableArray alloc] init];
        images = [[NSMutableArray alloc] init];
        loadedImages = 0;

        [MBProgressHUD showHUDAddedTo:self.view animated:TRUE];
        loading = 1;
        [self.tableView reloadData];
        [self parseFeed];
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{

    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
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
        return [listaElementi count];
    }

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int r = indexPath.row;
	static NSString *CellIdentifier = @"Blog";
	BlogCell *cell = (BlogCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        
        NSString *nib;
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
            
            nib = @"BlogCell_iPad";
            
        }else{  
            nib = @"BlogCell";
        }
		NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:nib owner:self options:nil];
		cell = [topLevelObjects objectAtIndex:0];
        cell.title.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        cell.date.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        cell.backgroundColor = [UIColor clearColor];
        cell.backgroundView = nil;


    }


    NSString *date = [df stringFromDate:[[listaElementi objectAtIndex:r] date]];
    
    NSString *s = [[[listaElementi objectAtIndex:r] title] uppercaseString];
    [cell.title setText:s];
    [cell.date setText:date];

    if ([images count] > r) {
        [cell.img setImage:[images objectAtIndex:r]];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
            
            return 180;
            
        }else{  
            return 80;
        }
}

- (NSURL *)imgFromSummary:(NSString *)s {
    
    NSRegularExpression *regex = 
    [NSRegularExpression regularExpressionWithPattern:@"src=\"(.*?)\""
                                              options:NSRegularExpressionCaseInsensitive
                                                error:nil];
    
    NSTextCheckingResult *imgcheck = [regex firstMatchInString:s options:0 range:NSMakeRange(0, [s length])];
    s = [s substringWithRange:[imgcheck rangeAtIndex:1]];
    s = [s stringByConvertingHTMLToPlainText];
    s = [s stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    //NSLog(@"URL: %@", s);
    return [NSURL URLWithString:s];
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{    
    int r = indexPath.row;

    PostViewController *postViewController;

    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
            
            postViewController = [[PostViewController alloc] initWithNibName:@"PostView_iPad" bundle:nil];            
        }else{  
            postViewController = [[PostViewController alloc] initWithNibName:@"postView" bundle:nil];
        }
    
    postViewController.HTMLContent = [[listaElementi objectAtIndex:r] summary];
    
    NSString *s = [[[listaElementi objectAtIndex:r] title] lowercaseString];
    postViewController.navigationItem.title = s;
    
    s = [[listaElementi objectAtIndex:r]link];
    postViewController.url =  [NSURL URLWithString:s];
    NSLog(@"Link = %@", postViewController.url);
    
    [self.adBannerView removeFromSuperview];
    iadPresent = 0;
    [self.navigationController pushViewController:postViewController animated:YES];
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];

         
}


#pragma mark -
#pragma mark NSURLConnection delegate

- (void)connection:(NSURLConnection *)connection_ didFailWithError:(NSError *)error{
	//NSLog(@"Connection error: %@", [error debugDescription]);
    retry++;
    if ( retry < retryTimes ) {
        [self loadAnother];
    } else {
        [self skipImage];
        loadedImages++;
        retry = 0;
        [self loadAnother];
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{  
	[data setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data_{ 
	if (data==nil) { data = [[NSMutableData alloc] initWithCapacity:2048]; } 
	[data appendData:data_];	
}

- (void)connectionDidFinishLoading:(NSURLConnection*)theConnection {
	
    UIImage *img = [UIImage imageWithData:data];
    if (img == nil) {
        [self skipImage];
    } else {
        [images addObject:img];
    }
    data = nil;
    loadedImages += 1;
    //NSLog(@"Loaded #%d", loadedImages);
    [self.tableView reloadData];

    [self loadAnother];
	
}

- (void)skipImage {
    
    NSLog(@"Skipping image #%d", loadedImages);
    UIImage *img = [UIImage imageNamed:@"bg"];
    [images addObject:img];

}

- (void)loadAnother {

    if (loadedImages < [listaElementi count]) {
        NSString *s = [[listaElementi objectAtIndex:loadedImages] summary]; 
        
        NSURLRequest* request = [NSURLRequest requestWithURL:[self imgFromSummary:s] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:TIME_OUT];
        [NSURLConnection connectionWithRequest:request delegate:self];
    }
    
}



#pragma mark - Parsing

- (void)parseFeed {
    
    // Create feed parser and pass the URL of the feed
    NSURL *feedURL = [NSURL URLWithString:@"feed://www.byoblu.com/syndication.axd?format=rss"];
    //feedURL = [NSURL URLWithString:@"feed://www.byoblu.com/syndication.axd?category=1ba92f93-f0e9-46d7-9ea8-05bebfc763e0&lang=it-IT"];
    feedParser = [[MWFeedParser alloc] initWithFeedURL:feedURL];
    // Delegate must conform to `MWFeedParserDelegate`
    feedParser.delegate = self;
    // Parse the feeds info (title, link) and all feed items
    feedParser.feedParseType = ParseTypeFull;    
    // Connection type
    feedParser.connectionType = ConnectionTypeAsynchronously;
    // Begin parsing
    [feedParser parse];
}

- (void)feedParserDidStart:(MWFeedParser *)parser{
    
    NSLog(@"Parsing started!");
    loading = 1;
    
}// Called when data has downloaded and parsing has begun

- (void)feedParser:(MWFeedParser *)parser didParseFeedInfo:(MWFeedInfo *)info{
    
}// Provides info about the feed

- (void)feedParser:(MWFeedParser *)parser didParseFeedItem:(MWFeedItem *)item{
    
    //NSLog(@"Title: %@", item.title);
    //NSLog(@"Content: %@", item.content);
    //NSLog(@"Description: %@", item.description);
    //NSLog(@"summary: %@", item.summary);
    
    NSArray *array = item.enclosures;
    for (int i=0; i<[array count]; i++) {
        NSLog(@"Enclosures: %@, type %@", [[array objectAtIndex:i] objectForKey:@"url"], [[array objectAtIndex:i] objectForKey:@"type"]);
    }
    
    [listaElementi addObject:item];
    
}// Provides info about a feed item

- (void)feedParserDidFinish:(MWFeedParser *)parser{
    
    NSLog(@"Parsing finished! %d items parsed", [listaElementi count]);
    loading = 0;
    [self.tableView reloadData];
    
    if ([listaElementi count]>0) {
        NSString *s = [[listaElementi objectAtIndex:0] summary]; 
        
        NSURLRequest* request = [NSURLRequest requestWithURL:[self imgFromSummary:s] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:TIME_OUT];
        [NSURLConnection connectionWithRequest:request delegate:self];
    }

    //Stop the PullToRefresh
    [self stopLoading];

    
    
}// Parsing complete or stopped at any time by `stopParsing`

- (void)feedParser:(MWFeedParser *)parser didFailWithError:(NSError *)error{
    
    //NSLog(@"Parsing failed :-( , trying again in 1 second");
    [feedParser parse];

    
}// Parsing failed


#pragma mark Ego Pull to refresh

@end


/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
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
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */
