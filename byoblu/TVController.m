//
//  TVController.m
//  byoblu
//
//  Created by Andrea Barbon on 29/03/12.
//  Copyright (c) 2012 Università degli studi di Padova. All rights reserved.
//

#import "TVController.h"

@interface TVController ()

@end

@implementation TVController


#pragma fractal

- (BOOL) webView:(UIWebView *)wv shouldStartLoadWithRequest:(NSURLRequest *)req {

    NSLog(@"%@", [[req URL] absoluteString]);
    return YES; // else load the URL as desired
}

#define MAXRETRY 3

-(void)reload {
    
    self.view.backgroundColor = [UIColor clearColor];
    webView.hidden = 1;
    
    if (RetryTimes<MAXRETRY) {
        webView.hidden = 1;
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:s]]];
        [MBProgressHUD showHUDAddedTo:self.view animated:TRUE];
        RetryTimes++;
    } else {
        [webView stopLoading];
        RetryTimes=0;
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:TRUE];

    //Create the Reload button    
    UIBarButtonItem *flipButton = [[UIBarButtonItem alloc] 
                                   initWithTitle:@"Aggiorna"                                            
                                   style:UIBarButtonItemStyleBordered 
                                   target:self 
                                   action:@selector(reload)];
    
    flipButton.image = [UIImage imageNamed:@"refresh_icon.png"];
    
    self.navigationItem.rightBarButtonItem = flipButton;
    
    
    CGRect frame = self.view.bounds;
    f = MIN(frame.size.width, frame.size.height)-self.tabBarController.tabBar.frame.size.height-self.navigationController.navigationBar.frame.size.height;
    frame.size.height = f;
    frame.size.width = f;

    webView = [[UIWebView alloc] initWithFrame:frame];
    webView.delegate = self;
    webView.backgroundColor = [UIColor blackColor];
    
    //webView.autoresizingMask =  UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
    webView.scalesPageToFit = YES;    
    

    
    s = @"http://byoblu.twww.tv/html5/index.htm?eonair%7C16_9=";
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:s]]];
    

}





#pragma mark WebView delegate

-(void)webView:(UIWebView *)webView_ didFailLoadWithError:(NSError *)error {
    
    [self reload];
    
}

-(void)webViewDidFinishLoad:(UIWebView *)_webView {

    NSLog(@"Did finish loading");
    webView.center = self.view.center;
    [self.view addSubview:webView];   
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    webView.hidden = 0;
    self.view.backgroundColor = [UIColor blackColor];
    RetryTimes=0;



    
    //The setup code (in viewDidLoad in your view controller)
    //CGRect bounds = [[UIScreen mainScreen] bounds];
    
    //[self getButton];
    //[self play];

}

-(void)webViewDidStartLoad:(UIWebView *)webView{
    
    NSLog(@"Did start loading");

}








- (UIButton *)findButtonInView:(UIView *)view {
    UIButton *button = nil;
    
    if ([view isMemberOfClass:[UIButton class]]) {
        return (UIButton *)view;
    }
    
    if (view.subviews && [view.subviews count] > 0) {
        for (UIView *subview in view.subviews) {
            button = [self findButtonInView:subview];
            if (button) return button;
        }
    }
        
    return button;
}



//The event handling method
- (void)handleSingleTap:(UITapGestureRecognizer *)recognizer {
    //CGPoint location = [recognizer locationInView:[recognizer.view superview]];
    
    NSLog(@"Tapped");
    
    if (playing)
        [self stop];
    else
        [self play];
}


-(void)getButton {
    playpause = [self findButtonInView:webView];
    
    //    [playpause addTarget:self 
    //                  action:@selector(pressed:)
    //        forControlEvents:UIControlEventTouchUpInside];
    
}



-(void)stop {
    
    if (playing) {
        NSLog(@"It was playing");
        [playpause sendActionsForControlEvents:UIControlEventTouchUpInside];
        playing = 0;
    }
}

-(void)play {
    
    if (!playing) {
        NSLog(@"It was not playing");
        [playpause sendActionsForControlEvents:UIControlEventTouchUpInside];
        playing = 1;
    }
    
}

-(void)viewWillDisappear:(BOOL)animated {
    
    //[webView loadHTMLString:@"" baseURL:nil];
    //[webView loadHTMLString:s baseURL:nil];
    
}

-(void)viewWillAppear:(BOOL)animated {
    webView.center = self.view.center;   
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (YES);
}

-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    webView.center = self.view.center;
}

@end




/*      
 CGRect frame = self.view.frame;
 //[self.view convertRect:frame toView:nil];
 playView = [[UIView alloc] initWithFrame:frame];
 playView.backgroundColor = [UIColor orangeColor];
 playView.alpha = 0.5;
 */


/*
 float x; 
 float y; 
 
 
 if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
 
 x = webView.frame.size.width-145;
 y = webView.frame.size.height-60;
 
 }else{  
 
 CGRect screenBounds = [[UIScreen mainScreen] bounds];
 CGFloat screenScale = [[UIScreen mainScreen] scale];
 CGSize screenSize = CGSizeMake(screenBounds.size.width * screenScale, screenBounds.size.height * screenScale);
 
 x = screenSize.width-150;
 y = screenSize.height;
 }
 
 NSString *filePath= [[NSBundle mainBundle] pathForResource:@"TVStreaming" ofType:@"txt"];
 s =  [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
 s = [NSString stringWithFormat:s, x, y];
 */



//    UITapGestureRecognizer *singleFingerTap = 
//    [[UITapGestureRecognizer alloc] initWithTarget:self 
//                                            action:@selector(handleSingleTap:)];
//    [webView addGestureRecognizer:singleFingerTap];
//[webView addSubview:playView];

//[webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.byoblu.com/page/La-TV-di-Byoblu.aspx"]]];



