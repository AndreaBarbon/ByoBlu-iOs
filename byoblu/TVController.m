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


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    
    webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    webView.delegate = self;
    webView.backgroundColor = [UIColor blackColor];
    
    [self.view addSubview:webView];    
    webView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin;
    webView.scalesPageToFit = YES;    
    
    
    CGRect frame = self.view.frame;
    
    //[self.view convertRect:frame toView:nil];
    playView = [[UIView alloc] initWithFrame:frame];
    playView.backgroundColor = [UIColor orangeColor];
    playView.alpha = 0.5;
    
    float x; 
    float y; 
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        
        x = webView.frame.size.width-145;
        y = webView.frame.size.height-60;
        
    }else{  
        x = webView.frame.size.width;
        y = webView.frame.size.height;
    }
    
    NSString *filePath= [[NSBundle mainBundle] pathForResource:@"TVStreaming" ofType:@"txt"];
    s =  [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    
    s = [NSString stringWithFormat:s, x, y];
    [webView loadHTMLString:s baseURL:nil];

    
//    UITapGestureRecognizer *singleFingerTap = 
//    [[UITapGestureRecognizer alloc] initWithTarget:self 
//                                            action:@selector(handleSingleTap:)];
//    [webView addGestureRecognizer:singleFingerTap];
    //[webView addSubview:playView];
    
    

    
    NSLog(@"Center=%f", webView.center.y);

    //[webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.byoblu.com/page/La-TV-di-Byoblu.aspx"]]];
    
    
    
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
    
}


#pragma mark WebView delegate

-(void)webView:(UIWebView *)webView_ didFailLoadWithError:(NSError *)error {
    
    [webView loadHTMLString:s baseURL:nil];
    
}

-(void)webViewDidFinishLoad:(UIWebView *)_webView {

    NSLog(@"Did finish loading");
    
    //The setup code (in viewDidLoad in your view controller)
    //CGRect bounds = [[UIScreen mainScreen] bounds];
    
    [self getButton];
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

@end
