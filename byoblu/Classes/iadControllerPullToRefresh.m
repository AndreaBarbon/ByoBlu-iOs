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
    [self adjustBannerView];
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
        
    CGRect contentViewFrame = self.view.frame;
    CGRect parentViewFrame = self.parentViewController.view.frame;
    //CGRect TVFrame = self.tableView.frame;
    CGRect adBannerFrame = self.adBannerView.frame;
    
    if([self.adBannerView isBannerLoaded])
    {
        CGSize bannerSize = [ADBannerView sizeFromBannerContentSizeIdentifier:self.adBannerView.currentContentSizeIdentifier];
        contentViewFrame.size.height = contentViewFrame.size.height - bannerSize.height;
        //TVFrame.size.height = TVFrame.size.height - bannerSize.height;
        adBannerFrame.origin.y = parentViewFrame.size.height - bannerSize.height;
    }
    else
    {
        //CGSize bannerSize = [ADBannerView sizeFromBannerContentSizeIdentifier:self.adBannerView.currentContentSizeIdentifier];
        //contentViewFrame.size.height = contentViewFrame.size.height + bannerSize.height;
        //TVFrame.size.height = TVFrame.size.height + bannerSize.height;
        adBannerFrame.origin.y = parentViewFrame.size.height;
    }
    
    [UIView animateWithDuration:0.4 animations:^{
        self.adBannerView.frame = adBannerFrame;
        self.view.frame= contentViewFrame;
    }];

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

    if(UIInterfaceOrientationIsPortrait([self interfaceOrientation]))
        self.adBannerView.currentContentSizeIdentifier = ADBannerContentSizeIdentifierPortrait;
    else
        self.adBannerView.currentContentSizeIdentifier = ADBannerContentSizeIdentifierLandscape;
    
    //[self adjustBannerView];

}

-(void)viewDidAppear:(BOOL)animated {
    
    [self adjustBannerView];

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
