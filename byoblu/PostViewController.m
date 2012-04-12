//
//  PostViewController.m
//  byoblu
//
//  Created by Andrea Barbon on 08/01/12.
//  Copyright (c) 2012 Università degli studi di Padova. All rights reserved.
//

#import "AppDelegate.h"
#import "PostViewController.h"

@implementation PostViewController

@synthesize HTMLContent, url, adBannerView;

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

    }
    return self;
}

-(void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle


-(void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor clearColor];
    
    
    NSError *error;
    NSString *filePath= [[NSBundle mainBundle] pathForResource:@"CSS" ofType:@"txt"];
    NSString *s =  [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:&error];
    
    self.HTMLContent = [s stringByAppendingString:HTMLContent];

    
    //AddThis settings
    [AddThisSDK setFacebookAuthenticationMode:ATFacebookAuthenticationTypeDefault];
    [AddThisSDK setFacebookAPIKey:@"314536821917796"];
    [AddThisSDK setTwitterAuthenticationMode:ATTwitterAuthenticationTypeDefault];
    [AddThisSDK setTwitterConsumerKey:@"yourconsumerkey"];
    [AddThisSDK setTwitterConsumerSecret:@"yourconsumersecret"];
    [AddThisSDK setTwitterCallBackURL:@"yourcallbackurl"];
    
    [AddThisSDK setAddThisPubId:@"ra-4f18a553515566c5"];
    [AddThisSDK setAddThisApplicationId:@"4f18a59c45fb68ca"];
    
    //Add the share button
    btn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction
                                                  target:self
                                                  action:@selector(buttonClicked:event:)];
    self.navigationItem.rightBarButtonItem = btn;
    
    UIScrollView *scrollView = nil;
    for (UIView *subview in [webView subviews]) {
        if ([subview isKindOfClass:[UIScrollView class]]) {  
            scrollView = (UIScrollView *)subview;
            break;
        }
    }
    scrollView.showsHorizontalScrollIndicator = false;
    

    [self adjustSize];
    
    //iAd
    if ([(AppDelegate*)[[UIApplication sharedApplication] delegate] advertisements]) {
        [self createAdBannerView];
        [self.view addSubview:self.adBannerView];
    }
    
    /*
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    CGFloat screenScale = [[UIScreen mainScreen] scale];
    CGSize screenSize = CGSizeMake(screenBounds.size.width * screenScale, screenBounds.size.height * screenScale);
    
    if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)] && [[UIScreen mainScreen] scale] == 2){
        screenSize = CGSizeMake(screenBounds.size.width * screenScale, screenBounds.size.height);
    }
    */
    

    
}

-(void)webViewDidFinishLoad:(UIWebView *)w {
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        
       [w stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '150%'"];         
    }
    
}

-(void)adjustSize {
    
    NSLog(@"Size adjusted");
    
    float w;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        
        w = MIN(self.view.frame.size.width - 20, 700);
        
    }else{
        
        w = MIN(self.view.frame.size.width - 20, 300);
        
    }
    
    
    
    NSString *newWidth = [NSString stringWithFormat:@"width=\"%f\" height=\"%f\"", w, w*9/16];
    
    [webView setFrame:self.view.frame];
    //up=0;
    
    
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
    [webView loadHTMLString:HTMLContent baseURL:nil];

    //[self adjustBannerView];
    [self resizeFrame];
    
    
}

-(void)resizeFrame {
    
    if([self.adBannerView isBannerLoaded]) {
        
        if (!up) {
            CGRect frame =  webView.frame;
            frame.size.height -= self.adBannerView.frame.size.height;
            webView.frame = frame;
            up=YES;
        }
    } else if (up) {
        CGRect frame =  webView.frame;
        frame.size.height += self.adBannerView.frame.size.height;
        webView.frame = frame;
        up=NO;
    }
}

