//
//  AboutViewController.m
//  byoblu
//
//  Created by Andrea Barbon on 03/02/12.
//  Copyright (c) 2012 Università degli studi di Padova. All rights reserved.
//

#import "AboutViewController.h"

@implementation AboutViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
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
    
    //[MBProgressHUD showHUDAddedTo:self.view animated:TRUE];

    webView = [[UIWebView alloc] initWithFrame:self.view.frame];
    CGRect rect = webView.frame;
    webView.frame = CGRectMake(0, 0, rect.size.width, rect.size.height);
    webView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin;
    webView.delegate = self;
    
    //Parse
    NSLog(@"Parsing...");

    NSError *error;
    NSString* filePath;

    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        filePath= [[NSBundle mainBundle] pathForResource:@"Claudio" ofType:@"txt"];
    else
        filePath= [[NSBundle mainBundle] pathForResource:@"Claudio_iPhone" ofType:@"txt"];    
    
    HTMLContent = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:&error];
    
    if (HTMLContent == nil)
        NSLog(@"Parsing error: %@", error);
    
    webView.backgroundColor = [UIColor clearColor];

    [self.view addSubview:webView];
    
    [self adjustSize];
    webView.scalesPageToFit = 1;

    
}

- (void)viewWillAppear:(BOOL)animated {
    
    //[self adjustSize];
    
}

- (void)adjustSize {
        
    //webView.scalesPageToFit = 0;

    if (!loading) {
        
        [webView stopLoading];        
        
        self.navigationItem.leftBarButtonItem = nil;
        //webView.hidden = 1;
        
        if (w==0 &&
            ([[UIDevice currentDevice] orientation] == UIDeviceOrientationLandscapeLeft ||
             [[UIDevice currentDevice] orientation] == UIDeviceOrientationLandscapeRight) 
            ){
            
            w = self.view.frame.size.height-40;
            
        }else{
            
            w = self.view.frame.size.width-40;
            
        }
        
        
        NSString *newWidth = [NSString stringWithFormat:@"width=\"%f\" height=\"%f\"", w, w/3.333333];
        
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"height=\"(.*?)\""
                                                                               options:NSRegularExpressionCaseInsensitive
                                                                                 error:nil];
        
        // Replace the matches
        HTMLContent = [regex stringByReplacingMatchesInString:HTMLContent
                                                      options:0
                                                        range:NSMakeRange(0, [HTMLContent length])
                                                 withTemplate:@""];
        
        
        // Create your expression
        regex = 
        [NSRegularExpression regularExpressionWithPattern:@"width=\"(.*?)\""
                                                  options:NSRegularExpressionCaseInsensitive
                                                    error:nil];
        
        // Replace the matches
        HTMLContent = [regex stringByReplacingMatchesInString:HTMLContent
                                                      options:0
                                                        range:NSMakeRange(0, [HTMLContent length])
                                                 withTemplate:newWidth];
        
        
        //NSLog(@"%@", HTMLContent);
        
        loading = 1;
        [webView loadHTMLString:HTMLContent baseURL:nil];
        
    }
        
    
}

#pragma mark WebView delegate

-(BOOL) webView:(UIWebView *)inWeb shouldStartLoadWithRequest:(NSURLRequest *)inRequest navigationType:(UIWebViewNavigationType)inType {
    
    if ( inType == UIWebViewNavigationTypeLinkClicked ) {
        
        //[MBProgressHUD showHUDAddedTo:self.view animated:TRUE];
        webView.hidden = 1;
        loading = 1;
        
        //Create the Back button    
        UIBarButtonItem *btn = [[UIBarButtonItem alloc] 
                                initWithTitle:@"Indietro"                                            
                                style:UIBarButtonItemStyleDone 
                                target:self 
                                action:@selector(adjustSize)];        
        self.navigationItem.leftBarButtonItem = btn;
        
        webView.scalesPageToFit = 1;
        
        return YES;
    }
    
    return YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)web {
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        
        [web stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '100%'"];         
    }
    
    //[MBProgressHUD hideHUDForView:self.view animated:TRUE];
    loading = 0;
    webView.hidden = 0;

}

- (void)webView:(UIWebView *)w didFailLoadWithError:(NSError *)error{
    NSLog(@"Connection problems: %@", error);
    [self adjustSize];
}



- (void)viewDidUnload
{
    [super viewDidUnload];

}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)        
        return (YES);
    else
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {

}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    
    //[self adjustSize];
}

@end
