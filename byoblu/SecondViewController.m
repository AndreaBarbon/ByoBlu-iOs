//
//  SecondViewController.m
//  byoblu
//
//  Created by Andrea Barbon on 06/01/12.
//  Copyright (c) 2012 Università degli studi di Padova. All rights reserved.
//

#import "SecondViewController.h"

@implementation SecondViewController

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}


#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    videos	= [[NSMutableArray alloc] init];	
    data = [[NSMutableData alloc] init];
    
    NSString *user = @"byoblu";
    
    NSString *path = [[NSString alloc] initWithFormat:@"http://gdata.youtube.com/feeds/base/users/%@/uploads?alt=rss&v=2&orderby=published&client=ytapi-youtube-profile", user];
	
	NSLog(@"Path: %@", path);
    NSURLRequest* request = [NSURLRequest requestWithURL:[NSURL URLWithString:path] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
	[NSURLConnection connectionWithRequest:request delegate:self];
    
}

- (void)grabXML {
        
    videos = nil;
	videos	= [[NSMutableArray alloc] init];	
	
    // Create a new rssParser object based on the TouchXML "CXMLDocument" class, this is the
    // object that actually grabs and processes the XML data
    CXMLDocument *doc = [[CXMLDocument alloc] initWithData:data options:0 error:nil];
	
	// Returns all 'level1_item' nodes in an array    
	NSArray *nodes = [[doc rootElement] nodesForXPath:@"//channel" error:nil];
	
	for (CXMLNode *itemNode in nodes)
	{				
		for (CXMLNode *eventNode in [itemNode children])
		{
			if ([[eventNode name] isEqualToString:@"item"]) {
				
				[videos addObject:[eventNode copy]];
				
				NSString *title = [[[videos lastObject] nodeForXPath:@"title" error:nil] stringValue];
                NSLog(@"Title = %@", title);
                NSString *link = [[[videos lastObject] nodeForXPath:@"link" error:nil] stringValue];
                NSLog(@"Link = %@", link);
				
			}
			
		}
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

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}



#pragma mark -
#pragma mark NSURLConnection delegate

- (void)connection:(NSURLConnection *)connection_ didFailWithError:(NSError *)error{
	
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{  
	[data setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data_{ 
	[data appendData:data_];
	
}

- (void)connectionDidFinishLoading:(NSURLConnection*)theConnection {
	
	[NSThread detachNewThreadSelector:@selector(grabXML) toTarget:self withObject:nil];
	
}

@end
