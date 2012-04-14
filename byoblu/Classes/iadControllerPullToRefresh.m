//
//  iadControllerPullToRefresh.m
//  byoblu
//
//  Created by Andrea Barbon on 28/03/12.
//  Copyright (c) 2012 Università degli studi di Padova. All rights reserved.
//

#import "iadControllerPullToRefresh.h"

@interface iadControllerPullToRefresh ()

@end

@implementation iadControllerPullToRefresh

@synthesize adBannerView;

#pragma mark - ADBannerViewDelegate

- (void)bannerViewDidLoadAd:(ADBannerView *)banner
{
    [self adjustBannerViewAnimated:YES];
    NSLog(@"Ad loaded");
}

- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error
{
    [self adjustBannerViewAnimated:YES];
}

- (BOOL)bannerViewActionShouldBegin:(ADBannerView *)banner willLeaveApplication:(BOOL)willLeave
{
    return YES;
}

- (void)bannerViewActionDidFinish:(ADBannerView *)banner
{
}


- (void)adjustBannerViewAnimated:(BOOL)animated
{        
    contentViewFrame = self.view.frame;
    CGRect parentViewFrame = self.parentViewController.view.frame;
    //CGRect TVFrame = self.tableView.frame;
    CGRect adBannerFrame = self.adBannerView.frame;
    CGSize bannerSize = [ADBannerView sizeFromBannerContentSizeIdentifier:self.adBannerView.currentContentSizeIdentifier];
    
    if([self.adBannerView isBannerLoaded])
    {
        if (up==0) {
            contentViewFrame.size.height = contentViewFrame.size.height - bannerSize.height;
            up = 1;
        }
        adBannerFrame.origin.y = parentViewFrame.size.height - bannerSize.height;

    }
    else
    {
        if (up==1) {
            contentViewFrame.size.height = contentViewFrame.size.height + bannerSize.height;
            up = 0;
        }
        
        adBannerFrame.origin.y = parentViewFrame.size.height;
    }
    
    if (!animated) {
        
        self.adBannerView.frame = adBannerFrame;
        self.view.frame= contentViewFrame;
        
    } else {
        
        [UIView animateWithDuration:0.4 animations:^{
            self.adBannerView.frame = adBannerFrame;
            self.view.frame= contentViewFrame;
        }];
    }

    adBannerView.hidden = NO;
    
}

- (void)createAdBannerView
{
    self.adBannerView = [[ADBannerView alloc] initWithFrame:CGRectZero];
    CGRect bannerFrame = self.adBannerView.frame;
    bannerFrame.origin.y = self.view.frame.size.height;
    self.adBannerView.frame = bannerFrame;
    
    self.adBannerView.delegate = self;
    self.adBannerView.requiredContentSizeIdentifiers = [NSSet setWithObjects:ADBannerContentSizeIdentifierPortrait, ADBannerContentSizeIdentifierLandscape, nil];
    self.adBannerView.backgroundColor = [UIColor clearColor];
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated {

    up = 0;
    
    if(UIInterfaceOrientationIsPortrait([self interfaceOrientation]))
        self.adBannerView.currentContentSizeIdentifier = ADBannerContentSizeIdentifierPortrait;
    else
        self.adBannerView.currentContentSizeIdentifier = ADBannerContentSizeIdentifierLandscape;
    
    if (!iadPresent) {
        [self.parentViewController.view addSubview:self.adBannerView];
        iadPresent = 1;
    }
    
    //[self adjustBannerViewAnimated:NO];

}

-(void)viewDidAppear:(BOOL)animated {
    
    [self adjustBannerViewAnimated:YES];

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    adBannerView.hidden = YES;
    
    //self.tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin;

}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    
    [self adjustBannerViewAnimated:YES];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{    

    if(UIInterfaceOrientationIsPortrait(interfaceOrientation))
        self.adBannerView.currentContentSizeIdentifier = ADBannerContentSizeIdentifierPortrait;
    else
        self.adBannerView.currentContentSizeIdentifier = ADBannerContentSizeIdentifierLandscape;
    
    //[self adjustBannerViewAnimated:NO];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        
        return (YES);
    }
    else {
        if (interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown){
            
            self.adBannerView.currentContentSizeIdentifier = ADBannerContentSizeIdentifierLandscape;
            //[self adjustBannerViewAnimated:NO];
            return NO;
        };
    }
    

    
    
    return YES;

}

@end