-(void)buttonClicked:(UIBarButtonItem*)sender event:(UIEvent*)event {
    
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        
        CGRect rect = [[[event.allTouches anyObject] view] frame];
        rect = [self.parentViewController.view convertRect:rect toView:nil];
        [AddThisSDK presentAddThisMenuInPopoverForURL:[self.url absoluteString] fromRect:rect withTitle:self.title description:self.title];
        
    }else{
        
        [AddThisSDK presentAddThisMenuForURL:[self.url absoluteString] withTitle:self.title description:self.title];            
        
    }
    
    NSLog(@"Shared URL: %@", [self.url absoluteString]);
    
    
}

-(void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}





#pragma mark - ADBannerViewDelegate

-(void)bannerViewDidLoadAd:(ADBannerView *)banner
{
    [self adjustBannerView];
    [UIView animateWithDuration:0.4 animations:^{
        [self resizeFrame];
    }];
    
}

- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error
{
    [self adjustBannerView];
}

- (BOOL)bannerViewActionShouldBegin:(ADBannerView *)banner willLeaveApplication:(BOOL)willLeave
{
    return YES;
}

- (void)bannerViewActionDidFinish:(ADBannerView *)banner
{
}


- (void)adjustBannerView
{
    
    NSLog(@"Adjusting banner");
    
    CGRect contentViewFrame = self.view.frame;
    CGRect parentViewFrame = self.parentViewController.view.frame;
    CGRect adBannerFrame = self.adBannerView.frame;
    CGSize bannerSize = [ADBannerView sizeFromBannerContentSizeIdentifier:self.adBannerView.currentContentSizeIdentifier];
    
    
    if([self.adBannerView isBannerLoaded])
    {
//        if (!up) {
//            contentViewFrame.size.height = contentViewFrame.size.height - bannerSize.height;
//            up = 1;
//        }
        adBannerFrame.origin.y = contentViewFrame.size.height - bannerSize.height;
        
    }
    else
    {
//        if (up) {
//            contentViewFrame.size.height = contentViewFrame.size.height + bannerSize.height;
//            up = NO;
//        }
        
        adBannerFrame.origin.y = parentViewFrame.size.height;
    }
    
        
    [UIView animateWithDuration:0.4 animations:^{
        self.adBannerView.frame = adBannerFrame;
        self.view.frame= contentViewFrame;
    }];
    
    [self resizeFrame];

    
    
}

- (void)createAdBannerView
{
    self.adBannerView = [[ADBannerView alloc] initWithFrame:CGRectZero];
    CGRect bannerFrame = self.adBannerView.frame;
    bannerFrame.origin.y = self.view.frame.size.height;
    self.adBannerView.frame = bannerFrame;
    self.adBannerView.delegate = self;
    self.adBannerView.requiredContentSizeIdentifiers = [NSSet setWithObjects:ADBannerContentSizeIdentifierPortrait, ADBannerContentSizeIdentifierLandscape, nil];
}



-(void)viewWillAppear:(BOOL)animated {
    
    //up = 0;

    if(UIInterfaceOrientationIsPortrait([self interfaceOrientation]))
        self.adBannerView.currentContentSizeIdentifier = ADBannerContentSizeIdentifierPortrait;
    else
        self.adBannerView.currentContentSizeIdentifier = ADBannerContentSizeIdentifierLandscape;
    
    //[self adjustBannerView];
    
}

-(void)viewDidAppear:(BOOL)animated {
    
    [self adjustSize];
    up = 0;
    [self adjustBannerView];
    
}

-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation{
    
    up = 0;
    [super didRotateFromInterfaceOrientation:fromInterfaceOrientation];
    [self adjustSize];
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{    
    
    if(UIInterfaceOrientationIsPortrait(interfaceOrientation))
        self.adBannerView.currentContentSizeIdentifier = ADBannerContentSizeIdentifierPortrait;
    else
        self.adBannerView.currentContentSizeIdentifier = ADBannerContentSizeIdentifierLandscape;
    
    [self adjustBannerView];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        
        return (YES);
    }
    else {
        if (interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown){
            
            self.adBannerView.currentContentSizeIdentifier = ADBannerContentSizeIdentifierLandscape;
            [self adjustBannerView];
            return NO;
        };
    }
    
    
    
    
    return YES;
    
}


@end
